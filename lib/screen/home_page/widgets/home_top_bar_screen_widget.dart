import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/notification_page/notification_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTopBarScreenWidget extends StatelessWidget {
  const HomeTopBarScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.body(" Location", customStyle: TextStyle(color: theme.highlightColor),),
            Row(
              children: [
                Icon(Icons.location_on, size: 16,),
                SizedBox(width: 5,),
                AppText.title2("Phnom Penh, Cambodia"),
              ],
            ),

          ],
        ),
        GestureDetector(
          onTap: (){
            goTo(this, NotificationScreen());
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: theme.highlightColor.withAlpha(40)
            ),
            child: Icon(CupertinoIcons.mail, size: 18,),
          ),
        )
      ],
    );
  }
}
