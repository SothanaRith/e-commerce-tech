import 'dart:convert';
import 'dart:async';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = "AIzaSyCeg1mvZuONTxxAJZtPJnqdPZfBf2CqpV4"; // Replace with your real key

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  _LocationSelectScreenState createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  LatLng? _selectedLatLng;
  String _currentAddress = '';
  List<Map<String, String>> _suggestions = [];
  Timer? _debounce;
  Marker? _marker;
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _checkAndFetchCurrentLocation();
    _searchController.addListener(_onSearchChanged); // Listen for text changes
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Debounce function for the search
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _getSuggestions(_searchController.text); // Fetch suggestions based on input
    });
  }

  // Check and fetch current location of the user
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

  // Set the location on the map and update the search controller
  // Dynamically build the address string based on available components
  Future<void> _setLocation(LatLng latLng) async {
    try {
      setState(() {
        _selectedLatLng = latLng;
      });

      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15)); // Center the map at the new location
      final placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      final place = placemarks.first;

      // Dynamically create address by including available components
      List<String> addressParts = [];

      // Check and add each component if it's not null or empty
      if (place.name != null && place.name!.isNotEmpty) {
        addressParts.add(place.name!);
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        addressParts.add(place.locality!);
      }
      if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
        addressParts.add(place.subAdministrativeArea!);
      }
      if (place.street != null && place.street!.isNotEmpty) {
        addressParts.add(place.street!);
      }
      if (place.country != null && place.country!.isNotEmpty) {
        addressParts.add(place.country!);
      }

      // Join all the available components with a comma
      setState(() {
        _currentAddress = addressParts.join(', ').trim();
        _searchController.text = _currentAddress; // Update the search field with the address
      });

      // Add marker on map with the dynamic address
      setState(() {
        _marker = Marker(
          markerId: const MarkerId("selected"),
          position: latLng,
          infoWindow: InfoWindow(title: _currentAddress),
          draggable: true, // Allow dragging the marker
          onDragEnd: (newPosition) {
            _onMarkerDragEnd(newPosition); // Handle marker drag
          },
        );
      });
      _suggestions.clear(); // Clear suggestions after setting location
    } catch (e) {
      debugPrint("Set location error: $e");
    }
  }

  // Handle marker drag end
  Future<void> _onMarkerDragEnd(LatLng newPosition) async {
    await _setLocation(newPosition); // Update location and address after marker drag
  }

  // Fetch location suggestions from Google Places API
  Future<void> _getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []); // Clear suggestions if input is empty
      return;
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey'; // Removed country filter
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
        debugPrint("Autocomplete error: ${data}");
      }
    } catch (e) {
      debugPrint("Autocomplete fetch error: $e");
    }
  }

  // Select a suggestion and update the map location
  Future<void> _selectSuggestion(String placeId) async {
    setState(() => _suggestions = []); // Clear suggestions after selection
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        await _setLocation(LatLng(lat, lng)); // Update the map and address with the selected location
      } else {
        debugPrint("Place details error: ${data['status']}");
      }
    } catch (e) {
      debugPrint("Place details fetch error: $e");
    }
  }

  // Handle map drag to move the marker and update address
  Future<void> _onMapTapped(LatLng latLng) async {
    await _setLocation(latLng); // Update the marker and center map at the new position
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);

    return Scaffold(
      appBar: customAppBar(type: this, title: "Select Location", context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: radius,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 1.8,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedLatLng ?? const LatLng(12.5657, 104.9910),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      markers: _marker != null ? {_marker!} : {},
                      onTap: _onMapTapped, // Allow tapping on map to move marker
                    ),
                  ),
                ),
                if (_selectedLatLng == null)
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextField(label: "Find your location",
            controller: _searchController,
              rightIcon: Icon(Icons.search, color: theme.primaryColor,),
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomButtonWidget(
            title: "Selected",
            action: () {
              if (_selectedLatLng != null) {
                print("Selected: $_currentAddress (${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude})");
              }
            },
          ),
        ),
      ),
    );
  }
}
