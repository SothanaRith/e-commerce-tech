import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/location_page/location_select_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    // Check the current location permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // If the permission is denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // If the permission is granted, navigate to the location select screen
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      // User has granted permission, navigate to LocationSelectScreen
      goOff(this, LocationSelectScreen());
    } else {
      // User has denied permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission is required to proceed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width / 2,
              height: MediaQuery.sizeOf(context).width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width / 2),
                  color: theme.highlightColor
              ),
              child: Icon(Icons.location_on, color: theme.primaryColor, size: 120,),
            ),
            SizedBox(height: 30,),
            AppText.h3("where_is_your_location_?".tr),
            SizedBox(height: 20,),
            AppText.body2("take_all_in_store_to_make_sure_you_can_get_all_of_this_from_your_hand_but_it_s_just_your_per_reviews".tr, textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            CustomButtonWidget(
              title: "let_s_get_started_!".tr,
              action: _checkAndRequestLocationPermission, // Use this method to check permissions
              buttonStyle: BtnStyle.normal,
            )
          ],
        ),
      ),
    );
  }
}
