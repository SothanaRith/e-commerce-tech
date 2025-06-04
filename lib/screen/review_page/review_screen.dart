import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ItemSelectWidget(
                imageUrl: [],
                title: 'Tech Gadget',
                prices: '\$199.99',
                countNumber: 4.toString(), // Passing the callback
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: AppText.title1("Reviews"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 6,),
                  Icon(Icons.star),
                  SizedBox(width: 6,),
                  Icon(Icons.star),
                  SizedBox(width: 6,),
                  Icon(Icons.star),
                  SizedBox(width: 6,),
                  Icon(Icons.star),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomTextField(label: "text some", title: "Add detailed review",),
            ),
            Row(
              children: [
                Icon(Icons.image, color: theme.primaryColor,),
                AppText.caption("Add photos", customStyle: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),),
              ],
            ),
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
    );
  }
}
