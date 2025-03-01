import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/controllers/language_controller.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LocalizationController>(builder: (logic) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 160,),
                Text("home".tr),
                const SizedBox(height: 30,),
                ElevatedButton(onPressed: () {
                  logic.setLanguage(Locale(AppConstants.language[0].languageCode,AppConstants.language[0].countryCode));
                  logic.setSelectIndex(0);
                }, child: Text("english".tr)),
                const SizedBox(height: 30,),
                ElevatedButton(onPressed: () {
                  logic.setLanguage(Locale(AppConstants.language[1].languageCode,AppConstants.language[1].countryCode));
                  logic.setSelectIndex(1);
                }, child: Text("khmer".tr)),
                const SizedBox(height: 30,),
                ElevatedButton(onPressed: () {
                  logic.setLanguage(Locale(AppConstants.language[2].languageCode,AppConstants.language[2].countryCode));
                  logic.setSelectIndex(2);
                }, child: Text("japan".tr)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
