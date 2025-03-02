import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSizeWidget customAppBar({
  required dynamic type,
  required String title,
  Color? titleColor,
  Color? backgroundColor,
  Color? surfaceTintColor,
  bool haveArrowBack = true,
  required BuildContext context,
}) {
  return AppBar(
    leading: const SizedBox(),
    leadingWidth: 0,
    backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor, // Fixed background color
    surfaceTintColor: surfaceTintColor ?? Theme.of(context).scaffoldBackgroundColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(haveArrowBack)
        GestureDetector(
          onTap: () {
            popBack(type);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: titleColor ?? Colors.black, // Ensure icon color is visible
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? Colors.black, // Fixed text color
          ),
        ),
      ],
    ),
  );
}
