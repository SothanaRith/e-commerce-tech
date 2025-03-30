import 'package:e_commerce_tech/screen/forget_password_page/forget_password_screen.dart';
import 'package:e_commerce_tech/screen/forget_password_page/help_center.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../forget_password_page/privacy.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Your profile',
      iconName: "assets/images/icons/person.svg",
      screen: const HomeScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'My Orders',
      iconName:"assets/images/icons/shopping_bag.svg",
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'Password Manager',
      iconName: 'assets/images/icons/key.svg',
      screen: const ForgetPasswordScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'Help Center',
      iconName: "assets/images/icons/warning.svg",
      screen: const HelpCenter(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'Privacy Policy',
      iconName: "assets/images/icons/lock.svg",
      screen: const PrivacyScreen(),
      hasSpecialAction: false,
    ),
    MenuItem(
      title: 'Log out',
      iconName: "assets/images/icons/logout.svg",
      hasSpecialAction: true, // Flag for special action (bottom sheet)
    ),
  ];

  // Method to show logout bottom sheet
  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logout logic here (e.g., clear user session)
                        Navigator.pop(context); // Close the bottom sheet
                        // Example: Navigate to a login screen or reset app state
                        // goTo(this, const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300], // Placeholder color
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset("assets/images/icons/edit-2.svg")
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Spacing between avatar and text
                  const Text(
                    'Rose BanSon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Menu items list
            ListView.builder(
              shrinkWrap: true, // Allows ListView to take only the space it needs
              physics: const NeverScrollableScrollPhysics(), // Disables ListView's scrolling
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset(
                        menuItems[index].iconName,
                        color: Colors.green,
                      ),
                      title: Text(
                        menuItems[index].title,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing:  SvgPicture.asset(
                      "assets/images/icons/arrow-down.svg"
                      ),
                      onTap: () {
                        if (menuItems[index].hasSpecialAction) {
                          // Handle special actions like showing a bottom sheet
                          if (menuItems[index].title == 'Log out') {
                            _showLogoutBottomSheet(context);
                          }
                        } else if (menuItems[index].screen != null) {
                          // Navigate to the screen if it exists
                          goTo(this, menuItems[index].screen!);
                        }
                      },
                    ),
                    if (index < menuItems.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                        indent: 16, // Optional: adds padding on the left
                        endIndent: 16, // Optional: adds padding on the right
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String iconName;
  final dynamic screen;
  final bool hasSpecialAction; // Flag for special actions like bottom sheet

  MenuItem({
    required this.title,
    required this.iconName,
    this.screen,
    this.hasSpecialAction = false, // Default to false
  });
}
