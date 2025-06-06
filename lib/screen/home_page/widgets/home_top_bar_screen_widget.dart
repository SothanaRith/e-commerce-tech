import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/notification_page/notification_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                SvgPicture.asset("assets/images/icons/pin_notification.svg"),
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
            child: SvgPicture.asset(
              'assets/images/icons/notification.svg',
              height: 20, // Adjust size
              width: 20,
            ),
          ),
        )
      ],
    );
  }
}
