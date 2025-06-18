import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:e_commerce_tech/theme/shadow.dart';

class FilterDialogWidget extends StatefulWidget {
  const FilterDialogWidget({
    super.key,
    required this.child,
    required this.filterContent,
    required this.onApply,
    required this.onClear,
  });

  final Widget child;
  final Widget Function(StateSetter) filterContent;
  final VoidCallback onApply;
  final VoidCallback onClear;

  @override
  State<FilterDialogWidget> createState() => _FilterDialogWidgetState();
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isDismissible: true,
          enableDrag: true,
          builder: (context) => Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      boxShadow: [defaultShadow()],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: StatefulBuilder(
                        builder: (context, setModalState) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
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
                              widget.filterContent(setModalState),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    CustomButtonWidget(
                                      title: 'Apply Filters',
                                      action: () { Navigator.of(context).pop();
                                      widget.onApply(); },
                                      buttonStyle: BtnStyle.action,
                                    ),
                                    SizedBox(height: 12,),
                                    CustomButtonWidget(
                                      title: 'Clear Filters',
                                      action: () { Navigator.of(context).pop();
                                      widget.onClear(); },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
