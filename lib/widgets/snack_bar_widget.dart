import 'package:e_commerce_tech/theme/shadow.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SnackBarWidget extends StatefulWidget {
  const SnackBarWidget({
    super.key,
    required this.view,
    required this.snackBarView,
  });

  final Widget view;
  final Widget snackBarView;

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isDismissible: true, // Allows dismissal when tapping outside
          enableDrag: true,    // Allows dismissal by dragging down
          builder: (context) => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  popBack(this);
                },
                child: Container(
                  color: Colors.transparent, // Full-screen transparent overlay
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30), // Rounded corners for the top
                      ),
                      boxShadow: [
                        defaultShadow()
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController, // Attach scroll controller
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(); // Dismiss the modal
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width / 7,
                              margin: const EdgeInsets.all(16),
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                          widget.snackBarView,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      child: widget.view,
    );
  }
}
