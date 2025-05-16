import 'dart:async';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/widgets/filter_dialog_widget.dart'; // Your filter dialog widget

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchText = TextEditingController();
  final SearchingController searchController = Get.put(SearchingController());

  Timer? _debounce;

  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000);

  final List<Map<String, String>> categories = [
    {'id': '1', 'name': 'Clothing'},
    {'id': '2', 'name': 'Electronics'},
    {'id': '3', 'name': 'Books'},
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.searchProduct(
        context: context,
        search: '',
      );
    });

    searchText.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        final query = searchText.text.trim();
        searchController.searchProduct(
          context: context,
          search: query,
          categoryId: selectedCategory,
          minPrice: priceRange.start,
          maxPrice: priceRange.end,
        );
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Search", context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search + Filter row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 80,
                    child: CustomTextField(
                      controller: searchText,
                      label: "Search something...",
                      onSubmitted: (value) {
                        searchController.searchProduct(
                          context: context,
                          search: value.trim(),
                          categoryId: selectedCategory,
                          minPrice: priceRange.start,
                          maxPrice: priceRange.end,
                        );
                      },
                      leftIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset("assets/images/icons/search.svg"),
                      ),
                    ),
                  ),

                  FilterDialogWidget(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: theme.primaryColor,
                      ),
                      child: SvgPicture.asset("assets/images/icons/filter.svg"),
                    ),
                    filterContent: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCategory,
                            hint: const Text("Select Category"),
                            items: categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat['id']!,
                                child: Text(cat['name']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCategory = val;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          const Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold)),
                          RangeSlider(
                            values: priceRange,
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            labels: RangeLabels("\$${priceRange.start.round()}", "\$${priceRange.end.round()}"),
                            onChanged: (range) {
                              setState(() {
                                priceRange = range;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    onApply: () {
                      searchController.searchProduct(
                        context: context,
                        search: searchText.text.trim(),
                        categoryId: selectedCategory,
                        minPrice: priceRange.start,
                        maxPrice: priceRange.end,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GetBuilder<SearchingController>(
                builder: (_) {
                  final queryText = searchText.text.isEmpty ? 'all products' : searchText.text;
                  return AppText.title1("Result for '$queryText'");
                },
              ),
            ),

            const SizedBox(height: 12),

            GetBuilder<SearchingController>(
              builder: (_) {
                final results = searchController.searchResults;
                if (results.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No results found."),
                    ),
                  );
                }
                return GridCustomWidget(
                  items: results.map((item) {
                    return ItemCardWidget(
                      imageUrl:
                      "$mainPoint${item.imageUrl != null && item.imageUrl!.isNotEmpty ? item.imageUrl![0] : ''}",
                      title: item.name ?? '',
                      price: "${item.price}\$",
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
