import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/delivery_address_model.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  late final ApiRepository apiRepository;

  bool isLoading = false;
  RxList<DeliveryAddress> addresses = <DeliveryAddress>[].obs;
  DeliveryAddress? addressesDefault;

  LocationController() {
    apiRepository = ApiRepository();
  }

  Future<void> createAddress({
    required String street,
    bool isDefault = false,
    required BuildContext context,
  }) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/delivery-addresses',
      headers: {
        'Authorization': TokenStorage.token ?? '',
        'Content-Type': 'application/json'
      },
      body: {
        'userId': UserStorage.currentUser?.id,
        'fullName': UserStorage.currentUser?.name,
        'phoneNumber': UserStorage.currentUser?.phone,
        'street': street,
        'isDefault': isDefault
      },
      context: context,
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      if (jsonData['address'] != null) {
        addresses.add(DeliveryAddress.fromJson(jsonData['address']));
      }
      showCustomDialog(
        context: context,
        type: DialogType.success,
        title: "${jsonData["message"]}",
        desc: "${jsonData["address"]['street']}",
        okOnPress: () => goTo(context, ShippingAddressScreen()),
      );
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  Future<void> getUserAddresses({
    required BuildContext context,
  }) async {
    isLoading = true;
    update();
    final response = await apiRepository.fetchData(
      '$mainPoint/api/delivery-addresses/user/${UserStorage.currentUser?.id}',
      headers: {
        'Authorization': TokenStorage.token ?? '',
        'Content-Type': 'application/json'
      },
      context: context,
    );
    isLoading = false;
    update();
    if (response.data != null) {
      try {
        final List<dynamic> data = jsonDecode(response.data!);
        addresses.value =
            data.map((e) => DeliveryAddress.fromJson(e)).toList();
      } catch (e) {
        showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Invalid response: ${e.toString()}",
        );
      }
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  Future<void> getDefaultAddresses({
    required BuildContext context,
  }) async {
    isLoading = true;
    update();
    final response = await apiRepository.fetchData(
      '$mainPoint/api/delivery-addresses/default/${UserStorage.currentUser?.id}',
      headers: {
        'Authorization': TokenStorage.token ?? '',
        'Content-Type': 'application/json'
      },
      context: context,
    );
    isLoading = false;
    update();
    if (response.data != null) {
      try {
        final data = jsonDecode(response.data!);
        addressesDefault = DeliveryAddress.fromJson(data);
        update();
      } catch (e) {
        showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Invalid response: ${e.toString()}",
        );
      }
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  Future<void> updateAddress({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String street,
    bool isDefault = false,
    required BuildContext context,
  }) async {
    isLoading = true;
    update();
    final response = await apiRepository.putData(
      '$mainPoint/api/delivery-addresses/$id',
      headers: {
        'Authorization': TokenStorage.token ?? '',
        'Content-Type': 'application/json'
      },
      body: {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'street': street,
        'isDefault': isDefault
      },
      context: context,
    );
    isLoading = false;
    update();
    if (response.data != null) {
      final jsonData = jsonDecode(response.data!);
      final index = addresses.indexWhere((e) => e.id == id);
      if (index != -1 && jsonData['address'] != null) {
        addresses[index] = DeliveryAddress.fromJson(jsonData['address']);
      }
      showCustomDialog(
        context: context,
        type: DialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () async => await getDefaultAddresses(context: context).then((_) async {
          await getUserAddresses(context: context);
          Get.back();
        },),
      );
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  Future<void> deleteAddress({
    required String id,
    required BuildContext context,
  }) async {
    isLoading = true;
    update();
    final response = await apiRepository.deleteData(
      '$mainPoint/api/delivery-addresses/$id',
      headers: {
        'Authorization': TokenStorage.token ?? '',
        'Content-Type': 'application/json'
      },
      context: context,
    );
    isLoading = false;
    update();
    if (response.data != null) {
      addresses.removeWhere((element) => element.id == id);
      final jsonData = jsonDecode(response.data!);
      showCustomDialog(
        context: context,
        type: DialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () => Get.back(),
      );
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }
}
