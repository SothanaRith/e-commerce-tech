import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

class TextBtnWidget extends StatelessWidget {

  final String title;
  const TextBtnWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: theme.highlightColor
      ),
      child: Center(child: AppText.title2(title)),
    );
  }
}
