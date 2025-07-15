import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';

class VariantWidget extends StatefulWidget {
  final Variants variants;
  final bool isSelected;

  const VariantWidget({super.key, required this.variants, this.isSelected = false});

  @override
  State<VariantWidget> createState() => _VariantWidgetState();
}

class _VariantWidgetState extends State<VariantWidget> {
  @override
  Widget build(BuildContext context) {
    var item = widget.variants;
    return Container(
      constraints: BoxConstraints(
        minWidth: 100,
        maxWidth: MediaQuery.sizeOf(context).width * 0.8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withAlpha(widget.isSelected ? 60 : 30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.imageUrl != null &&
                  item.imageUrl != 'null') ...[
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                    safeImageUrl(item.imageUrl ?? ''),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                          color: theme.primaryColor),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(item.title != 'null')
                    AppText.title2(item.title ?? ''),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText.body2('\$ ${item.price}', customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 4),
                      AppText.body1('|'),
                      const SizedBox(width: 4),
                      AppText.body2("${item.stock}'s in stock", customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w400),),
                    ],
                  ),
                ],
              ),
            ],
          ),
          IntrinsicWidth(
            stepWidth: 160,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: item.variantAttributes
                      ?.map((attribute) {
                    return Container(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal: 10,
                          vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.primaryColor
                            .withAlpha(30),
                        borderRadius:
                        BorderRadius.circular(
                            8),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 9,
                              color: theme
                                  .primaryColor),
                          children: [
                            TextSpan(
                                text:
                                "${attribute.name}: "),
                            TextSpan(
                              text:
                              "${attribute.value}",
                              style: const TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList() ??
                      [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
