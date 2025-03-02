import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';

Widget flagViewWidget({required String countryCode,double? size}) {
  return CountryFlag.fromCountryCode(
    countryCode,
    width: size ?? 32,
    height: size ?? 32,
    shape: const Circle(),
  );
}