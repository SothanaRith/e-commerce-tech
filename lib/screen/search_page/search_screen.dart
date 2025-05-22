import 'dart:async';
import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/category_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/category_model.dart';
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
import 'package:e_commerce_tech/widgets/filter_dialog_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchText = TextEditingController();
  final SearchingController searchController = Get.put(SearchingController());
  final CategoryController categoryController = Get.put(CategoryController());
  final AuthController auth = Get.put(AuthController());

  Timer? _debounce;
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000);
  double? selectedRating = 0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });

    Future.delayed(Duration.zero, () {
     categoryController.fetchAllCategory(context: context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchProducts(page: 1);
    });

    searchText.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        _searchProducts(page: 1);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchText.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _searchProducts({int page = 1}) {
    if (page == 1) {
      // New search — reset results
      searchController.searchProduct(
        context: context,
        search: searchText.text.trim(),
        categoryId: selectedCategory,
        minPrice: priceRange.start,
        maxPrice: priceRange.end,
        minRating: selectedRating,
        userId: '1',
        page: 1,
        size: 10,
        append: false,
      );
    } else {
      // Load more — append results
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        searchController.searchProduct(
          context: context,
          search: searchText.text.trim(),
          categoryId: selectedCategory,
          minPrice: priceRange.start,
          maxPrice: priceRange.end,
          minRating: selectedRating,
          userId: '1',
          page: page,
          size: 10,
          append: true,
        ).then((_) {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _loadMore() {
    if (searchController.currentPage < searchController.totalPages) {
      _searchProducts(page: searchController.currentPage + 1);
    }
  }

  void setCategory(String? category, void Function(void Function()) state) {
    Future.delayed(Duration.zero, () {
      state(() {});
      setState(() {
        selectedCategory = category;
      });
    });
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
                            _searchProducts(page: 1);
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
                              categoryController.category == null
                                  ? const Center(child: CircularProgressIndicator())
                                  : ListViewHorizontalWidget(
                                items: categoryController.category!.categories.map((cat) {
                                  return TextBtnWidget(
                                    title: cat.name,
                                    onTap: () {
                                      setCategory(cat.id, setModalState);
                                    },
                                  );
                                }).toList(),
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
                          _searchProducts(page: 1);
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
              child: RefreshIndicator(
                onRefresh: () async {
                  _searchProducts(page: 1);
                  // Wait for controller update before completing refresh
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: GetBuilder<SearchingController>(
                  builder: (_) {
                    if (searchController.isLoading && searchController.searchResults.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final results = searchController.searchResults;

                    if (results.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No results found."),
                        ),
                      );
                    }

                    return ListView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        GridCustomWidget(
                          items: results.map((item) => ItemCardWidget(product: item)).toList(),
                        ),

                        if (searchController.isLoading && searchController.searchResults.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}