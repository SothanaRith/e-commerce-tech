import 'package:flutter/material.dart';

enum CustomDialogType { error, info, success }

class showCustomDialog extends StatelessWidget {
  final CustomDialogType type;
  final BuildContext? context;
  final String title;
  final String? desc;
  final VoidCallback? cancelOnPress;
  final VoidCallback? okOnPress;

  const showCustomDialog({
    super.key,
    required this.type,
    required this.title,
    this.desc,
    this.cancelOnPress,
    this.okOnPress, this.context,
  });

  IconData get icon {
    switch (type) {
      case CustomDialogType.error:
        return Icons.delete;
      case CustomDialogType.info:
        return Icons.warning_amber_rounded;
      case CustomDialogType.success:
        return Icons.check_circle_outline;
    }
  }

  Color get color {
    switch (type) {
      case CustomDialogType.error:
        return Colors.redAccent;
      case CustomDialogType.info:
        return Colors.orange;
      case CustomDialogType.success:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              child: Icon(icon, color: color, size: 28),
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
                  child: const Text("Confirm"),
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
                      child: const Text("Cancel"),
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
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
