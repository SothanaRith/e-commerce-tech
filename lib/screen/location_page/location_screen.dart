import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
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
          AppText.h3("Where is your Location?"),
          SizedBox(height: 20,),
          AppText.body2("take all  in store to make sure you can get all of this from your hand but it's just your per reviews", textAlign: TextAlign.center,),
          SizedBox(height: 30,),
          CustomButtonWidget(title: "Let's get started!", action: (){
            goOff(this, HomeScreen());
          }, buttonStyle: BtnStyle.normal,)
        ],
      ),
    ),
    );
  }
}
