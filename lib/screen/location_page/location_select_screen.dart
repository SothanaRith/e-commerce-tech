import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  State<LocationSelectScreen> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  late Position _currentPosition;
  bool _isPermissionGranted = false;
  bool _isPermissionRequesting = false;
  bool _isPermissionDeniedPermanently = false;

  @override
  void initState() {
    super.initState();
    _checkPermission(); // Check location permission when the screen is loaded
  }

  // Check and request location permissions
  Future<void> _checkPermission() async {
    if (_isPermissionRequesting) return;
    setState(() {
      _isPermissionRequesting = true;
    });

    // Check the current status of the location permission
    PermissionStatus permission = await Permission.location.status;

    if (permission == PermissionStatus.granted) {
      setState(() {
        _isPermissionGranted = true;
        _isPermissionDeniedPermanently = false;
      });
      _getCurrentLocation(); // Fetch the current location if permission is granted
    } else if (permission == PermissionStatus.denied) {
      // Request permission if denied
      permission = await Permission.location.request();
      if (permission == PermissionStatus.granted) {
        setState(() {
          _isPermissionGranted = true;
          _isPermissionDeniedPermanently = false;
        });
        _getCurrentLocation();
      } else {
        setState(() {
          _isPermissionGranted = false;
          _isPermissionDeniedPermanently = permission == PermissionStatus.permanentlyDenied;
        });
      }
    }
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Current Location: $_currentPosition");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Permission Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isPermissionGranted
                  ? 'Location permission granted!'
                  : _isPermissionDeniedPermanently
                  ? 'Permission permanently denied. Open settings to enable.'
                  : 'Location permission not granted. Requesting...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            if (!_isPermissionGranted)
              ElevatedButton(
                onPressed: _checkPermission,
                child: const Text('Request Permission'),
              ),
            if (_isPermissionGranted)
              Text('Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}'),
          ],
        ),
      ),
    );
  }
}
