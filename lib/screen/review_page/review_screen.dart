import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/review_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_button_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/flexible_image_preview_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:e_commerce_tech/widgets/select_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {
  final ProductModel product;

  const ReviewScreen({super.key, required this.product});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  TextEditingController commentText = TextEditingController();
  ReviewController reviewController = Get.put(ReviewController());
  int selectedRating = 0;

  void showOptionsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: Text(
                'cancel'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            actions: <Widget>[
              buildActionSheetAction('from_gallery'.tr, Colors.blue, () {
                cropGallery(context).then((image) {
                  if (image != null) {
                    reviewController.imageSelectedList.add(image);
                    reviewController.update();
                    popBack(this);
                  }
                });
              }),
              buildActionSheetAction('from_camera'.tr, Colors.red, () {
                cropCamera(context).then((image) {
                  if (image != null) {
                    reviewController.imageSelectedList.add(image);
                    reviewController.update();
                    popBack(this);
                  }
                });
              }),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "reviews".tr, context: context),
      body: GetBuilder<ReviewController>(builder: (logic) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: ItemSelectWidget(
                  imageUrl: widget.product.imageUrl?[0] ?? '',
                  title: widget.product.name ?? '',
                  prices: widget.product.price ?? "--",
                  countNumber: 4.toString(), // Passing the callback
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 6),
                child: AppText.title1("reviews".tr),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: index < selectedRating ? Colors.amber : Colors.grey,
                        size: 32,
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextField(
                  controller: commentText,
                  label: "comment_some".tr, title: "add_detailed_review".tr,),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    showOptionsSheet(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image, color: theme.primaryColor,),
                      const SizedBox(width: 8,),
                      AppText.title2("add_photos".tr, customStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6,),
              ListViewHorizontalWidget(
                horizontalPadding: 8,
                height: 60,
                items: logic.imageSelectedList.map((imageFile) {
                  return GestureDetector(
                    onTap: () {
                      goTo(this, FlexibleImagePreview(image: logic.imageSelectedList));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: FileImage(imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomButtonWidget(
            title: "submit".tr,
            buttonStyle: BtnStyle.action,
            action: () async {
              if (selectedRating == 0) {
                showCustomDialog(
                  context: context,
                  type: CustomDialogType.info,
                  title: "Please select a rating",
                );
                return;
              }
              reviewController.createReview(
                comment: commentText.text,
                rating: selectedRating.toString(),
                productId: widget.product.id ?? '',
                context: context,
                images: reviewController.imageSelectedList,
              );
            },
          ),
        ),
      ),
    );
  }
}
