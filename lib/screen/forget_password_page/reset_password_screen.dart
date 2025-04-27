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
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController authController = Get.put(AuthController());
  String passwordError = "";
  String confirmPasswordError = "";
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController confirmPasswordTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          type: GestureDetector(),
          title: "Password Manager",
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
                    child: AppText.title1("Your password"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomTextField(
                        label: "Your password here",
                        rightIcon: Icon(Icons.key),
                        controller: passwordTextField,
                        isObscureText: true,
                        subtitle: passwordError,
                      ),
                      SizedBox(height: 16,),
                      CustomTextField(
                        label: "Confirm password here",
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
                      title: "Save",
                      action: () {
                        passwordError = "";
                        confirmPasswordError = "";
                        if (passwordTextField.text == "") {
                          setState(() {
                            passwordError = "password is require";
                          });
                        } else if (confirmPasswordTextField.text == "") {
                          setState(() {
                            confirmPasswordError =
                                "confirm password is require";
                          });
                        } else if (passwordTextField.text !=
                            confirmPasswordTextField.text) {
                          showCustomDialog(
                              context: context,
                              type: DialogType.error,
                              title: "Error: Confirm password is wrong!");
                        } else {
                          authController.resetPassword(newPassword: passwordTextField.text, context: context);
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
