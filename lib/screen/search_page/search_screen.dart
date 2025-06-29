import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/category_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:e_commerce_tech/widgets/range_slider_widget.dart';
import 'package:e_commerce_tech/widgets/text_btn_widget.dart';
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
  String _lastSearchedText = '';

  List<String> selectedCategories = [];
  RangeValues priceRange = const RangeValues(0, 1000);
  double? selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
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

  void _searchProducts({int page = 1, bool append = false}) {
    final currentQuery = searchText.text.trim();
    if (page == 1 && currentQuery == _lastSearchedText && !append) return;
    _lastSearchedText = currentQuery;

    if (page == 1) {
      searchController.searchProduct(
        context: context,
        search: currentQuery,
        categoryId:
        selectedCategories.isNotEmpty ? selectedCategories.join(',') : null,
        minPrice: priceRange.start,
        maxPrice: priceRange.end,
        minRating: selectedRating,
        userId: UserStorage.currentUser?.id.toString() ?? '',
        page: 1,
        size: 10,
        append: false,
      );
    } else {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        searchController
            .searchProduct(
          context: context,
          search: currentQuery,
          categoryId: selectedCategories.isNotEmpty
              ? selectedCategories.join(',')
              : null,
          minPrice: priceRange.start,
          maxPrice: priceRange.end,
          minRating: selectedRating,
          userId: UserStorage.currentUser?.id.toString() ?? '',
          page: page,
          size: 10,
          append: true,
        )
            .then((_) => _isLoadingMore = false);
      }
    }
  }

  void _loadMore() {
    if (searchController.currentPage < searchController.totalPages) {
      searchController.currentPage += 1;
      _searchProducts(page: searchController.currentPage, append: true);
    }
  }

  void toggleCategory(String categoryId, void Function(void Function()) state) {
    state(() {});
    setState(() {
      if (selectedCategories.contains(categoryId)) {
        selectedCategories.remove(categoryId);
      } else {
        selectedCategories.add(categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: searchText,
                    label: "search_something...".tr,
                    onSubmitted: (value) {
                      _searchProducts(page: 1);
                    },
                    leftIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset("assets/images/icons/search.svg"),
                    ),
                  ),
                ),
                SizedBox(width: 14,),
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
                          child: AppText.title1("category".tr),
                        ),
                        categoryController.category == null
                            ? const Center(child: CircularProgressIndicator())
                            : ListViewHorizontalWidget(
                          items: categoryController
                              .category!.categories
                              .map((cat) {
                            return TextBtnWidget(
                              title: cat.name,
                              isSelected:
                              selectedCategories.contains(cat.id),
                              onTap: () {
                                toggleCategory(cat.id, setModalState);
                              },
                            );
                          }).toList(),
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AppText.title1("pricing_range".tr),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6),
                          child: AppText.title1("reviews".tr),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: selectedRating! >= index + 1
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setModalState(() {});
                                setState(() =>
                                selectedRating = (index + 1).toDouble());
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  onApply: () {
                    _searchProducts(page: 1);
                  },
                  onClear: () {
                    setState(() {
                      selectedCategories = [];
                      priceRange = const RangeValues(0, 1000);
                      selectedRating = 0;
                      searchText.clear();
                    });
                    _searchProducts(page: 1);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GetBuilder<SearchingController>(builder: (_) {
              final queryText =
              searchText.text.isEmpty ? 'all_products'.tr : searchText.text;
              return AppText.title1("${"result_for".tr} '$queryText'");
            }),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GetBuilder<SearchingController>(builder: (logic) {
              return Skeletonizer(
                enabled: logic.currentPage == 1 && logic.isLoading,
                child: RefreshIndicator(
                  onRefresh: () async {
                    _searchProducts(page: 1);
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: _buildSearchResults(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = searchController.searchResults;

    if (searchController.isLoading && results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_sharp, size: 120, color: theme.highlightColor),
              AppText.title("no_results_found".tr),
              const SizedBox(height: 22),
              CustomButtonWidget(
                title: 'Clear Filters',
                action: () {
                  setState(() {
                    selectedCategories = [];
                    priceRange = const RangeValues(0, 1000);
                    selectedRating = 0;
                    searchText.clear();
                  });
                  _searchProducts(page: 1);
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        GridCustomWidget(
          items: results.map((item) {
            return ItemCardWidget(
              product: item,
              onUpdateWishlist: () => _searchProducts(page: 1),
              onUpdateCheckOut: () => _searchProducts(page: 1),
              parentContext: context,
              onBackAction: () => _searchProducts(page: 1),
            );
          }).toList(),
        ),
        if (searchController.isLoading && results.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
