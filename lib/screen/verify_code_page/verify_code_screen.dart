import 'dart:async';
import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

enum ScreenVerifyType { signup, signinPhoneNumber, forgetPassword }

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.type});
  final ScreenVerifyType type;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int otpLength = 6;
  final int waitSeconds = 180;

  final TextEditingController _otpController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  late StreamController<int> _streamController;
  Stream<int>? _countdownStream;
  bool isOtpFilled = false;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>();
    _startCountdown();

    _otpController.addListener(() {
      setState(() {
        isOtpFilled = _otpController.text.length == otpLength;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.sendOTP(context: context);
    });
  }

  void _startCountdown() {
    _streamController.close();
    _streamController = StreamController<int>();
    int counter = waitSeconds;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter < 0) {
        timer.cancel();
        _streamController.close();
      } else {
        _streamController.add(counter);
        counter--;
      }
    });

    _countdownStream = _streamController.stream;
  }

  Future<void> _submitOtp(String otp) async {
    authController.verifyOTP(otp: otp, type: widget.type, context: context);
  }

  void _resendOtp() {
    if (!_streamController.isClosed) return;
    authController.sendOTP(context: context);
    _startCountdown();
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _otpController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: cardCustom(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.h2('Enter Verification Code', textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      AppText.title2(
                        'We are automatically detecting the OTP sent to your email',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 32),
                      Pinput(
                        length: otpLength,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      const SizedBox(height: 32),
                      CustomButtonWidget(
                        action: isOtpFilled ? () => _submitOtp(_otpController.text) : null,
                        title: "Verify OTP",
                        buttonStyle: isOtpFilled ? BtnStyle.action : BtnStyle.normal,
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<int>(
                        stream: _countdownStream,
                        builder: (context, snapshot) {
                          final remaining = snapshot.data ?? 0;
                          final canResend = !_streamController.hasListener || remaining <= 0;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.body2("Didn't receive OTP? "),
                              GestureDetector(
                                onTap: canResend ? _resendOtp : null,
                                child: AppText.body2(
                                  canResend
                                      ? "RESEND OTP"
                                      : "RESEND IN ${_formatDuration(remaining)}",
                                  customStyle: TextStyle(
                                    color: canResend ? theme.primaryColor : Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
