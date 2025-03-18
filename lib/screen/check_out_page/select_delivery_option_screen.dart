import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

class SelectDeliveryOptionScreen extends StatefulWidget {
  const SelectDeliveryOptionScreen({super.key});

  @override
  State<SelectDeliveryOptionScreen> createState() => _SelectDeliveryOptionScreenState();
}

class _SelectDeliveryOptionScreenState extends State<SelectDeliveryOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.caption(
                                "Workplace",
                                customStyle:
                                TextStyle(color: theme.primaryColor),
                              ),
                              Row(
                                children: [
                                  AppText.caption(
                                      "1901 Cili. Shiloh, Hawaii 81092"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: theme.highlightColor,
                        size: 20,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    thickness: 0.2,
                    color: theme.highlightColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.caption(
                                "Workplace",
                                customStyle:
                                TextStyle(color: theme.primaryColor),
                              ),
                              Row(
                                children: [
                                  AppText.caption(
                                      "1901 Cili. Shiloh, Hawaii 81092"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: theme.highlightColor,
                        size: 20,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    thickness: 0.2,
                    color: theme.highlightColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.caption(
                                "Workplace",
                                customStyle:
                                TextStyle(color: theme.primaryColor),
                              ),
                              Row(
                                children: [
                                  AppText.caption(
                                      "1901 Cili. Shiloh, Hawaii 81092"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: theme.highlightColor,
                        size: 20,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    thickness: 0.2,
                    color: theme.highlightColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
