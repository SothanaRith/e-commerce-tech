import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/search_page/search_screen.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_tech/screen/filter_page/filter_screen.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false; // Track the expansion state

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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Widget with Animated Expansion
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isExpanded ? 200 : 0,
              width: double.infinity,
              color: Colors.blue.withOpacity(0.5), // Example styling
              child: Center(
                child: Text(
                  "Expanded Widget",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 50),
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
                    onTap: (){
                      goTo(this, SearchScreen());
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width - 80,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 1, color: theme.primaryColor)
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SvgPicture.asset("assets/images/icons/search.svg"),
                          ),
                          SizedBox(width: 12,),
                          AppText.body1("Search something...")
                        ],
                      )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      goTo(this, const FilterScreen());
                    },
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
            GridCustomWidget(
              items: List.generate(
                9,
                    (index) => const ItemCardWidget(
                  imageUrl:
                  "https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg",
                  title: "Item",
                  price: "10\$",
                ),
              ),
            ),
            const SizedBox(height: 130),
          ],
        ),
      ),
    );
  }
}
