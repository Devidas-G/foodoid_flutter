import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/user_location_entity.dart';

class MapWidget extends StatefulWidget {
  /// User's current location, if null shows default location
  final UserLocationEntity? userLocation;

  /// Default location to show when user location is not available
  final UserLocationEntity defaultLocation;

  /// Callback when map controller is ready
  final Function(MapController)? onMapReady;

  /// Callback when user taps the map
  final void Function(LatLng)? onMapTap;

  const MapWidget({
    super.key,
    this.userLocation,
    required this.defaultLocation,
    this.onMapReady,
    this.onMapTap,
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
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 40,
              height: 40,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.userLocation != null
                          ? Colors.blue
                          : Colors.grey,
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
                      widget.userLocation != null
                          ? Icons.my_location
                          : Icons.location_off,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
