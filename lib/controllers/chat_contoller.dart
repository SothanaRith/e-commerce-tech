import 'dart:convert';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var messages = <ResponseModel>[].obs;
  var isLoading = false.obs;
  var typingText = ''.obs;
  var selectedModel = 'gpt-4o'.obs;

  final availableModels = [ 'gpt-4o', 'gpt-4.1', 'deepseek-r1', 'blackboxai', 'gemini-2.5-pro']; // Customize
  final String apiUrl = 'http://${mainPoint.replaceAll(":3000", ":1337")}/backend-api/v2/auto/chat';

  // Send user message to backend and get assistant reply
  Future<void> sendMessage(String text, ScrollController scrollController) async {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();
    messages.add(ResponseModel(role: 'user', content: userMessage));
    isLoading(true);

    try {
      // Send only the latest 20 messages (10 exchanges)
      final history = messages
          .skip(messages.length > 20 ? messages.length - 20 : 0)
          .map((msg) => {'role': msg.role, 'content': msg.content})
          .toList();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': userMessage,
          'model': selectedModel.value,
          'history': history,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['reply'] ?? "No reply";
        await animateTyping(reply, scrollController);
      } else {
        await animateTyping('❌ ${response.statusCode} - ${response.reasonPhrase}', scrollController);
      }
    } catch (e) {
      await animateTyping('⚠️ Failed: $e', scrollController);
      debugPrint("⚠️ Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Typing animation effect (frontend only)
  Future<void> animateTyping(String reply, ScrollController scrollController) async {
    typingText.value = '';
    for (int i = 0; i < reply.length; i++) {
      await Future.delayed(Duration(milliseconds: 30));
      typingText.value += reply[i];

      // 👇 Auto-scroll on each character
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 60,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }

    messages.add(ResponseModel(role: 'assistant', content: typingText.value));
    typingText.value = '';
  }


  // Clear UI chat messages
  void clearChat() {
    messages.clear();
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
