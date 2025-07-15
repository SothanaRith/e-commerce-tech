import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemSelectWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String prices;
  final String countNumber;
  final Function(bool isIncrement)? count;
  final Function()? onTap;
  final Function()? onAction;
  final String? actionTitle;

  const ItemSelectWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.prices,
    required this.countNumber,
    this.count, this.onTap, this.onAction, this.actionTitle,
  });

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title1(title),
        AppText.title1(prices, customStyle: TextStyle(color: theme.primaryColor)),
        InkWell(
          onTap: onAction ?? () {
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: theme.primaryColor.withAlpha(60),
            ),
            child: AppText.caption(
              actionTitle ?? "Free Delivery",
              customStyle: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
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
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                safeImageUrl( imageUrl.isEmpty ? '' : imageUrl),
                width: 90.w,
                height: 90.w,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(
                      child: CircularProgressIndicator(
                          color: theme.primaryColor),
                    ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image),
              ),
            ),
            SizedBox(
              width: 12,
            ),
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
      ),
    );
  }
}
