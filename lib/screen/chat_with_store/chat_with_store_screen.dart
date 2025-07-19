import 'package:e_commerce_tech/controllers/chat_with_store_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    controller.setChatDetails(widget.senderId, widget.receiverId);
    controller.connectSocket();
    controller.getChatHistory(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Chat with Snap pay", context: context, type: ""),

      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: Obx(() {
              final messages = controller.chatStore.value.messages;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.senderId == widget.senderId;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? theme.primaryColor : Colors.grey.shade400,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(isMe ? 10 : 0), bottomRight: Radius.circular(isMe ? 0 : 10)),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          AppText.body1(
                            message.content,
                            customStyle: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 4,),
                          AppText.caption(
                            DateTime.parse(message.createdAt).toString(),
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
          // Message input
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(label: "Type a message...", controller: messageController,),
                  ),
                  SizedBox(width: 6,),
                  GestureDetector(
                    onTap: () {
                      final text = messageController.text.trim();
                      if (text.isNotEmpty) {
                        controller.sendMessage(text);
                        messageController.clear();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(100),
                      ),
                      child: Icon(Icons.send_rounded, color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
