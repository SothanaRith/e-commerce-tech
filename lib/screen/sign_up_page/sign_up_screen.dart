import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/login_page/login_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              AppText.h1("Sign Up"),
                SizedBox(height: 10,),
                AppText.caption("Fill your information below or register \nwith your social account.", textAlign: TextAlign.center,),
                SizedBox(height: 50,),
                CustomTextField(label: "label", title: "Name", controller: nameTextField,),
                SizedBox(height: 12,),
                CustomTextField(label: "label", title: "Email", controller: emailTextField,),
                SizedBox(height: 12,),
                CustomTextField(label: "label", title: "Phone number", controller: phoneNumberTextField,),
                SizedBox(height: 12,),
                CustomTextField(label: "label", title: "Password", controller: passwordTextField,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.check_box, color: theme.primaryColor,),
                    SizedBox(width: 5,),
                    AppText.caption("Agree with ", customStyle: TextStyle(color: theme.highlightColor, fontWeight: FontWeight.w600, fontSize: 12),),
                    AppText.caption("Terms & Condition", customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600, fontSize: 12, decoration: TextDecoration.underline, decorationColor: theme.primaryColor),),
                  ],
                ),
                SizedBox(height: 30,),
                CustomButtonWidget(title: "Sign Up", action: (){
                  authController.signup(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, phone: phoneNumberTextField.text, role: "buyer", context: context).then((value) {
                  },);
                  // goOff(this, LocationScreen());
                }, buttonStyle: BtnStyle.action,),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 0.2,
                      width: 70,
                      color: theme.highlightColor,
                    ),
                    SizedBox(width: 8,),
                    AppText.caption("Or sign in with"),
                    SizedBox(width: 8,),
                    Container(
                      height: 0.2,
                      width: 70,
                      color: theme.highlightColor,
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialBtn(icons: "assets/images/icons/apple.png", action: (){}),
                    SizedBox(width: 10,),
                    socialBtn(icons: "assets/images/icons/google.png", action: (){}),
                    SizedBox(width: 10,),
                    socialBtn(icons: "assets/images/icons/facebook.png", action: (){}),
                  ],
                ),
                SizedBox(height: 35,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.body2("Already have an Account? "),
                    GestureDetector(
                        onTap: (){
                          goOff(this, LoginScreen());
                        },
                        child: AppText.title2("Sign In")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
