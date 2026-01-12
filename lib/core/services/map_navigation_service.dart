import 'package:url_launcher/url_launcher.dart';

/// Service for handling map navigation to specific coordinates.
///
/// This service provides methods to open external map applications
/// with navigation directions from the user's current location to
/// a specified destination.
class MapNavigationService {
  /// Opens the device's default map application with navigation directions.
  ///
  /// This method attempts to open navigation in the following order:
  /// 1. Google Maps (if installed)
  /// 2. Apple Maps (on iOS devices)
  /// 3. Default browser with Google Maps web
  ///
  /// Parameters:
  /// - [destinationLat]: Latitude of the destination
  /// - [destinationLng]: Longitude of the destination
  /// - [destinationLabel]: Optional label for the destination (e.g., station name)
  ///
  /// Throws:
  /// - [Exception] if unable to open any map application
  Future<void> navigateToLocation({
    required double destinationLat,
    required double destinationLng,
    String? destinationLabel,
  }) async {
    // Encode the label for URL if provided
    final label =
        destinationLabel != null ? Uri.encodeComponent(destinationLabel) : '';

    // Try Google Maps first (works on both Android and iOS if app is installed)
    final googleMapsUrl = Uri.parse(
      'google.navigation:q=$destinationLat,$destinationLng&label=$label',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }

    // Try Apple Maps (iOS)
    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$destinationLat,$destinationLng&dirflg=d',
    );

    if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }

    // Fallback to Google Maps web
    final webMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving',
    );

    if (await canLaunchUrl(webMapsUrl)) {
      await launchUrl(webMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }

    // If all attempts fail, throw an exception
    throw Exception('Could not open map application');
  }

  /// Opens the device's default map application to show a location.
  ///
  /// This is a simpler version that just shows the location without navigation.
  ///
  /// Parameters:
  /// - [latitude]: Latitude of the location
  /// - [longitude]: Longitude of the location
  /// - [label]: Optional label for the location
  ///
  /// Throws:
  /// - [Exception] if unable to open any map application
  Future<void> showLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final encodedLabel = label != null ? Uri.encodeComponent(label) : '';

    final url = Uri.parse(
      'geo:$latitude,$longitude?q=$latitude,$longitude($encodedLabel)',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return;
    }

    // Fallback to web
    final webUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      return;
    }

    throw Exception('Could not open map application');
  }
}
