import 'dart:io';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FlexibleImagePreview extends StatelessWidget {
  final dynamic image; // Can be File, String (URL), or List
  final int initialIndex;

  const FlexibleImagePreview({
    Key? key,
    required this.image,
    this.initialIndex = 0,
  }) : super(key: key);

  List<dynamic> _normalizeImages() {
    if (image == null) return [];
    if (image is List) return image;
    return [image];
  }

  ImageProvider? _resolveImage(dynamic img) {
    try {
      if (img is File) return FileImage(img);
      if (img is String && img.startsWith('http')) return NetworkImage(img);
      if (img is String) return NetworkImage(safeImageUrl(img));
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final images = _normalizeImages();
    if (images.isEmpty) return const SizedBox();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: images.length,
              pageController: PageController(initialPage: initialIndex),
              builder: (context, i) {
                final provider = _resolveImage(images[i]);
                return PhotoViewGalleryPageOptions(
                  imageProvider: provider,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  popBack(this);
                },
                child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(100)
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.white,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
