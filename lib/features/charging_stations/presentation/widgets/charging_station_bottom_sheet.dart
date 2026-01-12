import 'package:ev_app/core/di/injection_container.dart';
import 'package:ev_app/core/services/map_navigation_service.dart';
import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/custom_buttons.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/charging_station_info_item.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/connectors_power_info.dart';
import 'package:flutter/material.dart';

class ChargingStationBottomSheet extends StatefulWidget {
  const ChargingStationBottomSheet({super.key, required this.station});

  final ChargingStationModel station;

  @override
  State<ChargingStationBottomSheet> createState() =>
      _ChargingStationBottomSheetState();
}

class _ChargingStationBottomSheetState
    extends State<ChargingStationBottomSheet> {
  bool _isNavigating = false;

  /// Handles the navigation button tap.
  ///
  /// This method:
  /// 1. Closes the bottom sheet immediately
  /// 2. Retrieves the user's current location
  /// 3. Opens the map application with navigation directions
  /// 4. Provides user feedback for errors
  Future<void> _handleNavigationTap(BuildContext context) async {
    // Close the bottom sheet immediately
    // if (!mounted) return;
    // Navigator.of(context).pop();

    // Get services from dependency injection
    // final locationService = sl<LocationService>();
    final mapNavigationService = sl<MapNavigationService>();

    try {
      // Show loading indicator (optional - you can use a global loading overlay)
      // For now, we'll just handle the async operation

      // Get current location
      // final position = await locationService.getCurrentLocation();

      // Open map navigation
      await mapNavigationService.navigateToLocation(
        destinationLat: widget.station.latitude,
        destinationLng: widget.station.longitude,
        destinationLabel: widget.station.name,
      );
    } catch (e) {
      // Show error feedback to user
      if (!context.mounted) return;

      String errorMessage;
      if (e.toString().contains('Location services are disabled')) {
        errorMessage = 'Please enable location services to navigate';
      } else if (e.toString().contains('Location permissions are denied')) {
        errorMessage = 'Location permission is required for navigation';
      } else if (e.toString().contains(
        'Location permissions are permanently denied',
      )) {
        errorMessage =
            'Please enable location permission in app settings to navigate';
      } else if (e.toString().contains('Could not open map application')) {
        errorMessage = 'Unable to open map application';
      } else {
        errorMessage = 'Failed to start navigation. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: SizeConfig.screenWidth! * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.station.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                widget.station.address,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
              VerticalSpace(3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChargingStationInfoItem(
                    icon: Icons.power,
                    data:
                        '${widget.station.connections.length} available connectors',
                  ),
                  VerticalSpace(1),
                  ChargingStationInfoItem(
                    icon: Icons.electric_bolt_sharp,
                    data: 'Connection Estimated Power',
                  ),
                  VerticalSpace(0.5),
                  ConnectorsPowerInfo(connections: widget.station.connections),
                ],
              ),
              VerticalSpace(2),
              SizedBox(
                height: 50,
                child: CustomGenralButton(
                  text: 'Directions',
                  isLoading: _isNavigating,
                  onTap:
                      _isNavigating
                          ? null
                          : () => _handleNavigationTap(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
