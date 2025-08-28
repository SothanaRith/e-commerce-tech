import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/controllers/chat_contoller.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ChatController chatController = Get.put(ChatController());
  final ScrollController scrollController = ScrollController();

  String selectedType = 'other_question';

  // For dialog labels (use .tr for i18n)
  final Map<String, String> typeLabels = {
    'find_product': 'find_product',
    'order_help': 'how_to_order',
    'about_shop': 'who_is_this_shop',
    'other_question': 'other_question',
  };

  @override
  void initState() {
    super.initState();

    // Add a default message from the assistant if no messages exist
    if (chatController.messages.isEmpty) {
      chatController.messages.add(ResponseModel(
        role: 'assistant',
        content: 'hi_do_you_have_anything_that_i_can_help_you_today'.tr,
      ));
    }

    // Open the type selection dialog on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTypeDialog(autoOpen: true);
    });
  }

  @override
  void dispose() {
    chatController.clearChat();
    super.dispose();
  }

  Future<void> _showTypeDialog({bool autoOpen = false}) async {
    String tempType = selectedType;

    await showDialog<void>(
      context: context,
      barrierDismissible: autoOpen ? false : true, // force pick on first open
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Please select a topic'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _typeTile(
                      title: typeLabels['find_product']!,
                      value: 'find_product'.tr,
                      groupValue: tempType,
                      onChanged: (v) => setStateDialog(() => tempType = v!),
                      icon: Icons.search,
                    ),
                    _typeTile(
                      title: typeLabels['order_help']!,
                      value: 'order_help'.tr,
                      groupValue: tempType,
                      onChanged: (v) => setStateDialog(() => tempType = v!),
                      icon: Icons.shopping_cart_checkout,
                    ),
                    _typeTile(
                      title: typeLabels['about_shop']!,
                      value: 'about_shop'.tr,
                      groupValue: tempType,
                      onChanged: (v) => setStateDialog(() => tempType = v!),
                      icon: Icons.store_mall_directory,
                    ),
                    _typeTile(
                      title: typeLabels['other_question']!,
                      value: 'other_question'.tr,
                      groupValue: tempType,
                      onChanged: (v) => setStateDialog(() => tempType = v!),
                      icon: Icons.help_outline,
                    ),
                  ],
                ),
              ),
              actions: [
                if (!autoOpen)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'.tr),
                  ),
                ElevatedButton(
                  onPressed: () {
                    print(tempType);
                    print(selectedType);
                    if (selectedType != tempType) {
                      chatController.clearChat();
                    }
                    setState(() => selectedType = tempType);
                    if (chatController.messages.isEmpty) {
                      chatController.messages.add(ResponseModel(
                        role: 'assistant',
                        content: 'hi_do_you_have_anything_that_i_can_help_you_today'.tr,
                      ));
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Confirm'.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _typeTile({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: dynamic, title: "chatbot".tr, context: context, action: [
        // (model picker kept commented)
      ]),
      body: SafeArea(
        child: Column(
          children: [
            // 💬 Chat Message List
            Expanded(
              child: Obx(() {
                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
                  children: [
                    ...chatController.messages.map((message) {
                      final isUser = message.role == 'user';
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage('assets/images/img.png'),
                              ),
                            ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                // 💬 Message bubble
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: MarkdownBody(
                                    data: message.content,
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                                        .copyWith(p: const TextStyle(fontSize: 16)),
                                  ),
                                ),

                                // 📋 Copy button under bubble (both user and assistant)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                                  child: Align(
                                    alignment:
                                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: message.content));
                                        Get.snackbar(
                                          "copied".tr,
                                          "message_copied_to_clipboard".tr,
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: const Duration(seconds: 1),
                                        );
                                      },
                                      child: Icon(Icons.copy, size: 16, color: theme.primaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }).toList(),
                    // Typing animation (assistant writing)
                    if (chatController.typingText.value.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage('assets/images/img.png'),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                chatController.typingText.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }),
            ),

            // 🔤 Type selector + text input + send button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Type chip (tap to change)
                  GestureDetector(
                    onTap: () => _showTypeDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                        color: theme.primaryColor.withOpacity(0.08),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tune, size: 16),
                        ],
                      ),
                    ),
                  ),

                  // Text field
                  Expanded(
                    child: CustomTextField(
                      controller: controller,
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          chatController.sendMessage(text, scrollController, selectedType);
                          controller.clear();
                        }
                      },
                      label: 'type_a_message'.tr,
                    ),
                  ),

                  // Send button / loader
                  Obx(() {
                    return chatController.isLoading.value
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: theme.primaryColor),
                    )
                        : IconButton(
                      icon: Icon(Icons.send, color: theme.primaryColor),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          chatController.sendMessage(
                            controller.text,
                            scrollController,
                            selectedType,
                          );
                          controller.clear();
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
