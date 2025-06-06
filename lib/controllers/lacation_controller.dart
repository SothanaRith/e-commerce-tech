import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = "AIzaSyCeg1mvZuONTxxAJZtPJnqdPZfBf2CqpV4"; // Replace with your real key

class LocationController extends GetxController {
  Rx<LatLng?> selectedLatLng = Rx<LatLng?>(null);
  RxString currentAddress = ''.obs;
  RxList<Map<String, String>> suggestions = <Map<String, String>>[].obs;
  Timer? debounce;
  Rx<Marker?> marker = Rx<Marker?>(null);

  // Fetch current location of the user
  Future<void> fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        await setLocation(LatLng(position.latitude, position.longitude));
      }
    } catch (e) {
      print("Location error: $e");
    }
  }

  // Set location and update address and marker
  Future<void> setLocation(LatLng latLng) async {
    try {
      selectedLatLng.value = latLng;

      // Fetch the address from coordinates
      final placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      final place = placemarks.first;

      List<String> addressParts = [];
      if (place.name != null) addressParts.add(place.name!);
      if (place.locality != null) addressParts.add(place.locality!);
      if (place.subAdministrativeArea != null) addressParts.add(place.subAdministrativeArea!);
      if (place.street != null) addressParts.add(place.street!);
      if (place.country != null) addressParts.add(place.country!);

      currentAddress.value = addressParts.join(', ').trim();

      // Update marker
      marker.value = Marker(
        markerId: const MarkerId("selected"),
        position: latLng,
        infoWindow: InfoWindow(title: currentAddress.value),
      );
    } catch (e) {
      print("Set location error: $e");
    }
  }

  // Fetch suggestions from Google Places API
  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        suggestions.value = (data['predictions'] as List)
            .map<Map<String, String>>((item) => {
          "description": item['description'] ?? '',
          "place_id": item['place_id'] ?? '',
        })
            .toList();
      } else {
        print("Autocomplete error: ${data}");
      }
    } catch (e) {
      print("Autocomplete fetch error: $e");
    }
  }

  // Select a suggestion from the list
  Future<void> selectSuggestion(String placeId) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        await setLocation(LatLng(lat, lng));
      } else {
        print("Place details error: ${data['status']}");
      }
    } catch (e) {
      print("Place details fetch error: $e");
    }
  }
}
