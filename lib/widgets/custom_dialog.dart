import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog showCustomDialog({
  required BuildContext context,
  required DialogType type,
  AnimType animType = AnimType.scale,
  required String title,
  String desc = "",
  VoidCallback? cancelOnPress,
  Function(DismissType)? onDismissCallback,
  VoidCallback? okOnPress,
}) {
  final dialog = AwesomeDialog(
    context: context,
    dialogType: type,
    animType: animType,
    title: title,
    desc: desc,
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: true,
    onDismissCallback: onDismissCallback,
    btnCancelOnPress: cancelOnPress,
    btnOkOnPress: okOnPress,
  );
  dialog.show();
  return dialog;
}
