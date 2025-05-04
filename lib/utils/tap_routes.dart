import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void goTo(dynamic from, Widget to) {
  final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  debugPrint('''
  ===========================================
  [Navigation Time Log] - $now
  Action: Push to new screen
  From: ${from.runtimeType}
  To: ${to.runtimeType}
  ===========================================
  ''');

  // Force wrap in a builder function
  Get.to(() => to);
}


/// Custom function to replace the current route and log detailed navigation info.
void goOff(dynamic from, dynamic to) {
  final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  debugPrint('''
  ===========================================
  [Navigation Time Log] - $now
  Action: Replacing Current Route
  From: ${from.runtimeType}
  To: ${to.runtimeType}
  ===========================================
  ''');
  Get.offAll(to);
}

/// Custom function to pop the current route and log detailed navigation info.
void popBack(dynamic from) {
  final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  debugPrint('''
  ===========================================
  [Navigation Time Log] - $now
  Action: Popping Current Route
  From: ${from.runtimeType}
  ===========================================
  ''');
  Get.back();
}
