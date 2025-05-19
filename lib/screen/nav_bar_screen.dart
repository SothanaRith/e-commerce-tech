import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/profile_screen.dart';
import 'package:e_commerce_tech/screen/search_page/search_screen.dart';
import 'package:e_commerce_tech/screen/wish_list_page/wish_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  final pagesList = [
    const HomeScreen(),
    const SearchScreen(),
    const WishListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            IndexedStack(
              index: currentPageIndex,
              children: pagesList,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 70,
                decoration: BoxDecoration(
                  color: theme.disabledColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: GNav(
                  color: theme.highlightColor,
                  activeColor: theme.disabledColor,
                  tabBackgroundColor: theme.secondaryHeaderColor,
                  padding: const EdgeInsets.all(12),
                  gap: 8,
                  tabs: [
                    GButton(
                      icon: Icons.h_mobiledata,
                      leading: SvgPicture.asset("assets/images/icons/home.svg", width: 40, color: theme.highlightColor,),
                      text: '',
                    ),
                    GButton(
                      icon: Icons.store,
                      leading: SvgPicture.asset("assets/images/icons/store.svg", width: 40, color: theme.highlightColor,),
                      text: '',
                    ),
                    GButton(
                      icon: CupertinoIcons.heart,
                      leading: SvgPicture.asset("assets/images/icons/heart.svg", width: 40, color: theme.highlightColor,),
                      text: '',
                    ),
                    GButton(
                      icon: Icons.person,
                      leading: SvgPicture.asset("assets/images/icons/profile.svg", width: 40, color: theme.highlightColor,),
                      text: '',
                    ),
                  ],
                  onTabChange: (value) {
                    setState(() {
                      currentPageIndex = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
