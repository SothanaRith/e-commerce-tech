import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/language_screen.dart';
import 'package:e_commerce_tech/screen/location_page/location_screen.dart';
import 'package:e_commerce_tech/screen/login_page/login_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/profile_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 30, bottom: 5),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 2,
                        height: MediaQuery.sizeOf(context).width / 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width / 1.5),
                            color: Colors.green
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width / 4, bottom: 5),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 1.5,
                        height: MediaQuery.sizeOf(context).width / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width / 1.5),
                            color: Colors.green
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppText.h3("The"),
                          AppText.h3(" Snap Buy", customStyle: TextStyle(color: theme.primaryColor),),
                        ],
                      ),
                      AppText.h3("makes_you_look_your_best".tr),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 27),
                  child: AppText.body2("take_all_in_store_to_make_sure_you_can_get_all_of_this_from_your_hand_but_it’s_just_your_per_reviews".tr, customStyle: TextStyle(color: theme.highlightColor), textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomButtonWidget(title: "let_s_get_started_!".tr, action: (){
                    goOff(this, LocationScreen());
                  }, buttonStyle: BtnStyle.action,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.title2("already_have_an_account_?".tr, customStyle: TextStyle(color: theme.highlightColor),),
                      GestureDetector(
                          onTap: () {
                            goOff(this, LoginScreen());
                          },
                          child: AppText.title2('sign_in'.tr, customStyle: TextStyle(color: theme.primaryColor),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
