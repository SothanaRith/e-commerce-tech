import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? id;

  const ItemCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print(id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(id: id ?? '20',),));
        },
      child: Column(
        spacing: 2,
        children: [
          // Maintain aspect ratio for the image
          AspectRatio(
            aspectRatio: 1, // Square image
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover, // Ensure the image scales properly
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      color: Colors.white.withAlpha(90),
                    ),
                    child: SvgPicture.asset("assets/images/icons/heart.svg", width: 20,),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title1(title, customStyle: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis, ),
                    maxLines: 1,
                    ),
                    AppText.title1(
                      price, customStyle: TextStyle(color: theme.primaryColor, fontSize: 14, overflow: TextOverflow.ellipsis,),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  color: theme.primaryColor.withAlpha(30),
                ),
                child: SvgPicture.asset("assets/images/icons/add_store.svg", width: 20,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
