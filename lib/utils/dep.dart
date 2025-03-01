
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:e_commerce_tech/controllers/language_controller.dart';
import 'package:e_commerce_tech/models/language_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String , Map<String, String>>> init() async{
  final sharePreference = await SharedPreferences.getInstance();
  Get.lazyPut(()=> sharePreference);
  Get.lazyPut(()=> LocalizationController(sharedPreferences: Get.find()));

  Map<String , Map<String, String>> _languages = Map();
  for(LanguageModel languageModel in AppConstants.language){
    String jsonStringValues = await rootBundle.loadString("assets/language/${languageModel.languageCode}.json");
    Map<String, String> _json = Map();
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages["${languageModel.languageCode}_${languageModel.countryCode}"] = _json;
  }
  return _languages;
}