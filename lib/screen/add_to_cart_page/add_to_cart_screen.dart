// import 'package:e_commerce_tech/screen/check_out_page/payment_method_screen.dart';
// import 'package:e_commerce_tech/utils/tap_routes.dart';
// import 'package:e_commerce_tech/widgets/item_select_widget.dart';
// import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
// import 'package:flutter/material.dart';
//
// class AddToCartScreen extends StatefulWidget {
//   const AddToCartScreen({super.key});
//
//   @override
//   State<AddToCartScreen> createState() => _AddToCartScreenState();
// }
//
// class _AddToCartScreenState extends State<AddToCartScreen> {
//
//   int itemCount = 1;
//
//   // Callback function to handle increment and decrement
//   void updateCount(bool isIncrement) {
//     setState(() {
//       if (isIncrement) {
//         itemCount++;
//       } else if (itemCount > 1) {
//         itemCount--;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: ListViewCustomWidget(items: [
//                 GestureDetector(
//                   onTap: (){
//                     goTo(this, PaymentMethodScreen());
//                   },
//                   child: ItemSelectWidget(
//                     imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                     title: 'Tech Gadget',
//                     prices: '\$199.99',
//                     count: updateCount,
//                     countNumber: itemCount.toString(), // Passing the callback
//                   ),
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//                 ItemSelectWidget(
//                   imageUrl: 'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
//                   title: 'Tech Gadget',
//                   prices: '\$199.99',
//                   count: updateCount,
//                   countNumber: itemCount.toString(), // Passing the callback
//                 ),
//               ]),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
