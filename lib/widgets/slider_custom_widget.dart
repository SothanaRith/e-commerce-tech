import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/slide_model.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<SliderModel> imageUrls;
  final Duration duration;
  final double height;

  const ImageSlider({
    Key? key,
    required this.imageUrls,
    this.duration = const Duration(seconds: 3),
    this.height = 300.0,
  }) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Auto-slide feature
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    Future.delayed(widget.duration, () {
      if (_pageController.hasClients && !_isSliding) {
        int nextPage = (_currentPage + 1) % widget.imageUrls.length;

        _isSliding = true;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        ).then((_) {
          setState(() {
            _currentPage = nextPage;
            _isSliding = false;
          });
          _startAutoSlide();
        });
      } else {
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              if (!_isSliding) {
                setState(() {
                  _currentPage = index;
                });
              }
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: () {
                    goTo(this, ProductDetailsScreen(id: widget.imageUrls[index].order ?? ''));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(widget.imageUrls[index].imageUrl ?? '', fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imageUrls.length, (index) {
            return AnimatedContainer(
              curve: Easing.legacy,
              duration: const Duration(milliseconds: 100),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentPage == index ? 22.0 : 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: _currentPage == index ? theme.primaryColor : theme.primaryColor.withAlpha(60),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
