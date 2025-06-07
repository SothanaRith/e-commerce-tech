import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSizeWidget customAppBar({
  required dynamic type,
  required String title,
  List<Widget>? action,
  Color? titleColor,
  Color? backgroundColor,
  Color? surfaceTintColor,
  bool haveArrowBack = true,
  Function()? onBackAction,
  PreferredSizeWidget? bottom,
  required BuildContext context,
}) {
  return AppBar(
    leading: const SizedBox(),
    leadingWidth: 0,
    backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor, // Fixed background color
    surfaceTintColor: surfaceTintColor ?? theme.scaffoldBackgroundColor,
    actions: action ?? [],
    bottom: bottom,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(haveArrowBack)
        GestureDetector(
          onTap: onBackAction ?? () {
            popBack(type);
          },
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withAlpha(20)
              ),
              child: Icon(Icons.arrow_back)),
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
