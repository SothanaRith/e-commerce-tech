import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 1.5,
                  width: MediaQuery.sizeOf(context).width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          top: 0,
                          child: Image.network("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg", height: MediaQuery.sizeOf(context).height / 1.5 - 35, width: MediaQuery.sizeOf(context).width, fit: BoxFit.cover,)),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.secondaryHeaderColor
                          ),
                          child: ListViewHorizontalWidget(horizontalPadding: 4,items: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                              ),
                            ),
                          ], height: 60),
                        ),
                      ),
                      Positioned(
                          top: 50,
                          left: 25,
                          child: InkWell(
                            onTap: (){
                              popBack(this);
                            },
                            child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.secondaryHeaderColor.withAlpha(90)
                                ),
                                child: Icon(Icons.arrow_back)),
                          )),
                      Positioned(
                          top: 50,
                          right: 25,
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.secondaryHeaderColor.withAlpha(90)
                                  ),
                                  child: Icon(Icons.heart_broken, color: theme.primaryColor,)),
                              SizedBox(width: 6,),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.h2("text"),

                          Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: theme.primaryColor.withAlpha(30)),
                              child: Icon(
                                Icons.store,
                                color: theme.primaryColor,
                                size: 18,
                              )),
                        ],
                      ),
                      AppText.caption("text hello text do you "),
                      SizedBox(height: 12,),
                      Divider(thickness: 0.1, color: theme.highlightColor,),
                    ],
                  ),
                ),
                Padding(
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
                                  AppText.caption("2-30 Days"),
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
                SizedBox(height: 32,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: AppText.title("Reviews"),
                ),
                SizedBox(height: 12,),
                ListViewHorizontalWidget(items: [
                  Container(
                    padding: EdgeInsets.all(12),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: theme.secondaryHeaderColor
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.title1("text"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppText.caption("Mar 30 2024"),
                                Row(
                                  children: [
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        AppText.caption("very good drink I never seen before"),
                        SizedBox(height: 6,),
                        ListViewHorizontalWidget(horizontalPadding: 4,items: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                        ], height: 60)

                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: theme.secondaryHeaderColor
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.title1("text"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppText.caption("Mar 30 2024"),
                                Row(
                                  children: [
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                    Icon(Icons.star),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        AppText.caption("very good drink I never seen before"),
                        SizedBox(height: 6,),
                        ListViewHorizontalWidget(horizontalPadding: 4,items: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg"))
                            ),
                          ),
                        ], height: 60)
                      ],
                    ),
                  ),
                ], height: 160),

                SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AppText.title1("Store Contacts"),
                ),

                // map here
                SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: AppText.title1("Related product"),
                ),
                GridCustomWidget(items: [
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                  ItemCardWidget(
                    imageUrl:
                    "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                    title: "Item",
                    price: "10\$",
                  ),
                ]),
                SizedBox(height: 24,),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
