import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/screen/forget_password_page/forget_password_screen.dart';
import 'package:e_commerce_tech/screen/forget_password_page/help_center.dart';
import 'package:e_commerce_tech/screen/language_screen.dart';
import 'package:e_commerce_tech/screen/my_order_page/my_order_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/user_profile_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/select_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../forget_password_page/privacy.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'your_profile'.tr,
      iconName: "assets/images/icons/person.svg",
      screen: const UserProfileScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'check_out'.tr,
      iconName: "assets/images/icons/store.svg",
      screen: const CheckOutScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'my_orders'.tr,
      iconName: "assets/images/icons/shopping_bag.svg",
      screen: const MyOrderScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'my_delivery_address'.tr,
      iconName: "assets/images/icons/delivery.svg",
      screen: const ShippingAddressScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'my_language'.tr,
      iconName: "assets/images/icons/language.svg",
      screen: const LanguageScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'password_manager'.tr,
      iconName: 'assets/images/icons/key.svg',
      screen: const ForgetPasswordScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'help_center'.tr,
      iconName: "assets/images/icons/warning.svg",
      screen: const HelpCenter(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'privacy_policy'.tr,
      iconName: "assets/images/icons/lock.svg",
      screen: const PrivacyScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'log_out'.tr,
      iconName: "assets/images/icons/logout.svg",
      hasSpecialAction: true, // Flag for special action (bottom sheet)
    ),
  ];
  final AuthController authController = Get.put(AuthController());

  User? user = UserStorage.currentUser;

  // Method to show logout bottom sheet
  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'log_out'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'are_you_sure_you_want_to_log_out_?'.tr,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        authController.logout(context: context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'log_out'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void showOptionsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          GetBuilder<AuthController>(builder: (logic) {
            return Skeletonizer(
              enabled: logic.isLoading,
              child: CupertinoActionSheet(
                cancelButton: CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                actions: <Widget>[
                  buildActionSheetAction('from_gallery'.tr, Colors.blue, () {
                    cropGallery(context).then((image) {
                      if (image != null) {
                        authController.updateUserProfilePicture(
                            context, XFile(image.path));
                      }
                    });
                  }),
                  buildActionSheetAction('from_camera'.tr, Colors.red, () {
                    cropCamera(context).then((image) {
                      if (image != null) {
                        authController.updateUserProfilePicture(
                            context, XFile(image.path));
                      }
                    });
                  }),
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AuthController>(builder: (logic) {
          return Skeletonizer(
            enabled: logic.isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showOptionsSheet(context);
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                // Placeholder color
                                backgroundImage: NetworkImage(
                                  logic.userProfile != null ? logic.userProfile ?? 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740' :
                                  user?.coverImage != null
                                      ? "${user!.coverImage}"
                                      : 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showOptionsSheet(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                        "assets/images/icons/edit-2.svg")
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Spacing between avatar and text
                        Text(
                          user?.name ?? 'Rose BanSon',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu items list
                  ListView.builder(
                    shrinkWrap: true,
                    // Allows ListView to take only the space it needs
                    physics: const NeverScrollableScrollPhysics(),
                    // Disables ListView's scrolling
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: SvgPicture.asset(
                              menuItems[index].iconName,
                              color: theme.primaryColor,
                            ),
                            title: AppText.title2(
                              menuItems[index].title,
                              customStyle: const TextStyle(fontSize: 16),
                            ),
                            trailing: SvgPicture.asset(
                                "assets/images/icons/arrow-down.svg"
                            ),
                            onTap: () {
                              if (menuItems[index].hasSpecialAction) {
                                // Handle special actions like showing a bottom sheet
                                if (menuItems[index].title == 'log_out'.tr) {
                                  _showLogoutBottomSheet(context);
                                }
                              } else if (menuItems[index].screen != null) {
                                // Navigate to the screen if it exists
                                goTo(this, menuItems[index].screen!);
                              }
                            },
                          ),
                          if (index < menuItems.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.withAlpha(35),
                              indent: 16,
                              // Optional: adds padding on the left
                              endIndent: 16, // Optional: adds padding on the right
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 110,)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String iconName;
  final dynamic screen;
  final bool hasSpecialAction; // Flag for special actions like bottom sheet

  MenuItem({
    required this.title,
    required this.iconName,
    this.screen,
    this.hasSpecialAction = false, // Default to false
  });
}
