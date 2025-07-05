import 'dart:convert';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var messages = <ResponseModel>[].obs;
  var isLoading = false.obs;
  var typingText = ''.obs; // Add this

  final String apiUrl = 'http://192.168.0.105:3000/api/chats'; // ⬅️ Change if deployed

  // Track chat history (optional, your backend also does this)
  List<Map<String, dynamic>> conversation = [];

  // Send a message to your OpenAI-powered backend
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();
    messages.add(ResponseModel(
      role: 'user',
      content: userMessage,
    ));
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/chat-tubo'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': userMessage, 'userId': UserStorage.currentUser?.id ?? '1'}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final replyData = data['data'] ?? data['response'] ?? "No response";

        String cleanReply(String input) {
          if (input.startsWith('"') && input.endsWith('"')) {
            return input.substring(1, input.length - 1);
          }
          return input;
        }

        final reply = cleanReply(
            replyData is String
                ? replyData
                : (replyData['content'] is String
                ? replyData['content']
                : json.encode(replyData['content']))
        );

        await animateTyping(reply);
      } else {
        await animateTyping('❌ Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      await animateTyping('⚠️ Error sending message: $e');
      debugPrint("⚠️ Error sending message: $e");
    } finally {
      isLoading(false);
    }
  }

  // Clear chat (frontend only — backend memory not cleared)
  void clearChat() {
    messages.clear();
  }

  // Optional: Call your backend to clear server history
  Future<void> clearServerHistory() async {
    try {
      await http.post(Uri.parse('$apiUrl/clear'), headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': UserStorage.currentUser?.id ?? ''}),);
      clearChat();
    } catch (e) {
      print("Failed to clear server history: $e");
    }
  }

  Future<void> animateTyping(String reply) async {
    typingText.value = ''; // Clear before start
    for (int i = 0; i < reply.length; i++) {
      await Future.delayed(Duration(milliseconds: 30)); // typing speed
      typingText.value += reply[i];
    }
    messages.add(ResponseModel(role: 'assistant', content: typingText.value));
    typingText.value = ''; // Reset after full message is added
  }


}

class ResponseModel {
  final String role;
  final String content;

  ResponseModel({
    required this.role,
    required this.content,
  });
}
