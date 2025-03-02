import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

enum BtnStyle {
  action,
  normal,
  none,
}

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final Function()? action;
  final BtnStyle buttonStyle;
  final IconData? icon;
  final double? height;
  final double? width;
  const CustomButtonWidget({
    super.key,
    required this.title,
    required this.action,
    this.buttonStyle = BtnStyle.normal,
    this.icon,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        width: width ?? MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: buttonStyle == BtnStyle.action
                ? theme.primaryColor
                : buttonStyle == BtnStyle.normal
                    ? theme.highlightColor
                    : Colors.transparent,
            border: Border.all(
                width: 2,
                color: buttonStyle == BtnStyle.none
                    ? theme.highlightColor
                    : Colors.transparent
            ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon),
            ],
            AppText.h4(title, customStyle: TextStyle(color: buttonStyle == BtnStyle.action ? theme.secondaryHeaderColor : buttonStyle == BtnStyle.normal ? theme.scaffoldBackgroundColor : theme.highlightColor),),
          ],
        ),
      ),
    );
  }
}
