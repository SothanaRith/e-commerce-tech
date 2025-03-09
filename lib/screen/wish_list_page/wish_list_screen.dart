import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:flutter/material.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Wish list", context: context, haveArrowBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 6,),
            ListViewHorizontalWidget(items: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("All")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("Newest")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("Popular")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("Man")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("WomanS")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("All")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("All")),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: theme.primaryColor),
                ),
                child: Center(child: AppText.caption("All")),
              ),
            ], height: 32),

            SizedBox(height: 12,),
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
            SizedBox(height: 130,)
          ],
        ),
      ),
    );
  }
}
