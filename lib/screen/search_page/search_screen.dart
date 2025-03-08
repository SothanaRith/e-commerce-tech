import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
         children: [

           Padding(
             padding: const EdgeInsets.all(12.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 SizedBox(
                     width: MediaQuery.sizeOf(context).width - 80,
                     child: CustomTextField(
                       label: "Search something...",
                       leftIcon: Icon(Icons.search),
                     )),
                 Container(
                     padding: EdgeInsets.all(8),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(100),
                         color: theme.primaryColor),
                     child: Icon(
                       Icons.menu_outlined,
                       color: theme.secondaryHeaderColor,
                     )),
               ],
             ),
           ),
           SizedBox(height: 12,),
           GridCustomWidget(items: [
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
             ItemCardWidget(
               imageUrl:
               "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
               title: "Item",
               price: "10\$",
             ),
           ])
         ],
      ),
    );
  }
}
