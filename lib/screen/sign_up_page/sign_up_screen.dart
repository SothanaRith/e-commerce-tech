import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/forget_password_page/privacy.dart';
import 'package:e_commerce_tech/screen/login_page/login_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/coming_soon_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = Get.put(AuthController());

  TextEditingController nameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController phoneNumberTextField = TextEditingController();
  bool isAgree = false;
  bool isValidPassword(String password) {
    final passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  String emailErrorText = "";
  String nameErrorText = "";
  String phoneErrorText = "";
  String passwordErrorText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showChangeMainPointDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: mainPoint);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change API Endpoint'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new mainPoint URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  mainPoint = controller.text;
                });

                // Save to SharedPreferences (optional)
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('main_point', mainPoint);

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('MainPoint updated to $mainPoint'),
                ));
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (logic) {
        return SafeArea(
          child: Skeletonizer(
            enabled: logic.isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        showChangeMainPointDialog(context);
                      },
                      child: AppText.h1("sign_up".tr),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppText.caption(
                      "fill_your_information_below_or_register_with_your_social_account"
                          .tr,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 50,
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
                    CustomTextField(
                      label: "put_your_email_here".tr,
                      title: "email".tr,
                      subtitle: emailErrorText,
                      controller: emailTextField,
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
                    CustomTextField(
                      label: "put_your_password_here".tr,
                      title: "password".tr,
                      subtitle: passwordErrorText,
                      controller: passwordTextField,
                      isObscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isAgree = !isAgree;
                            });
                          },
                          child: Icon(
                            isAgree ? Icons.check_box : Icons
                                .check_box_outline_blank,
                            color: theme.primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        AppText.caption(
                          "agree_with".tr,
                          customStyle: TextStyle(
                              color: theme.highlightColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            goTo(this, PrivacyScreen());
                          },
                          child: AppText.caption(
                            "terms_&_condition".tr,
                            customStyle: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: theme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomButtonWidget(
                      title: "sign_up".tr,
                      action: () {
                        if (!isAgree) {
                          return;
                        }

                        setState(() {
                          nameErrorText = "";
                          emailErrorText = "";
                          passwordErrorText = "";
                          phoneErrorText = "";
                        });

                        bool hasError = false;

                        if (nameTextField.text.isEmpty) {
                          setState(() {
                            nameErrorText = "name_is_require_!";
                          });
                          hasError = true;
                        }

                        if (emailTextField.text.isEmpty) {
                          setState(() {
                            emailErrorText = "email_is_require_!";
                          });
                          hasError = true;
                        }

                        if (phoneNumberTextField.text.isEmpty) {
                          setState(() {
                            phoneErrorText = "phone_is_require_!";
                          });
                          hasError = true;
                        }

                        if (passwordTextField.text.isEmpty) {
                          setState(() {
                            passwordErrorText = "password_is_require_!";
                          });
                          hasError = true;
                        } else if (!isValidPassword(passwordTextField.text)) {
                          setState(() {
                            passwordErrorText =
                            "Password must be at least 8 characters,\ninclude uppercase, lowercase, number and symbol.";
                          });
                          hasError = true;
                        }

                        if (!hasError) {
                          authController
                              .signup(
                            name: nameTextField.text,
                            email: emailTextField.text,
                            password: passwordTextField.text,
                            phone: phoneNumberTextField.text,
                            role: "buyer",
                            context: context,
                          )
                              .then((value) {});
                        }
                      },
                      buttonStyle: isAgree ? BtnStyle.action : BtnStyle.normal,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 0.2,
                          width: 70,
                          color: theme.highlightColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        AppText.caption("or_sign_in_with".tr),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 0.2,
                          width: 70,
                          color: theme.highlightColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // socialBtn(
                        //     icons: "assets/images/icons/apple.png", action: () {
                        //   goTo(this, ComingSoonScreen());
                        // }),
                        socialBtn(
                            icons: "assets/images/icons/google.png", action: () {
                          // goTo(this, ComingSoonScreen());
                          authController.signInWithGoogle(context: context);
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.body2("already_have_an_account_?".tr),
                        GestureDetector(
                            onTap: () {
                              goOff(this, LoginScreen());
                            },
                            child: AppText.title2("sign_in".tr)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
