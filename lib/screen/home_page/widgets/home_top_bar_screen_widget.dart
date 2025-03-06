import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTopBarScreenWidget extends StatelessWidget {
  const HomeTopBarScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            AppText.title2("Location"),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5,),
                AppText.title2("Phnom Penh, Cambodia"),
              ],
            ),

           Container(
             padding: EdgeInsets.all(8),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(100),
               color: theme.highlightColor
             ),
             child: Icon(CupertinoIcons.mail),
           )
          ],
        )
      ],
    );
  }
}
