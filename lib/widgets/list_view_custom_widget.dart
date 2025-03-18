import 'package:flutter/material.dart';

class ListViewCustomWidget extends StatelessWidget {

  final List<Widget> items;
  const ListViewCustomWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
      return items[index];
    },);
  }
}
