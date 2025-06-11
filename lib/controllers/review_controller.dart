import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../helper/rest_api_helper.dart';

class ReviewController extends GetxController {

  final apiRepository = ApiRepository();

  List<File> imageSelectedList = [];

  Future<void> createReview({
    required String comment,
    required String rating,
    required String productId,
    List<File>? images,
    required BuildContext context,
  }) async {
    String url = '$mainPoint/api/product/create-reviews';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    String? token = TokenStorage.token;
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add text fields
    request.fields['userId'] = UserStorage.currentUser?.id.toString() ?? '';
    request.fields['productId'] = productId;
    request.fields['rating'] = rating;
    request.fields['comment'] = comment;

    // Add image files
    if (images != null && images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'images', // Or just 'images' depending on backend
          XFile(images[i].path).path,
        ));
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () {
            popBack(this);
          },
        );
      } else {
        final jsonData = jsonDecode(response.body);
        showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${jsonData["message"]}",
        );
      }
    } catch (e) {
      print('Exception: $e');
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: 'Error: $e',
      );
    }
  }


}
