import 'package:flutter/material.dart';

class GridCustomWidget extends StatelessWidget {
  final List<Widget> items;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final bool hasMore;
  final bool isLoading;

  const GridCustomWidget({
    super.key,
    required this.items,
    this.crossAxisSpacing = 24,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
    this.mainAxisSpacing = 12,
    this.padding,
    this.controller,
    this.hasMore = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding ?? const EdgeInsets.all(12.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: hasMore && isLoading ? items.length + 1 : items.length,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return items[index];
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
