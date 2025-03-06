import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeTopBarScreenWidget(),
            Row(
              children: [
                CustomTextField(label: "Search something...", leftIcon: Icon(Icons.search),),
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: theme.primaryColor
                    ),
                    child: Icon(Icons.menu_outlined))
              ],
            ),
            // slide

            CategoryHomeScreenWidget()
          ],
        ),
      ),
    );
  }
}
