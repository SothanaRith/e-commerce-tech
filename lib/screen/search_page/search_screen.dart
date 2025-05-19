import 'dart:async';
import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:e_commerce_tech/widgets/range_slider_widget.dart';
import 'package:e_commerce_tech/widgets/text_btn_widget.dart';
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
  final AuthController auth = Get.put(AuthController());

  Timer? _debounce;

  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000);
  double? selectedRating = 0;

  final List<Map<String, String>> categories = [
    {'id': '1', 'name': 'Clothing'},
    {'id': '2', 'name': 'Electronics'},
    {'id': '3', 'name': 'Books'},
  ];

  @override
  void initState() {
    super.initState();

    // Ensures initial fetch happens after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.searchProduct(
        context: context,
        search: '', userId: '1',
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
          minRating: selectedRating, userId: '1',
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
      // appBar: customAppBar(type: this, title: "Search", context: context),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              minRating: selectedRating, userId: '1',
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: theme.primaryColor,
                          ),
                          child: SvgPicture.asset("assets/images/icons/filter.svg"),
                        ),
                        filterContent: (setModalState) => SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: AppText.title1("Category"),
                              ),
                              ListViewHorizontalWidget(
                                items: [
                                  TextBtnWidget(title: "Clothing", onTap: () {
                                    setCategory('1', setModalState);
                                  }),
                                  TextBtnWidget(title: "Electronics", onTap: () {
                                    setCategory('2', setModalState);
                                  }),
                                  TextBtnWidget(title: "Books", onTap: () {
                                    setCategory('3', setModalState);
                                  }),
                                ],
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: AppText.title1("Pricing Range"),
                              ),
                              RangeSliderWidget(
                                min: 0,
                                max: 3000,
                                start: priceRange.start,
                                end: priceRange.end,
                                onChanged: (values) {
                                  setModalState(() {});
                                  setState(() => priceRange = values);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                                child: AppText.title1("Reviews"),
                              ),
                              Row(
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      color: selectedRating! >= index + 1 ? Colors.amber : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setModalState(() {});
                                      setState(() => selectedRating = (index + 1).toDouble());
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
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
                            minRating: selectedRating, userId: '1',
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
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              product: item
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Set the selected category
  void setCategory(String? category, void Function(void Function()) state) {
    Future.delayed(Duration.zero, () {
      state(() {});
      setState(() {
        selectedCategory = category;
      });
    });

  }
}
