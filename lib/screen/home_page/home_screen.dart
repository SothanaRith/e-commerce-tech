import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/search_page/search_screen.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_tech/screen/filter_page/filter_screen.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false; // Track the expansion state
  final HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    super.initState();
  
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels < -100 && !_isExpanded) {
      setState(() {
        _isExpanded = true;
      });
    } else if (_scrollController.position.pixels > 50 && _isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => CustomScrollView(
        controller: homeController.scrollController,
        slivers: [
          // Sliver AppBar-like content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _isExpanded ? 200 : 0,
                  width: double.infinity,
                  color: Colors.blue.withOpacity(0.5),
                  child: const Center(
                    child: Text("Expanded Widget", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 60),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: HomeTopBarScreenWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => goTo(this, SearchScreen()),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width - 80,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: theme.primaryColor),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/images/icons/search.svg"),
                              const SizedBox(width: 12),
                              AppText.body1("Search something..."),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => goTo(this, const FilterScreen()),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: theme.primaryColor,
                          ),
                          child: SvgPicture.asset("assets/images/icons/filter.svg"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const ImageSlider(
                  imageUrls: [
                    'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                    'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                    'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                  ],
                  height: 200,
                ),
                const SizedBox(height: 12),
                const CategoryHomeScreenWidget(),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Sliver Grid (paged)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index < homeController.products.length) {
                    final product = homeController.products[index];
                    return ItemCardWidget(
                      imageUrl: 'https://epaymentuat.acledabank.com.kh:8544/files/PCAT1746158068408.jpg',
                      title: product.name ?? '',
                      price: '\$${product.price ?? ''}',
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
                childCount: homeController.hasMore.value && homeController.isLoading.value
                    ? homeController.products.length + 1
                    : homeController.products.length,
              ),
            ),
          ),

          // Bottom spacer
          SliverToBoxAdapter(child: const SizedBox(height: 132)),
        ],
      )),
    );
  }

}
