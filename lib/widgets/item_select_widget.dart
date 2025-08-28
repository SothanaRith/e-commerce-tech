import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemSelectWidget extends StatelessWidget {
  final String imageUrl;
  final List<String>? imageUrlList;
  final String title;
  final String prices;
  final String variantTitle;
  final String countNumber;
  final String discount;
  final Function(bool isIncrement)? count;
  final Function()? onTap;
  final Function()? onAction;
  final String? actionTitle;

  const ItemSelectWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.prices,
    required this.variantTitle,
    required this.countNumber,
    this.count, this.onTap, this.onAction, this.actionTitle, required this.discount, this.imageUrlList,
  });

  Widget _buildStackedImages() {
    List<Widget> imageStack = [];

    if (imageUrlList == null)
      return SizedBox();

    for (int i = 0; i < imageUrlList!.length && i < 3; i++) {
      print("-=-=-=-${imageUrlList?[i] ?? ""}");
      imageStack.add(
        Positioned(
          left: i * 12.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              safeImageUrl("${imageUrlList?[i] ?? ""}"),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.title2(title),
            AppText.body2("( $variantTitle )"),
          ],
        ),
        SizedBox(height: 4,),
        Row(
          children: [
            AppText.title1("\$ $prices", customStyle: TextStyle(color: theme.primaryColor)),
            SizedBox(width: 6,),
            if (discount.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: theme.primaryColor.withAlpha(60),
                ),
                child: AppText.caption(
                  "$discount off",
                  customStyle: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
        SizedBox(height: 4,),
        if(actionTitle != null)
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
    return Flexible(
      child: Row(
        children: [
          _countButton("-", false, theme.highlightColor),
          SizedBox(width: 8),
          AppText.title(countNumber),
          SizedBox(width: 8),
          _countButton("+", true, theme.primaryColor,
              textColor: theme.secondaryHeaderColor),
        ],
      ),
    );
  }

  Widget _countButton(String text, bool isIncrement, Color bgColor,
      {Color? textColor}) {
    return GestureDetector(
      onTap: () => count?.call(isIncrement),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: bgColor, width: 1.5),
        ),
        child: AppText.title2(
          text,
          customStyle: TextStyle(color: bgColor),
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
            if (imageUrlList != null) ...[
              _buildStackedImages(),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: CachedNetworkImage(
                  imageUrl:
                  safeImageUrl( imageUrl.isEmpty ? '' : imageUrl),
                  width: 70.w,
                  height: 70.w,
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
            ],
            SizedBox(width: 10.w),
            Flexible(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(flex: 2,child: _buildPriceSection()),
                      if (count != null)
                        Flexible(child: _buildCounter())
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
                  SizedBox(height: 2),
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
