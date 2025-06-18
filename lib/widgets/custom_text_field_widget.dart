import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? title;
  final String? subtitle;
  final Color borderColor;
  final Color textColor;
  final Color labelColor;
  final double borderRadius;
  final double borderWidth;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final bool isObscureText;
  final EdgeInsetsGeometry padding;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.borderColor = Colors.grey,
    this.textColor = Colors.black,
    this.labelColor = Colors.grey,
    this.borderRadius = 100.0,
    this.borderWidth = 1.0,
    this.textStyle,
    this.labelStyle,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.leftIcon,
    this.rightIcon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          AppText.title2(title!),
          SizedBox(height: 6.h),
        ],
        TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
          obscureText: isObscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: padding,
            prefixIcon: leftIcon,
            suffixIcon: rightIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth + 0.5,
              ),
            ),
            hintText: label,
            hintStyle: labelStyle ??
                TextStyle(
                  color: labelColor,
                  fontSize: 14,
                ),
          ),
        ),
        if (subtitle != null && subtitle != "") ...[
          SizedBox(height: 6.h),
          AppText.body2(
            subtitle!,
            customStyle: TextStyle(color: Colors.yellow.shade800),
          ),
        ],
      ],
    );
  }
}
