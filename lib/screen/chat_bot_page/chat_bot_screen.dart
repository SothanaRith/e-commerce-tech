import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:e_commerce_tech/controllers/chat_contoller.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ChatController chatController = Get.put(ChatController());

  @override
  void dispose() {
    chatController.clearChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBot"),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              chatController.clearChat();
              chatController.clearServerHistory(); // Optional: clear backend history
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 🔁 Running Marquee Text
          SizedBox(
            height: 30,
            child: Marquee(
              text: '🛍️ Welcome to AI Assistant — Ask about deals, delivery, returns, and more!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              blankSpace: 40.0,
              velocity: 50.0,
              pauseAfterRound: Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),

          // 💬 Chat Message List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isUser = message.role == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // 🔤 Text input + send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        chatController.sendMessage(text);
                        controller.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      chatController.sendMessage(controller.text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),

          // ⏳ Loading Indicator
          Obx(() {
            return chatController.isLoading.value
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
