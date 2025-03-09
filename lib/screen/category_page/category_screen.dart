import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "jake", context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            ])
          ],
        ),
      ),
    );
  }
}
