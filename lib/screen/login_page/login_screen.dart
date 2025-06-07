import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/screen/forget_password_page/forget_password_screen.dart';
import 'package:e_commerce_tech/screen/location_page/location_select_screen.dart';
import 'package:e_commerce_tech/screen/sign_up_page/sign_up_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/coming_soon_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  String emailError = "";
  String passwordError = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              AppText.h1("Sign In"),
              SizedBox(height: 10),
              AppText.caption("Hi welcome back, you’ve been Missed"),
              SizedBox(height: 50),
              CustomTextField(
                label: "Email",
                title: "Email",
                subtitle: emailError,
                controller: emailTextField,
              ),
              SizedBox(height: 12),
              CustomTextField(
                label: "Password",
                title: "Password",
                subtitle: passwordError,
                controller: passwordTextField,
                isObscureText: true,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      goTo(this, ForgetPasswordScreen());
                    },
                    child: AppText.caption(
                      "Forget password?",
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
              SizedBox(height: 30),
              CustomButtonWidget(
                title: "Login",
                action: () {
                  emailError = "";
                  passwordError = "";
                  if (emailTextField.text == "") {
                    setState(() {
                      emailError = "email is require!";
                    });
                  } else if (passwordTextField.text == "") {
                    setState(() {
                      passwordError = "password is require!";
                    });
                  } else {
                    authController.signIn(
                      email: emailTextField.text,
                      password: passwordTextField.text,
                      context: context,
                    );
                  }
                },
                buttonStyle: BtnStyle.action,
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 0.2,
                    width: 70,
                    color: theme.highlightColor,
                  ),
                  SizedBox(width: 8),
                  AppText.caption("Or sign in with"),
                  SizedBox(width: 8),
                  Container(
                    height: 0.2,
                    width: 70,
                    color: theme.highlightColor,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialBtn(
                      icons: "assets/images/icons/apple.png", action: () {
                    goOff(this, ComingSoonScreen());
                  }),
                  SizedBox(width: 10),
                  socialBtn(
                      icons: "assets/images/icons/google.png", action: () {
                    goOff(this, ComingSoonScreen());
                  }),
                  SizedBox(width: 10),
                  socialBtn(
                      icons: "assets/images/icons/facebook.png", action: () {
                    goOff(this, ComingSoonScreen());
                  }),
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.body2("Don’t have an Account? "),
                  GestureDetector(
                    onTap: () {
                      goOff(this, SignUpScreen());
                    },
                    child: AppText.title2("Sign Up"),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget socialBtn(
    {required String icons, required Function() action, double size = 35}) {
  return GestureDetector(
    onTap: action,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 0.5, color: theme.highlightColor)),
      child: Image.asset(
        icons,
        width: size,
        height: size,
      ),
    ),
  );
}
