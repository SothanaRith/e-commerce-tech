import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

enum ScreenType { signup, signinPhoneNumber }

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // final ScreenType fromClass;
  final int otpLength = 6;

  final TextEditingController _otpController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  Future<void> submitOtp({required String otp}) async {
    authController.verifyOTP(otp: otp);
  }

  Future<void> resendOtp() async {
    authController.sendOTP();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: cardCustom(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.h2('Enter Verification Code', textAlign: TextAlign.center),
                    SizedBox(height: 8),
                    AppText.title2('We Are Automatically detecting a SMS Sent to your Number', textAlign: TextAlign.center, maxLines: 2),
                    SizedBox(height: 40),
                    Pinput(
                      length: otpLength,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(height: 40),
                    CustomButtonWidget(
                      action: (){
                        submitOtp(otp: _otpController.text);
                      },
                      title: "Verify OTP",
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.body2("Don't receive the OTP? "),
                        GestureDetector(
                          onTap: () => resendOtp(),
                          child: AppText.body2( "RESEND OTP", customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
