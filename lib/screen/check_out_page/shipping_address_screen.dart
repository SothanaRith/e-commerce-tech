import 'package:dotted_border/dotted_border.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListViewCustomWidget(items: [
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
                  ],
                ),
              ),
            ]),
            SizedBox(
              height: 24,
            ),
            DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                dashPattern: [6, 4],
                color: Colors.black,
                strokeWidth: 1.5,
                child: InkWell(
                  onTap: () {
                    // Handle button tap
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '+ Add New Shipping Address',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
