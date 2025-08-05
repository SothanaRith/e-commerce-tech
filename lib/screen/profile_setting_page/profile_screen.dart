import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:e_commerce_tech/screen/chat_bot_page/chat_bot_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/screen/forget_password_page/forget_password_screen.dart';
import 'package:e_commerce_tech/screen/forget_password_page/help_center.dart';
import 'package:e_commerce_tech/screen/language_screen.dart';
import 'package:e_commerce_tech/screen/my_order_page/my_order_screen.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/last_order_widget.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/user_profile_screen.dart';
import 'package:e_commerce_tech/screen/track_order_page/order_transaction_detail_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
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
  final List<MenuItem> menuItemsTop = [
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
      title: 'chat_bot'.tr,
      iconName: "assets/images/icons/chat_bot.svg",
      screen: ChatScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'my_orders'.tr,
      iconName: "assets/images/icons/shopping_bag.svg",
      screen: const MyOrderScreen(),
      hasSpecialAction: false,
    ),
  ];
  final AuthController authController = Get.put(AuthController());
  final OrderController orderController = Get.put(OrderController());
  CartController cartController = Get.put(CartController());

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
  void initState() {
    // TODO: implement initState
    super.initState();
    cartController.fetchTotalItemsInCart(context: context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16, bottom: 16),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 60,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: theme.primaryColor.withAlpha(30),
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery
                                        .sizeOf(context)
                                        .width,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 22),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            AppText.title1(user?.name ?? 'N/A'),
                                            AppText.caption(
                                                user?.phone ?? 'N/A'),
                                          ],
                                        ),
                                        SizedBox(width: 16),
                                      ],
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 12,),
                                // Stack(
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         goTo(this, ChatScreen());
                                //       },
                                //       child: Padding(
                                //         padding: const EdgeInsets.only(right: 120.0),
                                //         child: Column(
                                //           mainAxisAlignment: MainAxisAlignment.center,
                                //           crossAxisAlignment: CrossAxisAlignment.center,
                                //           children: [
                                //             Stack(
                                //               alignment: Alignment.center,
                                //               children: [
                                //                 Container(
                                //                   width: 60,
                                //                   height: 60,
                                //                   padding: EdgeInsets.all(8),
                                //                   decoration: BoxDecoration(
                                //                     borderRadius: BorderRadiusGeometry.circular(40),
                                //                     gradient: LinearGradient(
                                //                       colors: [
                                //                         theme.primaryColor.withAlpha(200),
                                //                         theme.primaryColor.withAlpha(50)
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   child: Image.asset(
                                //                     "assets/icon/robot.png",
                                //                     fit: BoxFit.cover,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //     Positioned(
                                //       top: 0,
                                //       right: 5,
                                //       child: Padding(
                                //         padding: const EdgeInsets.only(left: 10.0),
                                //         child: Container(
                                //           padding:
                                //           EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                //           decoration: BoxDecoration(
                                //               color: theme.primaryColor.withAlpha(90),
                                //               borderRadius: BorderRadiusGeometry.circular(12)),
                                //           child: Align(
                                //             alignment: Alignment.centerLeft,
                                //             child: SizedBox(
                                //               width: 100,
                                //               child: DefaultTextStyle(
                                //                 style: const TextStyle(
                                //                   fontSize: 10,
                                //                   fontWeight: FontWeight.bold,
                                //                   color: Colors.white,
                                //                 ),
                                //                 child: AnimatedTextKit(
                                //                   repeatForever: true,
                                //                   isRepeatingAnimation: true,
                                //                   animatedTexts: [
                                //                     TyperAnimatedText('Hello, Ask me now !',
                                //                         speed: Duration(milliseconds: 80)),
                                //                     TyperAnimatedText('Do u need my help?',
                                //                         speed: Duration(milliseconds: 80)),
                                //                     TyperAnimatedText('how was your day ?',
                                //                         speed: Duration(milliseconds: 80)),
                                //                     TyperAnimatedText('Hi, Can I help u ?',
                                //                         speed: Duration(milliseconds: 80)),
                                //                   ],
                                //                   onTap: () {},
                                //                   displayFullTextOnTap: true,
                                //                   pause: Duration(milliseconds: 1500),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showOptionsSheet(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: theme.primaryColor, width: 3),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    safeImageUrl(
                                      logic.userProfile != null
                                          ? logic.userProfile ??
                                          'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740'
                                          : user?.coverImage != null
                                          ? "${user!.coverImage}"
                                          : 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: menuItemsTop.map((item) {
                          return GestureDetector(
                            onTap: () {
                              if (item.hasSpecialAction) {
                                // Handle special actions like showing a bottom sheet
                                if (item.title == 'log_out'.tr) {
                                  _showLogoutBottomSheet(context);
                                }
                              } else if (item.screen != null) {
                                // Navigate to the screen if it exists
                                goTo(this, item.screen!);
                              }
                            },
                            child: Container(
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width / 4.8,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusGeometry.circular(
                                      12),
                                  color: theme.primaryColor.withAlpha(60)
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 5, right: 5, left: 5),
                                        child: SvgPicture.asset(
                                          item.iconName,
                                          color: theme.primaryColor,
                                          height: 28,
                                        ),
                                      ),
                                        GetBuilder<CartController>(
                                            builder: (logic) {
                                              return  cartController.totalItemsInCart != 0 &&
                                                  item.title == "Check out" ? Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      7),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                  ),
                                                  child: AppText.caption(
                                                    logic
                                                        .totalItemsInCart
                                                        .toString(),
                                                    customStyle: TextStyle(
                                                        color: Colors.white),),
                                                ),
                                              ) : SizedBox();
                                            }),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  AppText.caption(
                                    item.title,
                                    customStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          );
                        },).toList()
                    ),
                  ),
                  SizedBox(height: 18,),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: LastOrderWidget(),
                  ),
                  SizedBox(height: 18,),
                  // Menu items list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ListView.builder(
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
                  ),
                  const SizedBox(height: 10,),
                  Center(
                    child: AppText.body2(
                      'version 1.0.01',
                      customStyle: TextStyle(color: theme.highlightColor),
                    ),
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
