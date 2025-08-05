import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final bool isFromRegister;
  const ResetPasswordScreen({super.key, this.isFromRegister = false});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController authController = Get.put(AuthController());
  String passwordError = "";
  String confirmPasswordError = "";
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController confirmPasswordTextField = TextEditingController();

  bool isValidPassword(String password) {
    final passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          type: GestureDetector(),
          title: "password_manager".tr,
          haveArrowBack: false,
          context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppText.title1("your_password".tr),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomTextField(
                        label: "your_password_here".tr,
                        rightIcon: Icon(Icons.key),
                        controller: passwordTextField,
                        isObscureText: true,
                        subtitle: passwordError,
                      ),
                      SizedBox(height: 16,),
                      CustomTextField(
                        label: "confirm_password_here".tr,
                        rightIcon: Icon(Icons.key),
                        controller: confirmPasswordTextField,
                        isObscureText: true,
                        subtitle: confirmPasswordError,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: CustomButtonWidget(
                      title: "save".tr,
                      action: () {
                        passwordError = "";
                        confirmPasswordError = "";
                        if (passwordTextField.text == "") {
                          setState(() {
                            passwordError = "password_is_require_!";
                          });
                        } else if (!isValidPassword(passwordTextField.text)) {
                          showCustomDialog(
                              context: context,
                              type: CustomDialogType.error,
                              title: "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.".tr);
                        } else if (confirmPasswordTextField.text == "") {
                          setState(() {
                            confirmPasswordError =
                                "confirm_password_is_require";
                          });
                        } else if (passwordTextField.text !=
                            confirmPasswordTextField.text) {
                          showCustomDialog(
                              context: context,
                              type: CustomDialogType.error,
                              title: "error_confirm_password_is_wrong_!".tr);
                        } else {
                          authController.resetPassword(newPassword: passwordTextField.text, context: context, isFromRegister: widget.isFromRegister);
                        }
                      },
                      buttonStyle: BtnStyle.action,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
