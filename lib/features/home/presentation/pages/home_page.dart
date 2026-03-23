import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoid/features/giveaway/presentation/pages/giveaway_page.dart';

import '../../domain/entities/user_location_entity.dart';
import '../../domain/entities/nearby_giveaway_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/map_widget.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/home_error_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    /// Initialize map and location on page load
    Future.microtask(() {
      if (mounted) {
        context
            .read<HomeBloc>()
            .add(const InitializeMapAndLocationEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Default location for Mumbai
    const defaultLocation = UserLocationEntity(
      latitude: 19.0760,
      longitude: 72.8777,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            RoundIconButton(
              icon: Icons.search,
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            RoundIconButton(
              icon: Icons.settings,
              onPressed: () {},
            ),
          ],
        ),
        actions: [
          RoundIconButton(
            icon: Icons.notifications,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          RoundIconButton(
            icon: Icons.message,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          RoundIconButton(
            icon: Icons.account_circle,
            onPressed: () {},
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),

      /// 🔥 Using BlocConsumer for UI + Side Effects
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          _handleStateToast(state, context);
        },
        builder: (context, state) {
          return Stack(
            children: [
              /// Map Widget
              _buildMapWidget(state, defaultLocation),

              /// Loading Overlay
              if (state is MapLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

              /// Error Overlay
              if (state is LocationError || state is MapNetworkError)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 80,
                  left: 16,
                  right: 16,
                  child: _buildErrorWidget(state, context),
                ),

              /// New Button at bottom center
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to new page (replace NewPage with your actual page widget)
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GiveawayPage()),
                      );
                    },
                    child: const Text('+ Add Giveaway'),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          context.read<HomeBloc>().add(const RetryLocationEvent());
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  /// 🔥 Toast Handler (Side Effect)
  void _handleStateToast(HomeState state, BuildContext context) {
    String? message;

    if (state is MapLoading) {
      message = 'Loading map...';
    } else if (state is MapLoadedWaitingPermission) {
      message = 'Requesting location permission...';
    } else if (state is LocationLoaded) {
      message = 'Location found!';
    } else if (state is LocationPermissionDenied) {
      message = state.message;
    } else if (state is LocationError) {
      message = state.message;
    } else if (state is MapNetworkError) {
      message = state.message;
    }

    if (message != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  /// Map builder based on state
  Widget _buildMapWidget(
      HomeState state, UserLocationEntity defaultLocation) {
    if (state is LocationLoaded) {
      return MapWidget(
        userLocation: state.location,
        defaultLocation: defaultLocation,
        nearbyGiveaways: state.nearbyGiveaways,
        onNearbyTap: (giveaway) => _showGiveawaySheet(context, giveaway),
      );
    } else if (state is LocationPermissionDenied) {
      return MapWidget(
        userLocation: null,
        defaultLocation: state.defaultLocation,
        nearbyGiveaways: null,
        onNearbyTap: null,
      );
    } else if (state is LocationError) {
      return MapWidget(
        userLocation: null,
        defaultLocation: state.defaultLocation ?? defaultLocation,
        nearbyGiveaways: null,
        onNearbyTap: null,
      );
    } else if (state is MapNetworkError) {
      return MapWidget(
        userLocation: state.lastKnownLocation,
        defaultLocation: state.lastKnownLocation ?? defaultLocation,
        nearbyGiveaways: null,
        onNearbyTap: null,
      );
    } else if (state is MapLoadedWaitingPermission) {
      return MapWidget(
        userLocation: null,
        defaultLocation: state.defaultLocation ?? defaultLocation,
        nearbyGiveaways: null,
        onNearbyTap: null,
      );
    } else {
      return MapWidget(
        userLocation: null,
        defaultLocation: defaultLocation,
        nearbyGiveaways: null,
        onNearbyTap: null,
      );
    }
  }

  void _showGiveawaySheet(BuildContext context, NearbyGiveawayEntity g) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        String fmt(DateTime? d) {
          if (d == null) return '-';
          final local = d.toLocal();
          final s = local.toString();
          return s.substring(0, s.length >= 16 ? 16 : s.length);
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(g.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                if (g.foodType != null) Chip(label: Text(g.foodType!)),
                const SizedBox(width: 8),
                Chip(label: Text(g.quantityEstimate.toString())),
              ]),
              const SizedBox(height: 8),
              Text(g.address),
              const SizedBox(height: 8),
              Text('Start: ${fmt(g.startTime)}'),
              Text('End: ${fmt(g.endTime)}'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Error Card
  Widget _buildErrorWidget(HomeState state, BuildContext context) {
    String errorMessage = '';

    if (state is LocationError) {
      errorMessage = state.message;
    } else if (state is MapNetworkError) {
      errorMessage = state.message;
    }

    return HomeErrorWidget(errorMessage: errorMessage);
  }
}
