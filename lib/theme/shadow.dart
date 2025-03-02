import 'package:flutter/material.dart';

BoxShadow defaultShadow({Color? color}) {
  return BoxShadow(
    blurRadius: 30,
    offset: const Offset(0, 5),
    blurStyle: BlurStyle.normal,
    color: color ?? Colors.black.withOpacity(0.04)
  );
}