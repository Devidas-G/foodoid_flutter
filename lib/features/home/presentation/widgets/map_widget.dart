import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/user_location_entity.dart';
import '../../domain/entities/nearby_giveaway_entity.dart';

class MapWidget extends StatefulWidget {
  /// User's current location, if null shows default location
  final UserLocationEntity? userLocation;

  /// Default location to show when user location is not available
  final UserLocationEntity defaultLocation;

  /// Callback when map controller is ready
  final Function(MapController)? onMapReady;

  /// Callback when user taps the map
  final void Function(LatLng)? onMapTap;
  /// Callback when a nearby giveaway marker is tapped
  final void Function(NearbyGiveawayEntity)? onNearbyTap;
  /// Optional list of nearby giveaways to show as markers
  final List<NearbyGiveawayEntity>? nearbyGiveaways;

  const MapWidget({
    super.key,
    this.userLocation,
    required this.defaultLocation,
    this.onMapReady,
    this.onMapTap,
    this.onNearbyTap,
    this.nearbyGiveaways,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // When location is found, animate map to that location
    if (oldWidget.userLocation == null && widget.userLocation != null) {
      _animateToLocation(widget.userLocation!);
    }
  }

  void _animateToLocation(UserLocationEntity location) {
    final targetLocation = LatLng(location.latitude, location.longitude);
    _mapController.move(targetLocation, 15);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use user location if available, otherwise use default
    final displayLocation = widget.userLocation ?? widget.defaultLocation;
    final center =
        LatLng(displayLocation.latitude, displayLocation.longitude);

    final List<Marker> markers = [];

    // user / center marker
    markers.add(Marker(
      point: center,
      width: 40,
      height: 40,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.userLocation != null ? Colors.blue : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.my_location,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    ));

    // Add nearby giveaway markers if provided
    if (widget.nearbyGiveaways != null) {
      for (final g in widget.nearbyGiveaways!) {
        if (g.coordinates.length >= 2) {
          final lat = g.coordinates[0];
          final lng = g.coordinates[1];
          markers.add(Marker(
            point: LatLng(lat, lng),
            width: 36,
            height: 36,
            child: GestureDetector(
              onTap: () {
                widget.onNearbyTap?.call(g);
              },
              child: Column(
                children: [
                  Icon(Icons.restaurant, color: Colors.redAccent, size: 22),
                ],
              ),
            ),
          ));
        }
      }
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 15,
        onMapReady: () {
          widget.onMapReady?.call(_mapController);
        },
        onTap: (tapPosition, point) {
          widget.onMapTap?.call(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.example.foodoid',
        ),
        MarkerLayer(markers: markers),
          ],
        );
  }
}
