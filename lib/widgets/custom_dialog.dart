import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CustomDialogType { error, info, success }

IconData _getIcon(CustomDialogType type) {
  switch (type) {
    case CustomDialogType.error:
      return Icons.dangerous_rounded;
    case CustomDialogType.info:
      return Icons.warning_amber_rounded;
    case CustomDialogType.success:
      return CupertinoIcons.checkmark_alt_circle_fill;
  }
}

Color _getColor(CustomDialogType type) {
  switch (type) {
    case CustomDialogType.error:
      return Colors.redAccent;
    case CustomDialogType.info:
      return Colors.orange;
    case CustomDialogType.success:
      return theme.primaryColor;
  }
}

/// Call this function to show the dialog directly
void showCustomDialog({
  required BuildContext context,
  required CustomDialogType type,
  required String title,
  String? desc,
  VoidCallback? cancelOnPress,
  VoidCallback? okOnPress,
}) {
  final color = _getColor(type);
  final icon = _getIcon(type);

  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 28,
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              desc ?? '',
              style: const TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            if(desc == '')
            const SizedBox(height: 24),
            if (type == CustomDialogType.success)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    okOnPress?.call();
                  },
                  child: AppText.body2("Confirm", customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        cancelOnPress?.call();
                      },
                      child: AppText.body2("Cancel", customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        okOnPress?.call();
                      },
                      child: AppText.body2("Confirm", customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}
