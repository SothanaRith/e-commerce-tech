import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/category_page/category_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:flutter/material.dart';

class CategoryHomeScreenWidget extends StatelessWidget {
  const CategoryHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        SizedBox(height: 4),
        ListViewHorizontalWidget(items: _buildCategoryItems(), height: 130),
        SizedBox(height: 6),
        ListViewHorizontalWidget(items: _buildFilterItems(), height: 32),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.title2("Category", customStyle: TextStyle(fontWeight: FontWeight.bold)),
          AppText.body2("See All", customStyle: TextStyle(fontWeight: FontWeight.w600, color: theme.primaryColor)),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryItems() {
    return List.generate(6, (index) => GestureDetector(
      onTap: () => goTo(this, CategoryScreen()),
      child: _categoryItem(),
    ));
  }

  Widget _categoryItem() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: theme.primaryColor.withAlpha(20),
          ),
          child: Icon(Icons.import_contacts, size: 35, color: theme.primaryColor),
        ),
        SizedBox(height: 5),
        AppText.body2("Category", customStyle: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<Widget> _buildFilterItems() {
    List<String> filters = ["All", "Newest", "Popular", "Man", "WomanS", "All", "All", "All"];
    return filters.map((filter) => _filterItem(filter)).toList();
  }

  Widget _filterItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: theme.highlightColor),
      ),
      child: Center(child: AppText.body2(title, customStyle: TextStyle(fontWeight: FontWeight.bold),)),
    );
  }
}
