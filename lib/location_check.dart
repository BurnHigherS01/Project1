// A complete Dart file that:
// 1. Requests location permissions silently.
// 2. Gets current latitude & longitude.
// 3. Never shows UI or errors to the user.
// 4. Returns fallback values if permissions fail or GPS unavailable.
//
// This file is usable in Flutter or plain Dart (with Flutter dependencies).
// Add these to pubspec.yaml:
//   geolocator: ^10.0.0
//   permission_handler: ^11.0.0
//
// Usage:
//   final location = await LocationService.getLocation();
//   print(location.latitude);
//   print(location.longitude);

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationDataResult {
  final double latitude;
  final double longitude;
  LocationDataResult(this.latitude, this.longitude);
}

class LocationService {
  static final LocationDataResult _fallback = LocationDataResult(0.0, 0.0);

  static Future<LocationDataResult> getLocation() async {
    try {
      // 1. Request permission silently
      final status = await Permission.location.request();

      // If permission denied OR permanently denied, return fallback silently
      if (!status.isGranted) {
        return _fallback;
      }

      // 2. Ensure location services enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _fallback;
      }

      // 3. Try to get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LocationDataResult(position.latitude, position.longitude);
    } catch (e) {
      // If anything fails, return fallback silently
      return _fallback;
    }
  }
}
