import 'package:e_commerce_tech/controllers/chat_contoller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  final ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clear the data when this screen is disposed (back navigation, or closing the app)
    chatController.messages.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBot"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  var message = chatController.messages[index];

                  // Check the role of the message and display accordingly
                  String displayMessage = '';
                  String role = message.candidates?[0].content?.role ?? '';

                  if (role == 'user') {
                    displayMessage = message.candidates?[0].content?.parts?[0].text ?? '';
                  } else if (role == 'model') {
                    displayMessage = message.candidates?[0].content?.parts?[0].text ?? '';
                  }

                  return ListTile(
                    title: Text(displayMessage),
                    tileColor: role == 'user'
                        ? Colors.blue.shade100
                        : Colors.green.shade100,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  );
                },
              );
            }),
          ),
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
          Obx(() {
            return chatController.isLoading.value
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
                : SizedBox.shrink();
          })
        ],
      ),
    );
  }
}
