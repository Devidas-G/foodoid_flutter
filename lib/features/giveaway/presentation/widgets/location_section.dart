import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_location_entity.dart';
import '../bloc/giveaway_bloc.dart';
import '../widgets/map_widget.dart';

class LocationSection extends StatelessWidget {
  final Function(UserLocationEntity) onLocationSelected;

  const LocationSection({
    super.key,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiveawayBloc, GiveawayState>(
      builder: (context, state) {
        UserLocationEntity? currentLocation;
        String statusText = 'Tap the map to choose a location, or use current location.';

        if (state is LocationLoaded) {
          currentLocation = state.location;
          statusText = 'Selected: ${currentLocation.latitude.toStringAsFixed(5)}, ${currentLocation.longitude.toStringAsFixed(5)}';
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
            Text(
              'Location',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: MapWidget(
                userLocation: currentLocation,
                defaultLocation: const UserLocationEntity(
                  latitude: 19.0760,
                  longitude: 72.8777,
                ),
                onMapTap: (point) {
                  final location = UserLocationEntity(
                    latitude: point.latitude,
                    longitude: point.longitude,
                  );
                  onLocationSelected(location);
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(statusText),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.read<GiveawayBloc>().add(const GetCurrentLocationEvent());
                  },
                  icon: const Icon(Icons.my_location),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}