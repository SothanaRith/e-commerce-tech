import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Payment method", context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              paymentCard(imageUrl: "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg", bankName: "ABA", subtitle: "23776 ** 1324"),
              paymentCard(imageUrl: "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg", bankName: "ABA"),
              paymentCard(imageUrl: "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg", bankName: "ABA"),
              SizedBox(height: 24,),
              fieldDisplay(title: "title", value: "value"),
              SizedBox(height: 6,),
              fieldDisplay(title: "title", value: "value"),
              SizedBox(height: 6,),
              fieldDisplay(title: "title", value: "value"),
              SizedBox(height: 6,),
              Divider(thickness: 0.3, color: theme.highlightColor,),
              SizedBox(height: 6,),
              fieldDisplay(title: "title", value: "value"),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentCard({required String imageUrl,required String bankName, String subtitle = ""}){
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: theme.highlightColor.withAlpha(30), blurRadius: 10, spreadRadius: 10)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(imageUrl, width: 50.w, fit: BoxFit.cover,)),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.title1(bankName),
                  SizedBox(height: 6,),
                  AppText.title2(subtitle, customStyle: TextStyle(color: theme.highlightColor),),
                ],
              ),
            ],
          ),
          Icon(Icons.radio_button_off)
        ],
      ),
    );
  }

  Widget fieldDisplay({required String title,required String value}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.body2(title, customStyle: TextStyle(color: theme.highlightColor)),
        AppText.body2(value, customStyle: TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
  }
}
