import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final AuthController authController = Get.put(AuthController());
  String emailError = "";
  TextEditingController emailTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: GestureDetector(), title: "password_manager".tr , haveArrowBack: true, context: context),
      body:
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppText.title1("your_email".tr),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextField(label: "your_email_here".tr, rightIcon: Icon(Icons.mail), controller: emailTextField,
                          subtitle: emailError,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: CustomButtonWidget(title: "send_otp".tr, action: (){
                        if (emailTextField.text == "") {
                          setState(() {
                            emailError = "email_is_require_!".tr;
                          });
                        } else {
                          authController.checkMail(email: emailTextField.text, context: context);
                        }
                      }, buttonStyle: BtnStyle.action,),
                    ),
                  ],
                )
              ),
            ),
          ),
    );
  }
}
