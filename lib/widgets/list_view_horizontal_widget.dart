import 'package:flutter/material.dart';

class ListViewHorizontalWidget extends StatelessWidget {
  final List<Widget> items;
  final double height;
  final double horizontalPadding;

  const ListViewHorizontalWidget({
    super.key,
    required this.items,
    required this.height,
    this.horizontalPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        separatorBuilder: (_, __) => SizedBox(width: horizontalPadding),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}
