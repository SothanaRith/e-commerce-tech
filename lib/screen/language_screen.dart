import 'package:country_flags/country_flags.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/login_page/login_screen.dart';
import 'package:e_commerce_tech/screen/nav_bar_screen.dart';
import 'package:e_commerce_tech/screen/welcome_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/controllers/language_controller.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        children: [
          selectLanguage(),
          Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomButtonWidget(
                  title: "continues".tr,
                  width: MediaQuery.of(context).size.width - 30,
                  action: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool? isFirstTime = prefs.getBool('isFirstTime');
                    bool? isLoggedIn = prefs.getBool('isLoggedIn');

                    if (isFirstTime == null || isFirstTime == true) {
                      goOff(this, WelcomeScreen());
                    } else {
                      if (isLoggedIn != null && isLoggedIn == true) {
                        // Already logged in
                        goOff(this, const MainScreen());
                      } else {
                        // Not logged in
                        goOff(this, const WelcomeScreen());
                      }
                    }
                  },
                  buttonStyle: BtnStyle.action,
                ),
              ))
        ],
      ),
    )));
  }
}

Widget selectLanguage() {
  return GetBuilder<LocalizationController>(builder: (logic) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.h1(
              "language".tr,
              customStyle: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 2,
            ),
            AppText.body2(
              "please_choose_language".tr,
              customStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 30,
            ),
            languageButton(
                languageCode: "KH", languageName: "ខ្មែរ", onClickIndex: 1),
            const SizedBox(
              height: 10,
            ),
            languageButton(
                languageCode: "US", languageName: "English", onClickIndex: 0),
            const SizedBox(
              height: 10,
            ),
            languageButton(
                languageCode: "CN", languageName: "中文", onClickIndex: 2),
          ],
        ),
      ),
    );
  });
}

Widget languageButton(
    {required int onClickIndex,
    required String languageCode,
    required String languageName}) {
  return GetBuilder<LocalizationController>(builder: (logic) {
    return GestureDetector(
      onTap: () {
        logic.setLanguage(Locale(
            AppConstants.language[onClickIndex].languageCode,
            AppConstants.language[onClickIndex].countryCode));
        logic.setSelectIndex(onClickIndex);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: theme.primaryColor
                .withOpacity(logic.selectedIndex == onClickIndex ? 0.1 : 0.0),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                color: logic.selectedIndex == onClickIndex
                    ? theme.primaryColor
                    : Colors.grey,
                width: 1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CountryFlag.fromCountryCode(
                    languageCode,
                    width: 35,
                    height: 35,
                    shape: const Circle(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppText.title(
                    languageName,
                    customStyle: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
              Icon(
                logic.selectedIndex == onClickIndex
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                color: logic.selectedIndex == onClickIndex
                    ? theme.primaryColor
                    : Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  });
}

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : Colors.transparent, // Background color changes when selected
          border: Border.all(color: isSelected ? Colors.white : Colors.black),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.0,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
