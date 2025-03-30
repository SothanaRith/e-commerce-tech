import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import '../../utils/tap_routes.dart';
import '../../widgets/custom_button_widget.dart';
import '../profile_setting_page/profile_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: GestureDetector(), title: "Password Manager" , haveArrowBack: true, context: context),
      body:

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppText.title1("Current Password"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomTextField(label: "Current password", rightIcon: Icon(Icons.remove_red_eye_outlined),
                    ),
                    AppText.title2("Forget password?", customStyle: TextStyle(fontSize: 13, color: theme.primaryColor),),
                  ],
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppText.title1("Current Password"),
              ),
              CustomTextField(label: "Current password", rightIcon: Icon(Icons.remove_red_eye_outlined)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: AppText.title1("Current Password"),
                ),
                CustomTextField(label: "Current password", rightIcon: Icon(Icons.remove_red_eye_outlined)),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CustomButtonWidget(title: "Confirm", action: (){
                    goOff(this, ProfileScreen());
                  }, buttonStyle: BtnStyle.action,),
                ),
              ],
            )
          ),
    );
  }
}
