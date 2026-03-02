import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_location_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/map_widget.dart';
import '../widgets/round_icon_button.dart';

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
      );
    } else if (state is LocationPermissionDenied) {
      return MapWidget(
        userLocation: null,
        defaultLocation: state.defaultLocation,
      );
    } else if (state is LocationError) {
      return MapWidget(
        userLocation: null,
        defaultLocation: state.defaultLocation ?? defaultLocation,
      );
    } else if (state is MapNetworkError) {
      return MapWidget(
        userLocation: state.lastKnownLocation,
        defaultLocation: state.lastKnownLocation ?? defaultLocation,
      );
    } else if (state is MapLoadedWaitingPermission) {
      return MapWidget(
        userLocation: null,
        defaultLocation: state.defaultLocation ?? defaultLocation,
      );
    } else {
      return MapWidget(
        userLocation: null,
        defaultLocation: defaultLocation,
      );
    }
  }

  /// Error Card
  Widget _buildErrorWidget(HomeState state, BuildContext context) {
    String errorMessage = '';

    if (state is LocationError) {
      errorMessage = state.message;
    } else if (state is MapNetworkError) {
      errorMessage = state.message;
    }

    return Card(
      color: Colors.red.shade900,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeBloc>().add(const RetryLocationEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}