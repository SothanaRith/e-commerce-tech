import 'package:e_commerce_tech/theme/shadow.dart';
import 'package:flutter/material.dart';

Container cardCustom({required Widget child, EdgeInsetsGeometry? padding, Color? color, double? borderRadius, bool haveShadow = true}) {
  return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 24),
          boxShadow: [haveShadow ? defaultShadow() : const BoxShadow()]
      ),
      child: child
  );
}