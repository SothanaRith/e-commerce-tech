import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_commerce_tech/controllers/lacation_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/location_page/location_select_screen.dart';
import 'package:e_commerce_tech/screen/nav_bar_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingAddressScreen extends StatefulWidget {
  final bool backHome;

  const ShippingAddressScreen({super.key, this.backHome = true});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      locationController.getUserAddresses(context: context);
    });
  }

  void _showAddressDialog(
      String id, String fullName, String street, bool isDefault) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GetBuilder<LocationController>(builder: (logic) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  radius: 28,
                  child: Icon(Icons.location_on, color: theme.primaryColor, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'manage_address'.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                AppText.body(
                  "${"address_:".tr} $street",
                  customStyle: const TextStyle(color: Colors.black54), textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (!isDefault) ...[
                  logic.isLoading
                      ? CircularProgressIndicator(color: theme.primaryColor)
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.star_rounded, color: Colors.amber,),
                      label: AppText.body1(
                        "set_as_default".tr,
                        customStyle: TextStyle(color: theme.secondaryHeaderColor),
                      ),
                      onPressed: () {
                        locationController.updateAddress(
                          id: id,
                          fullName: fullName,
                          phoneNumber: UserStorage.currentUser?.phone ?? '',
                          street: street,
                          isDefault: true,
                          context: context,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  logic.isLoading
                      ? CircularProgressIndicator(color: theme.primaryColor)
                      : SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: AppText.body2(
                        "delete".tr,
                        customStyle: const TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        locationController.deleteAddress(id: id, context: context);
                      },
                    ),
                  ),
                ],
                if (isDefault)
                  AppText.caption(
                    "This address is already set as default.".tr,
                    customStyle: TextStyle(color: Colors.grey.shade600),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        type: this,
        title: "select_delivery".tr,
        context: context,
        onBackAction: widget.backHome
            ? () => goOff(this, MainScreen(currentPageIndex: 3))
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() =>
                ListViewCustomWidget(
                  items: locationController.addresses.map((item) {
                    final isDefault = item.isDefault == 'true';
                    return InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          _showAddressDialog(
                            item.id ?? '',
                            item.fullName ?? '---',
                            item.street ?? '',
                            isDefault,
                          ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDefault ? theme.primaryColor.withOpacity(
                                0.05) : Colors.transparent,
                            border: Border.all(
                              color: isDefault ? theme.primaryColor : Colors
                                  .grey.shade300,
                              width: isDefault ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: isDefault
                                            ? theme.primaryColor
                                            : null),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          AppText.caption(
                                            item.fullName ?? '---',
                                            customStyle: TextStyle(
                                              color: theme.primaryColor,
                                              fontWeight: isDefault ? FontWeight
                                                  .bold : null,
                                            ),
                                          ),
                                          AppText.body2(
                                            item.street ?? 'N/A',
                                            maxLines: 2,
                                          ),
                                          if (isDefault)
                                            AppText.caption(
                                              "(_default_address_)".tr,
                                              customStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: theme.highlightColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationSelectScreen()),
                  ),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: [6, 4],
                color: Colors.black,
                strokeWidth: 1.5,
                child: Container(
                  width: MediaQuery
                      .sizeOf(context)
                      .width * 0.8,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      '+_add_new_shipping_address'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
