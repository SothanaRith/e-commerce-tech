import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/screen/notification_page/notification_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class HomeTopBarScreenWidget extends StatefulWidget {
  final int unReadNotification;
  const HomeTopBarScreenWidget({super.key, required this.unReadNotification});

  @override
  State<HomeTopBarScreenWidget> createState() => _HomeTopBarScreenWidgetState();
}

class _HomeTopBarScreenWidgetState extends State<HomeTopBarScreenWidget> {
  CartController cartController = Get.put(CartController());
  String currentAddress = "Loading...";
  bool locationFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    cartController.fetchTotalItemsInCart(context: context);
  }

  Future<void> _fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        final place = placemarks.first;

        setState(() {
          currentAddress = "${place.locality ?? ''}, ${place.country ?? ''}".trim();
          locationFetched = true;
        });
      } else {
        setState(() => currentAddress = "Permission denied");
      }
    } catch (e) {
      setState(() => currentAddress = "Failed to fetch location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.body(" Location", customStyle: TextStyle(color: theme.highlightColor)),
            Row(
              children: [
                SvgPicture.asset("assets/images/icons/pin_notification.svg"),
                const SizedBox(width: 5),
                AppText.title2(currentAddress),
              ],
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                goTo(this, CheckOutScreen());
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: theme.highlightColor.withAlpha(40),
                    ),
                    child: Icon(Icons.shopping_cart_rounded, size: 20,),
                  ),
                  if(cartController.totalItemsInCart != 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            border: Border.all(width: 2, color: Colors.white)
                        ),
                        child: AppText.caption(cartController.totalItemsInCart.toString(), customStyle: TextStyle(color: Colors.white),),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 3,),
            GestureDetector(
              onTap: () {
                goTo(this, NotificationScreen());
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: theme.highlightColor.withAlpha(40),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/icons/notification.svg',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  if(widget.unReadNotification != 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        border: Border.all(width: 2, color: Colors.white)
                      ),
                      child: AppText.caption(widget.unReadNotification.toString(), customStyle: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
