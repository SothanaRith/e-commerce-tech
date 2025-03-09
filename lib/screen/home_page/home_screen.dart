import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/screen/filter_page/filter_screen.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/screen/my_order_page/my_order_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: HomeTopBarScreenWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width - 80,
                      child: CustomTextField(
                        label: "Search something...",
                        leftIcon: Icon(Icons.search),
                      )),
                  InkWell(
                    onTap: (){
                      goTo(this, FilterScreen());
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: theme.primaryColor),
                        child: Icon(
                          Icons.menu_outlined,
                          color: theme.secondaryHeaderColor,
                        )),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12,),
            // slide
            ImageSlider(
              imageUrls: [
                'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
              ],
              height: 200,
            ),
            SizedBox(height: 12,),
            CategoryHomeScreenWidget(),
            SizedBox(
              height: 12,
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
            ])
          ],
        ),
      ),
    );
  }
}
