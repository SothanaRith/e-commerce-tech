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
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: items[index],
          );
        },
      ),
    );
  }
}
