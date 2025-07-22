import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final List<FaqItem> faqItems = [
    FaqItem(
      question: 'How do I connect to a WiFi network using the app?',
      answerTitle: 'To connect to a WiFi network using the app, follow these steps:',
      answerSteps: [
        '1. Open the app on your device.',
        '2. Go to the WiFi settings section.',
        '3. Select your desired network and enter the password if required.',
        '4. Click "Connect" to join the network.',
      ],
    ),
    FaqItem(
      question: 'How do I connect to a WiFi network using the app?',
      answerTitle: 'To connect to a WiFi network using the app, follow these steps:',
      answerSteps: [
        '1. Open the app on your device.',
        '2. Go to the WiFi settings section.',
        '3. Select your desired network and enter the password if required.',
        '4. Click "Connect" to join the network.',
      ],
    ),
    FaqItem(
      question: 'Can I monitor connected devices on my WiFi?',
      answerTitle: 'Yes, you can monitor connected devices using the app\'s network management feature. Here\'s how:',
      answerSteps: [
        '1. Navigate to the network monitoring section.',
        '2. View the list of connected devices.',
        '3. Enable monitoring for detailed insights.',
      ],
    ),
    FaqItem(
      question: 'Can I monitor connected devices on my WiFi?',
      answerTitle: 'Yes, you can monitor connected devices using the app\'s network management feature. Here\'s how:',
      answerSteps: [
        '1. Navigate to the network monitoring section.',
        '2. View the list of connected devices.',
        '3. Enable monitoring for detailed insights.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: FAQ and Contact Us
      child: Scaffold(
        appBar: AppBar(
          title: Text('help_center'.tr),
          bottom: TabBar(
            tabs: [
              Tab(text: 'faq'.tr),
              Tab(text: 'contact_us'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // FAQ Tab
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                final faqItem = faqItems[index];
                return ExpansionTile(
                  title: Text(faqItem.question),
                  trailing: const Icon(Icons.expand_more),
                  children: [
                    ListTile(
                      title: Text(
                        faqItem.answerTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: faqItem.answerSteps
                            .map((step) => Text(step))
                            .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Contact Us Tab
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  title: Text(
                    'contact_us'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: snapbuy81@gmail.com'),
                      Text('Phone: +855 127 943 3221'),
                      Text('Hours: Monday - Friday, 9 AM - 5 PM'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answerTitle;
  final List<String> answerSteps;

  FaqItem({
    required this.question,
    required this.answerTitle,
    required this.answerSteps,
  });
}