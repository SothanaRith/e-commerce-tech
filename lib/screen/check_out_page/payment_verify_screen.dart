import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/nav_bar_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class PaymentVerifyScreen extends StatefulWidget {
  final List<CartModel> cart;
  final Map<String, String> paymentMethod;
  const PaymentVerifyScreen({super.key, required this.cart, required this.paymentMethod});

  @override
  State<PaymentVerifyScreen> createState() => _PaymentVerifyScreenState();
}

class _PaymentVerifyScreenState extends State<PaymentVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width / 2,
              height: MediaQuery.sizeOf(context).width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width / 2),
                  color: theme.secondaryHeaderColor
              ),
              child: Icon(Icons.verified, color: theme.primaryColor, size: 120,),
            ),
            SizedBox(height: 30,),
            AppText.h3("Payment Successful!"),
            SizedBox(height: 20,),
            AppText.body2("Thank you for your purchase. \nHave a good day", textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            CustomButtonWidget(title: "Let's get started!", action: (){
              goOff(this, MainScreen());
            }, buttonStyle: BtnStyle.normal,)
          ],
        ),
      ),
    );
  }
}
