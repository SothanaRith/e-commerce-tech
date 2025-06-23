import 'package:e_commerce_tech/helper/global.dart';

String safeImageUrl(String url) {
  return url.startsWith('http') ? url : '$mainPoint$url';
}
