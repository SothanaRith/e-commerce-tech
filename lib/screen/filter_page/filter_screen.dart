import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:e_commerce_tech/widgets/range_slider_widget.dart';
import 'package:e_commerce_tech/widgets/text_btn_widget.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "filter", context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppText.title1("Brands"),
            ),
            ListViewHorizontalWidget(items: [
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
            ], height: 40),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppText.title1("Gender"),
            ),
            ListViewHorizontalWidget(items: [
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
            ], height: 40),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppText.title1("Sort by"),
            ),
            ListViewHorizontalWidget(items: [
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
              TextBtnWidget(title: "title"),
            ], height: 40),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppText.title1("Pricing Range"),
            ),
            RangeSliderWidget(
              min: 0,
              max: 3000,
              start: 10,
              end: 2100,
              onChanged: (values) {
                print("Start: ${values.start}, End: ${values.end}");
              },
            ),
            SizedBox(height: 12,),
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
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
