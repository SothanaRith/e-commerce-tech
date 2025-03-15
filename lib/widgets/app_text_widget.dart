import 'package:flutter/material.dart';

enum AppTextType {
  h1,
  h2,
  h3,
  h4,
  title,
  title1,
  title2,
  body,
  body1,
  body2,
  caption
}

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle? customStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final AppTextType type;

  const AppText.h1(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.bold),
        type = AppTextType.h1;

  const AppText.h2(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.bold),
        type = AppTextType.h2;

  const AppText.h3(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.bold),
        type = AppTextType.h3;

  const AppText.h4(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.bold),
        type = AppTextType.h4;

  const AppText.title(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.w600),
        type = AppTextType.title;

  const AppText.title1(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.w600),
        type = AppTextType.title1;

  const AppText.title2(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.w600),
        type = AppTextType.title2;

  const AppText.body(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.normal),
        type = AppTextType.body;

  const AppText.body1(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.normal),
        type = AppTextType.body1;

  const AppText.body2(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.normal),
        type = AppTextType.body2;

  const AppText.caption(
    this.text, {
    super.key,
    this.customStyle,
    this.textAlign,
    this.maxLines,
  })  : style = const TextStyle(fontWeight: FontWeight.normal),
        type = AppTextType.caption;

  double _responsiveFontSize(BuildContext context, double baseSize) {
    // Adjust font size based on screen width
    final width = MediaQuery.of(context).size.width;
    return baseSize *
        (width / 375); // Assuming 375 is a standard width (iPhone X)
  }

  @override
  Widget build(BuildContext context) {
    double baseFontSize;
    switch (type) {
      case AppTextType.h1:
        baseFontSize = 30;
        break;
      case AppTextType.h2:
        baseFontSize = 26;
        break;
      case AppTextType.h3:
        baseFontSize = 22;
        break;
      case AppTextType.h4:
        baseFontSize = 18;
        break;
      case AppTextType.title:
        baseFontSize = 16;
        break;
      case AppTextType.title1:
        baseFontSize = 14;
        break;
      case AppTextType.title2:
        baseFontSize = 12;
        break;
      case AppTextType.body:
        baseFontSize = 14;
        break;
      case AppTextType.body1:
        baseFontSize = 12;
        break;
      case AppTextType.body2:
        baseFontSize = 10;
        break;
      case AppTextType.caption:
        baseFontSize = 8;
        break;
    }

    double fontSize = _responsiveFontSize(context, baseFontSize);

    return Text(
      text,
      style: style
          .copyWith(
            fontSize: fontSize,
            color: Colors.black,
          )
          .merge(customStyle), // Merge default and custom styles
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}
