import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemSelectWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String prices;
  final String countNumber;
  final Function(bool isIncrement)? count;

  const ItemSelectWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.prices,
    this.count,
    required this.countNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 90.w,
                fit: BoxFit.cover,
              )),
          SizedBox(
            width: 12,
          ),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.title1(title),
                          AppText.title1(
                            prices,
                            customStyle: TextStyle(color: theme.primaryColor),
                          ),
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: theme.primaryColor.withAlpha(60),
                            ),
                            child: AppText.caption(
                              "Free Delivery",
                              customStyle: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (count != null) ...[
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => count!(false), // Decrement
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  shape: BoxShape.rectangle,
                                  color: theme.highlightColor,
                                ),
                                child: AppText.title("-"),
                              ),
                            ),
                            SizedBox(width: 12),
                            AppText.title(countNumber.toString()),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => count!(true), // Increment
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  shape: BoxShape.rectangle,
                                  color: theme.primaryColor,
                                ),
                                child: AppText.title(
                                  "+",
                                  customStyle: TextStyle(
                                      color: theme.secondaryHeaderColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                          shape: BoxShape.circle
                        ),
                        child: AppText.body1(
                          countNumber.toString(),
                          customStyle:
                              TextStyle(color: theme.secondaryHeaderColor),
                        ),
                      )
                    ]
                  ],
                ),
                SizedBox(height: 12),
                Divider(thickness: 0.2, color: theme.highlightColor),
              ],
            ),
          )
        ],
      ),
    );
  }
}
