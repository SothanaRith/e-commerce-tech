import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var messages = <ResponseModel>[].obs;
  var isLoading = false.obs;

  final String apiUrl = 'http://localhost:3000/api/chat'; // ⬅️ Change if deployed

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
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final reply = data['data'] ?? data['response'] ?? "No response";

        messages.add(ResponseModel(
          role: 'assistant',
          content: reply,
        ));
      } else {
        messages.add(ResponseModel(
          role: 'assistant',
          content: '❌ Error: ${response.statusCode} - ${response.reasonPhrase}',
        ));
      }
    } catch (e) {
      messages.add(ResponseModel(
        role: 'assistant',
        content: '⚠️ Error sending message: $e',
      ));
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
      await http.post(Uri.parse('$apiUrl/clear'));
      clearChat();
    } catch (e) {
      print("Failed to clear server history: $e");
    }
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
