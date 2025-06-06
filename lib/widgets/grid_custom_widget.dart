import 'package:flutter/material.dart';

class GridCustomWidget extends StatelessWidget {
  final List<Widget> items;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final EdgeInsets? padding;
  const GridCustomWidget(
      {super.key,
      required this.items, this.crossAxisSpacing = 24,
       this.crossAxisCount = 2,
       this.childAspectRatio = 0.8,
       this.mainAxisSpacing = 12, this.padding
      });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.all(12.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Two items per row
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio, // Adjust aspect ratio for your design
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
