import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/user_location_entity.dart';
import '../bloc/giveaway_bloc.dart';
import '../widgets/map_widget.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultLocation = UserLocationEntity(
      latitude: 19.0760,
      longitude: 72.8777,
    );
    return BlocBuilder<GiveawayBloc, GiveawayState>(
      builder: (context, state) {
        UserLocationEntity? currentLocation;
        String statusText =
            'Tap the map to choose a location, or use current location.';

        if (state is LocationLoaded) {
          currentLocation = state.location;
          statusText =
              'Selected: ${currentLocation.latitude.toStringAsFixed(5)}, ${currentLocation.longitude.toStringAsFixed(5)}';
        } else if (state is LocationPermissionDenied) {
          currentLocation = state.defaultLocation;
          statusText = 'Permission denied. Using default location.';
        } else if (state is LocationError) {
          currentLocation = state.defaultLocation;
          statusText = 'Error getting location. Using default.';
        } else if (state is MapLoadedWaitingPermission) {
          currentLocation = state.defaultLocation;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: _buildMapWidget(state, defaultLocation, context),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(statusText)),
                IconButton(
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: state is LocationLoading
                      ? null
                      : () {
                          context.read<GiveawayBloc>().add(
                            const GetCurrentLocationEvent(),
                          );
                        },
                  icon: state is LocationLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Map builder based on state
Widget _buildMapWidget(
  GiveawayState state,
  UserLocationEntity defaultLocation,
  BuildContext context,
) {
  void _handleMapTap(LatLng point) {
    final location = UserLocationEntity(
      latitude: point.latitude,
      longitude: point.longitude,
    );
    context.read<GiveawayBloc>().add(SelectLocationEvent(location));
  }

  if (state is LocationLoaded) {
    return MapWidget(
      userLocation: state.location,
      defaultLocation: defaultLocation,
      onMapTap: _handleMapTap,
    );
  } else if (state is LocationPermissionDenied) {
    return MapWidget(
      userLocation: null,
      defaultLocation: state.defaultLocation,
      onMapTap: _handleMapTap,
    );
  } else if (state is LocationError) {
    return MapWidget(
      userLocation: null,
      defaultLocation: state.defaultLocation ?? defaultLocation,
      onMapTap: _handleMapTap,
    );
  } else if (state is MapNetworkError) {
    return MapWidget(
      userLocation: state.lastKnownLocation,
      defaultLocation: state.lastKnownLocation ?? defaultLocation,
      onMapTap: _handleMapTap,
    );
  } else if (state is MapLoadedWaitingPermission) {
    return MapWidget(
      userLocation: null,
      defaultLocation: state.defaultLocation ?? defaultLocation,
      onMapTap: _handleMapTap,
    );
  } else if (state is LocationLoading) {
    return MapWidget(
      userLocation: null,
      defaultLocation: state.defaultLocation ?? defaultLocation,
      onMapTap: _handleMapTap,
    );} else {
    return MapWidget(
      userLocation: null,
      defaultLocation: defaultLocation,
      onMapTap: _handleMapTap,
    );
  }
}
