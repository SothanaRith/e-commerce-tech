import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:flutter/material.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ItemSelectWidget(
                imageUrl: [],
                title: 'Tech Gadget',
                prices: '\$199.99',
                countNumber: 4.toString(), // Passing the callback
              ),
              SizedBox(height: 12,),
              AppText.title1("Order Details"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.caption("Expected Delivery Date"),
                  AppText.title2("03. 07. 2025"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.caption("Tracking ID"),
                  AppText.title2("RGJ289KH12"),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
