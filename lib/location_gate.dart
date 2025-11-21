import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationGatee extends StatefulWidget {
  final Widget child; // Your HomePage
  const LocationGatee({super.key, required this.child});

  @override
  State<LocationGatee> createState() => _LocationGateState();
}

class _LocationGateState extends State<LocationGatee> {
  bool _checking = true;
  bool _gpsEnabled = false;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkAll();
    Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.enabled) {
        _checkAll();
      }
    });
  }

  Future<void> _checkAll() async {
    setState(() => _checking = true);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();

    _gpsEnabled = serviceEnabled;
    _permissionGranted = (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always);

    // Auto-request permission if not granted
    if (!_permissionGranted) {
      final req = await Geolocator.requestPermission();
      _permissionGranted = (req == LocationPermission.whileInUse ||
          req == LocationPermission.always);
    }

    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_gpsEnabled) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please enable GPS to continue",
                style: GoogleFonts.poppins(fontSize: 17),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                
                height: 45,
                splashColor:  Colors.grey,  
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                onPressed: () {
                  Geolocator.openLocationSettings();
                },
                child: Text("Open GPS Settings", style: GoogleFonts.poppins( color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),),
              ),
            ],
          ),
        ),
      );
    }

    if (!_permissionGranted) {
      return Scaffold(
        body: Center(
          child: const Text("Location permission required to continue."),
        ),
      );
    }

    // EVERYTHING OK → enter the app
    return widget.child;
  }
}
