import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/category_page/category_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:flutter/material.dart';

class CategoryHomeScreenWidget extends StatelessWidget {
  const CategoryHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.title2("Category", customStyle: TextStyle(fontWeight: FontWeight.bold),),
              AppText.caption("See All", customStyle: TextStyle(fontWeight: FontWeight.w600, color: theme.primaryColor)),
            ],
          ),
        ),
        SizedBox(height: 4,),
        ListViewHorizontalWidget(items: [
          GestureDetector(
            onTap: (){
              goTo(this, CategoryScreen());
            },
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: theme.primaryColor.withAlpha(20)
                  ),
                  child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor,),
                ),
                SizedBox(height: 5,),
                AppText.body2("category")
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.primaryColor.withAlpha(20)
                ),
                child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor,),
              ),
              SizedBox(height: 5,),
              AppText.body2("category name")
            ],
          ),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.primaryColor.withAlpha(20)
                ),
                child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor,),
              ),
              SizedBox(height: 5,),
              AppText.body2("category name")
            ],
          ),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.primaryColor.withAlpha(20)
                ),
                child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor,),
              ),
              SizedBox(height: 5,),
              AppText.body2("category name")
            ],
          ),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.primaryColor.withAlpha(20)
                ),
                child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor,),
              ),
              SizedBox(height: 5,),
              AppText.body2("category name")
            ],
          ),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: theme.primaryColor.withAlpha(20)
                ),
                child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor,),
              ),
              SizedBox(height: 5,),
              AppText.body2("category name")
            ],
          ),
        ], height: 130),
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
        ], height: 32)
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
