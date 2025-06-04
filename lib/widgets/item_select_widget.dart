import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemSelectWidget extends StatelessWidget {
  final List<String> imageUrl;
  final String title;
  final String prices;
  final String countNumber;
  final Function(bool isIncrement)? count;

  const ItemSelectWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.prices,
    required this.countNumber,
    this.count,
  });

  Widget _buildStackedImages() {
    List<Widget> imageStack = [];

    for (int i = 0; i < imageUrl.length && i < 3; i++) {
      imageStack.add(
        Positioned(
          left: i * 12.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              imageUrl[i],
              width: 50.w,
              height: 50.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    final extraCount = imageUrl.length - 3;
    if (extraCount > 0) {
      imageStack.add(
        Positioned(
          left: 28.0,
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(child: AppText.title("+$extraCount")),
          ),
        ),
      );
    }

    return SizedBox(
      width: 80.w,
      height: 60.w,
      child: Stack(children: imageStack),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title1(title),
        AppText.title1(prices, customStyle: TextStyle(color: theme.primaryColor)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: theme.primaryColor.withAlpha(60),
          ),
          child: AppText.caption(
            "Free Delivery",
            customStyle: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounter() {
    return Row(
      children: [
        _countButton("-", false, theme.highlightColor),
        SizedBox(width: 12),
        AppText.title(countNumber),
        SizedBox(width: 12),
        _countButton("+", true, theme.primaryColor,
            textColor: theme.secondaryHeaderColor),
      ],
    );
  }

  Widget _countButton(String text, bool isIncrement, Color bgColor,
      {Color? textColor}) {
    return GestureDetector(
      onTap: () => count?.call(isIncrement),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: bgColor,
        ),
        child: AppText.title(
          text,
          customStyle: textColor != null ? TextStyle(color: textColor) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStackedImages(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildPriceSection()),
                    if (count != null)
                      Expanded(child: _buildCounter())
                    else
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: AppText.body1(
                          countNumber,
                          customStyle: TextStyle(
                            color: theme.secondaryHeaderColor,
                          ),
                        ),
                      ),
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
