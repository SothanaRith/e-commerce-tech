import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

class CategoryHomeScreenWidget extends StatelessWidget {
  const CategoryHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.title2("Category"),
            AppText.title2("See All")
          ],
        )
      ],
    );
  }

  Widget categoryItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: theme.highlightColor
            ),
            child: Icon(Icons.pause_circle)),
        AppText.title2("Category")
      ],
    );
  }
}
