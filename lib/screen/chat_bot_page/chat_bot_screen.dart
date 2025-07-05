import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/controllers/chat_contoller.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ChatController chatController = Get.put(ChatController());

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
  }

  @override
  void dispose() {
    chatController.clearServerHistory();
    chatController.clearChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: dynamic, title: "Chatbot", context: context),
      body: SafeArea(
        child: Column(
          children: [
            // 💬 Chat Message List
            Expanded(
              child: Obx(() {
                return ListView(
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
                          SizedBox(width: 6),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
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
                          SizedBox(width: 6),
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
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }),
            ),
            // 🔤 Text input + send button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller,
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          chatController.messages.clear();
                          chatController.sendMessage(text);
                          controller.clear();
                        }
                      },
                      label: 'Enter your message',
                    ),
                  ),
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
                          chatController.messages.clear();
                          chatController.sendMessage(controller.text);
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

