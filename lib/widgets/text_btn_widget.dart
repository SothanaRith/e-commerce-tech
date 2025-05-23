import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

class TextBtnWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isSelected;

  const TextBtnWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelected = false, // default is unselected
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isSelected ? theme.primaryColor : theme.secondaryHeaderColor,
          border: Border.all(
            color: isSelected ? theme.secondaryHeaderColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: AppText.title2(
            title,
            customStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87,),
          ),
        ),
      ),
    );
  }
}
