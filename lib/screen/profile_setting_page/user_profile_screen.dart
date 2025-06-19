import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/select_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthController authController = Get.put(AuthController());

  TextEditingController nameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController phoneNumberTextField = TextEditingController();

  String emailErrorText = "";
  String nameErrorText = "";
  String phoneErrorText = "";
  String passwordErrorText = "";
  User? user = UserStorage.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    nameTextField.text = user?.name ?? '';
    phoneNumberTextField.text = user?.phone ?? '';
    super.initState();
  }

  void showOptionsSheet(
      BuildContext context
      ) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
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
                authController.updateUserProfilePicture(context, XFile(image.path));
              }
            });
          }),
          buildActionSheetAction('from_camera'.tr, Colors.red, () {
            cropCamera(context).then((image) {
              if (image != null) {
                authController.updateUserProfilePicture(context, XFile(image.path));
              }
            });
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "user_profile".tr, context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              radius: 70,
                              backgroundColor: Colors.grey[300], // Placeholder color
                              backgroundImage: NetworkImage(
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
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset("assets/images/icons/edit-2.svg")
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "put_your_name_here".tr,
                  title: "name".tr,
                  subtitle: nameErrorText,
                  controller: nameTextField,
                ),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  label: "put_your_phone_number_here".tr,
                  title: "phone_number".tr,
                  subtitle: phoneErrorText,
                  controller: phoneNumberTextField,
                ),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomButtonWidget(
                  title: "update_user".tr,
                  action: () {
                    authController
                        .updateUser(
                        name: nameTextField.text,
                        phone: phoneNumberTextField.text,
                        context: context);
                  },
                  buttonStyle: BtnStyle.action,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
