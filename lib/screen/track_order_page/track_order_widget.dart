import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OrderTrackingPage(),
    );
  }
}

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  final List<Map<String, dynamic>> steps = const [
    {'title': 'Order Placed', 'icon': Icons.calculate, 'color': Colors.purple},
    {'title': 'In Process', 'icon': Icons.calculate, 'color': Colors.orange},
    {'title': 'Out for Delivery', 'icon': Icons.calculate, 'color': Colors.teal},
    {'title': 'Delivered', 'icon': Icons.calculate, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return TimelineTile(
            isFirst: index == 0,
            isLast: index == steps.length - 1,
            title: step['title'],
            time: '03.07.2025 6:30AM',
            icon: step['icon'],
            color: step['color'],
          );
        }).toList(),
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const TimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 40,
                color: Colors.green,
              ),
            Icon(Icons.check_circle, color: Colors.green),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.green,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
              Icon(icon, color: Colors.green),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(time, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
