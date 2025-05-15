import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchText = TextEditingController();
  final SearchingController searchController = Get.put(SearchingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Search", context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.all(12.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   SizedBox(
                       width: MediaQuery.sizeOf(context).width - 80,
                       child: CustomTextField(
                         controller: searchText,
                         label: "Search something...",
                         onSubmitted: (value) async {
                           await searchController.searchProduct(
                             context: context,
                             search: value.trim(),
                           );
                         },
                         leftIcon: Padding(
                           padding: const EdgeInsets.all(12.0),
                           child: SvgPicture.asset("assets/images/icons/search.svg"),
                         ),
                       )
                   ),
                   GestureDetector(
                     onTap: () async {
                       await searchController.searchProduct(
                         context: context,
                         search: searchText.text.trim(),
                       );
                     },
                     child: Container(
                       padding: EdgeInsets.all(8),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(100),
                           color: theme.primaryColor),
                       child: SvgPicture.asset("assets/images/icons/search.svg"),
                     ),
                   )
                 ],
               ),
             ),
             SizedBox(height: 12,),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 12.0),
               child: AppText.title1("Result for 'jacket'"),
             ),
             SizedBox(height: 12,),
             GetBuilder<SearchingController>(
               builder: (controller) {
                 return GridCustomWidget(
                   items: controller.searchResults.map((item) {
                     return ItemCardWidget(
                       imageUrl: "$mainPoint${item.imageUrl != null ? item.imageUrl!.isEmpty ? '' : item.imageUrl![0] : ''}", // Change key to match your API
                       title: item.name.toString(),
                       price: "${item.price}\$",
                     );
                   }).toList(),
                 );
               },
             ),
           ],
        ),
      ),
    );
  }
}
