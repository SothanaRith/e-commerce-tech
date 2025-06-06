import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = "AIzaSyCeg1mvZuONTxxAJZtPJnqdPZfBf2CqpV4"; // Replace with your real key

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  State<LocationSelectScreen> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  LatLng? _selectedLatLng;
  String _currentAddress = '';
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _checkAndFetchCurrentLocation();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _getSuggestions(_searchController.text);
    });
  }

  Future<void> _checkAndFetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        await _setLocation(LatLng(position.latitude, position.longitude));
      }
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  Future<void> _setLocation(LatLng latLng) async {
    try {
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
      final placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      final place = placemarks.first;

      setState(() {
        _selectedLatLng = latLng;
        _currentAddress =
            "${place.country}, ${place.subAdministrativeArea ?? ''} ${place.street ?? ''}".trim();
        _searchController.text = _currentAddress;
        _suggestions.clear();
      });
    } catch (e) {
      debugPrint("Set location error: $e");
    }
  }

  Future<void> _getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&components=country:kh';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          _suggestions = (data['predictions'] as List)
              .map<Map<String, String>>((item) => {
            "description": item['description'] ?? '',
            "place_id": item['place_id'] ?? '',
          })
              .toList();
        });
      } else {
        debugPrint("Autocomplete error: ${data['status']}");
      }
    } catch (e) {
      debugPrint("Autocomplete fetch error: $e");
    }
  }

  Future<void> _selectSuggestion(String placeId) async {
    setState(() => _suggestions = []);
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        await _setLocation(LatLng(lat, lng));
      } else {
        debugPrint("Place details error: ${data['status']}");
      }
    } catch (e) {
      debugPrint("Place details fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text('Select Location', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: radius,
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedLatLng ?? const LatLng(12.5657, 104.9910),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      markers: _selectedLatLng != null
                          ? {
                        Marker(
                          markerId: const MarkerId("selected"),
                          position: _selectedLatLng!,
                        )
                      }
                          : {},
                    ),
                  ),
                ),
                if (_selectedLatLng == null)
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Find your location',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: radius),
              ),
            ),
            if (_suggestions.isNotEmpty)
              Material(
                elevation: 4,
                borderRadius: radius,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final item = _suggestions[index];
                      return ListTile(
                        title: Text(item['description'] ?? ''),
                        onTap: () => _selectSuggestion(item['place_id'] ?? ''),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Location Now", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            TextField(
              enabled: false,
              controller: TextEditingController(text: _currentAddress),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: radius),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(borderRadius: radius),
                ),
                onPressed: () {
                  if (_selectedLatLng != null) {
                    print("Selected: $_currentAddress (${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude})");
                    Navigator.pop(context, {
                      'address': _currentAddress,
                      'latLng': _selectedLatLng,
                    });
                  }
                },
                child: const Text("Select", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}