import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/check_out_page/select_delivery_option_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12,),
              AppText.title1("Shopping Address"),
              SizedBox(height: 12,),
              GestureDetector(
                onTap: (){
                  goTo(this, ShippingAddressScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),

                          SizedBox(width: 6,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.caption("Workplace", customStyle: TextStyle(color: theme.primaryColor),),
                              Row(
                                children: [
                                  AppText.caption("1901 Cili. Shiloh, Hawaii 81092"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: theme.highlightColor, size: 20,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12,),
              AppText.title1("Delivery Type"),
              SizedBox(height: 12,),
              GestureDetector(
                onTap: (){
                  goTo(this, SelectDeliveryOptionScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.delivery_dining),

                          SizedBox(width: 6,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.caption("Free shipping", customStyle: TextStyle(color: theme.primaryColor),),
                              Row(
                                children: [
                                  AppText.caption("Estimate: "),
                                  AppText.caption("2-30 Days", customStyle: TextStyle(fontWeight: FontWeight.bold,)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: theme.highlightColor, size: 20,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Divider(thickness: 0.2, color: theme.highlightColor,),
              SizedBox(height: 24,),
              AppText.title1("Order List"),
              SizedBox(height: 12,),
              ListViewCustomWidget(items: [
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),
                ItemSelectWidget(
                  imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  title: 'Tech Gadget',
                  prices: '\$199.99',
                  countNumber: 4.toString(), // Passing the callback
                ),

              ])
            ],
          ),
        ),
      ),
    );
  }
}
