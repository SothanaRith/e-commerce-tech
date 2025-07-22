import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:customAppBar(type: dynamic, title: "privacy_policy".tr, context: context),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          PrivacySectionWidget(
            title: '1. Introduction',
            content:
            'Today Internet is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information.',
          ),
          SizedBox(height: 16.0),
          PrivacySectionWidget(
            title: '2. Information We Collect',
            content:
            'We may collect:\n\n• Personal Information: Name, email, and other details when creating an account.\n• Device Information: IP address, device type, and operating system.\n• Usage Data: Logs of app features you access and use.',
          ),
          SizedBox(height: 16.0),
          PrivacySectionWidget(
            title: '3. How We Use Your Information',
            content:
            'We use your information to:\n\n• Provide and improve our services.\n• Respond to your inquiries and support requests.\n• Monitor app performance and security.',
          ),
          SizedBox(height: 16.0),
          PrivacySectionWidget(
            title: '4. Sharing of Information',
            content:
            'We do not sell your information. However, we may share it:\n\n• With third-party service providers to assist in delivering app functionality.\n• To comply with legal obligations or protect our rights.',
          ),
          SizedBox(height: 16.0),
          PrivacySectionWidget(
            title: '5. Data Security',
            content:
            'We use encryption and secure storage practices to protect your data. However, no method of ...',
          ),
          SizedBox(height: 16.0),
          PrivacySectionWidget(
            title: '6. Exchange',
            content: 'All payments must be made in the official Cambodian currency (KHR).',
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

// Widget for each privacy section
class PrivacySectionWidget extends StatelessWidget {
  final String title;
  final String content;

  const PrivacySectionWidget({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}