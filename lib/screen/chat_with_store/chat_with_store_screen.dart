import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/chat_with_store_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:e_commerce_tech/widgets/flexible_image_preview_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:e_commerce_tech/widgets/select_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatWithStoreScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  ChatWithStoreScreen({
    required this.senderId,
    required this.receiverId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatWithStoreScreen> createState() => _ChatWithStoreScreenState();
}

class _ChatWithStoreScreenState extends State<ChatWithStoreScreen> {
  final TextEditingController messageController = TextEditingController();
  final ChatWithStoreController controller = Get.put(ChatWithStoreController());
  final ScrollController scrollController = ScrollController();
  Rx<String?> imagePreviewPath = Rx<String?>(
      null); // To store the image path for preview

  @override
  void initState() {
    super.initState();
    controller.setChatDetails(widget.senderId, widget.receiverId);
    controller.connectSocket(scrollToBottom);
    controller.getChatHistory(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      context: context,
    );
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void showOptionsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          GetBuilder<AuthController>(builder: (logic) {
            return Skeletonizer(
              enabled: logic.isLoading,
              child: CupertinoActionSheet(
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
                        imagePreviewPath.value = image
                            .path; // Set image path for preview
                        controller.image = image.path;
                        popBack(this);
                      }
                    });
                  }),
                  buildActionSheetAction('from_camera'.tr, Colors.red, () {
                    cropCamera(context).then((image) {
                      if (image != null) {
                        imagePreviewPath.value = image
                            .path; // Set image path for preview
                        controller.image = image.path;
                        popBack(this);
                      }
                    });
                  }),
                ],
              ),
            );
          }),
    );
  }

  void sendMessageWithImageAndCaption() {
    final text = messageController.text.trim();
    if (text.isNotEmpty || imagePreviewPath.value != null) {
      // Validate the image size (100 KB = 102400 bytes)
      if (imagePreviewPath.value != null) {
        final file = File(imagePreviewPath.value!);
        final fileSizeInBytes = file.lengthSync();
        if (fileSizeInBytes > (102400 * 5)) {
          showCustomDialog(
            context: context,
            type: CustomDialogType.error,
            title: "File Size",
            desc: "File is too large. Maximum allowed size is 500 KB.",
          );
          return;
        }

        // If the file size is valid, send the message with the image
        String base64Image = '';
        final bytes = file.readAsBytesSync();
        base64Image = base64Encode(bytes);

        controller.sendMessageWithImage(text, base64Image);
      } else {
        // Send message without image if no image is selected
        controller.sendMessageWithImage(text, '');
      }

      // Clear after sending
      messageController.clear();
      imagePreviewPath.value = null; // Clear preview after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: "Chat with Store", context: context, type: ""),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = controller.chatStore.value.messages;
              if (messages.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    scrollToBottom();
                  });
                });
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.senderId == widget.senderId;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment
                        .centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      constraints: BoxConstraints(maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? theme.primaryColor : Colors.grey.shade400,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(isMe ? 10 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.fileUrl != null &&
                              message.fileUrl!.isNotEmpty) ...[
                            GestureDetector(
                              onTap: () {
                                goTo(this, FlexibleImagePreview(image: safeImageUrl(message.fileUrl!)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(10),
                                child: Image.network(
                                  safeImageUrl(message.fileUrl!),
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                          if (message.content.isNotEmpty)
                            AppText.body(
                              message.content,
                              customStyle: const TextStyle(color: Colors.white),
                            ),
                          SizedBox(height: 2),
                          AppText.caption(
                            formatDateString(message.createdAt),
                            customStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 8),
              child: Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Type a message...",
                        controller: messageController,
                        leftIcon: GestureDetector(
                          onTap: () {
                            showOptionsSheet(context);
                          },
                          child: Icon(Icons.image, color: theme.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    if (imagePreviewPath.value != null)
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                goTo(
                                    this,
                                    FlexibleImagePreview(
                                        image: File(imagePreviewPath.value!)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(4),
                                child: Image.file(
                                  File(imagePreviewPath.value!),
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  imagePreviewPath.value = null;
                                },
                                child: Icon(CupertinoIcons.xmark_circle_fill, color: Colors.red.shade800, size: 20,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: sendMessageWithImageAndCaption,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(Icons.send_rounded,
                            color: theme.primaryColor),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
