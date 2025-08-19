import 'dart:convert';
import 'dart:async';
import 'package:e_commerce_tech/controllers/lacation_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = "AIzaSyCeg1mvZuONTxxAJZtPJnqdPZfBf2CqpV4";

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  _LocationSelectScreenState createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  final locationController = Get.put(LocationController());

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
    Future.delayed(Duration.zero, () {
      _checkAndFetchCurrentLocation();
      _searchController.addListener(_onSearchChanged);
    });
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

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        await _setLocation(LatLng(position.latitude, position.longitude));
      }
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  Future<void> _setLocation(LatLng latLng) async {
    try {
      setState(() => _selectedLatLng = latLng);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 12));
      final placemarks = await placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);
      final place = placemarks.first;

      List<String> addressParts = [];
      if (place.name != null && place.name!.isNotEmpty) addressParts.add(
          place.name!);
      if (place.locality != null && place.locality!.isNotEmpty) addressParts
          .add(place.locality!);
      if (place.subAdministrativeArea != null &&
          place.subAdministrativeArea!.isNotEmpty) addressParts.add(
          place.subAdministrativeArea!);
      if (place.street != null && place.street!.isNotEmpty) addressParts.add(
          place.street!);
      if (place.country != null && place.country!.isNotEmpty) addressParts.add(
          place.country!);

      setState(() {
        _currentAddress = addressParts.join(', ').trim();
        _searchController.text = _currentAddress;
        _marker = Marker(
          markerId: const MarkerId("selected"),
          position: latLng,
          infoWindow: InfoWindow(title: _currentAddress),
          draggable: true,
          onDragEnd: _onMarkerDragEnd,
        );
        _suggestions.clear();
      });
    } catch (e) {
      debugPrint("Set location error: $e");
    }
  }

  Future<void> _onMarkerDragEnd(LatLng newPosition) async {
    await _setLocation(newPosition);
  }

  Future<void> _getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          _suggestions =
              (data['predictions'] as List).map<Map<String, String>>((item) {
                return {
                  "description": item['description'] ?? '',
                  "place_id": item['place_id'] ?? '',
                };
              }).toList();
        });
      } else {
        debugPrint("Autocomplete error: ${data}");
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
        await _setLocation(LatLng(location['lat'], location['lng']));
      } else {
        debugPrint("Place details error: ${data['status']}");
      }
    } catch (e) {
      debugPrint("Place details fetch error: $e");
    }
  }

  Future<void> _onMapTapped(LatLng latLng) async {
    await _setLocation(latLng);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      // make sure the scaffold resizes when keyboard appears
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(type: this, title: "select_location".tr, context: context),

      body: SafeArea(
        child: Column(
          children: [
            // Map section can shrink when keyboard is open
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: radius,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedLatLng ?? const LatLng(12.5657, 104.9910),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      markers: _marker != null ? {_marker!} : {},
                      onTap: _onMapTapped,
                      // OPTIONAL: dismiss keyboard when tapping map
                      onCameraMoveStarted: () => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  if (_selectedLatLng == null)
                    const Positioned.fill(child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),

            // Input + suggestions; lift above keyboard using bottom padding
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    label: "find_your_location".tr,
                    controller: _searchController,
                  ),

                  if (_suggestions.isNotEmpty)
                    Material(
                      elevation: 4,
                      borderRadius: radius,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
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

            // Extra spacer so the input/suggestions aren't jammed against the button
            SizedBox(height: 8),
          ],
        ),
      ),

      // Push the bottom button above the keyboard smoothly
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 18, left: 18, right: 18, top: 18),
        child: GetBuilder<LocationController>(builder: (logic) {
          if (logic.isLoading) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: CustomButtonWidget(
              title: "selected".tr,
              buttonStyle: BtnStyle.action,
              action: () async {
                if (_selectedLatLng != null) {
                  final placemarks = await placemarkFromCoordinates(
                      _selectedLatLng!.latitude, _selectedLatLng!.longitude);
                  final place = placemarks.first;
                  if ((place.country ?? '').toLowerCase() != 'cambodia') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("your delivery location must be in cambodia".tr)),
                    );
                    return;
                  }
                }
                if (_selectedLatLng != null && _currentAddress.isNotEmpty) {
                  locationController.createAddress(
                    street: _currentAddress,
                    isDefault: true,
                    context: context,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("please_select_a_valid_location".tr)),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
