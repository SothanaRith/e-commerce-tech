import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ---------------- Controller ---------------- //

class ChatWithStoreController extends GetxController {
  final apiRepository = ApiRepository();
  IO.Socket? socket;

  /// Now chatStore is observable
  final chatStore = ChatWithStore(senderId: '', receiverId: '', messages: []).obs;

  String? currentUserId;
  String? currentReceiverId;
  String? image;

  /// Set the chat details
  Future<void> setChatDetails(String senderId, String receiverId) async {
    currentUserId = senderId;
    currentReceiverId = receiverId;
    chatStore.update((chat) {
      chat?.senderId = senderId;
      chat?.receiverId = receiverId;
      chat?.messages = [];
    });
  }

  void sendMessageWithImage(String text, String base64Image) {
    if (socket != null && socket!.connected) {
      socket!.emit('sendMessage', {
        'sender_id': currentUserId,
        'receiver_id': currentReceiverId,
        'message': text,
        'image_base64': base64Image, // Send base64 image
      });
    } else {
      debugPrint('⚠️ Socket is not connected');
    }
  }

  /// Connect to Socket.IO server and register current user
  Future<void> connectSocket(Function scrollToBottomCallback) async {
    if (socket != null && socket!.connected) return; // Avoid reconnecting

    socket = IO.io(
      mainPoint,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('✅ Connected to socket server');
      if (currentUserId != null) {
        socket!.emit('registerUser', currentUserId);
      }
    });

    /// Listen for new messages
    socket!.on('newMessage', (data) {
      debugPrint('📩 New message received: $data');
      final message = ResponseModel.fromJson(data);
      chatStore.update((chat) {
        chat?.addMessage(message); // Adding the new message
      });

      // Call the scroll-to-bottom callback to ensure scrolling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // After the frame is built, call the scroll to bottom function
        scrollToBottomCallback();
      });
    });

    socket!.onDisconnect((_) {
      debugPrint('❌ Socket disconnected');
    });
  }

  /// Fetch chat history
  Future<void> getChatHistory({
    required String senderId,
    required String receiverId,
    required BuildContext context,
  }) async {
    try {
      final response = await apiRepository.fetchData(
        '$mainPoint/api/chats?senderId=$senderId&receiverId=$receiverId',
        headers: {
          'Authorization': TokenStorage.token ?? '',
          'Content-Type': 'application/json',
        },
        context: context,
      );

      final List<ResponseModel> messages = [];

      if (response.data != null) {
        final List decoded = jsonDecode(response.data!);
        messages.addAll(decoded.map((e) => ResponseModel.fromJson(e)));
      }

      // Sort messages by createdAt
      messages.sort((a, b) =>
          DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

      chatStore.update((chat) {
        chat?.messages = messages;
      });
    } catch (e) {
      debugPrint('❌ Failed to get chat history: $e');
    }
  }

  /// Send a new message via Socket.IO and save to DB
  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    if (socket != null && socket!.connected) {
      socket!.emit('sendMessage', {
        'sender_id': currentUserId,
        'receiver_id': currentReceiverId,
        'message': message,
      });
    } else {
      debugPrint('⚠️ Socket is not connected');
    }
  }

  /// Disconnect socket
  void disconnectSocket() {
    socket?.disconnect();
    socket = null;
  }
}

// ---------------- Models ---------------- //

class ResponseModel {
  final String role;
  final String senderId;
  final String receiverId;
  final String content;
  final String createdAt;
  final String? fileUrl; // Support file attachments

  ResponseModel({
    required this.senderId,
    required this.receiverId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.fileUrl,
  });

  /// Factory constructor to parse JSON from both API & Socket events
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      role: json['role'] ?? 'buyer',
      content: json['message'] ?? json['content'] ?? '',
      createdAt: json['createdAt'] ?? json['timestamp'] ?? '',
      senderId: json['sender']?['id']?.toString() ?? json['sender_id']?.toString() ?? '',
      receiverId: json['receiver']?['id']?.toString() ?? json['receiver_id']?.toString() ?? '',
      fileUrl: json['file_url'] ?? json['fileUrl'],
    );
  }

  /// Convert to JSON (useful when sending message payload)
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': content,
      'file_url': fileUrl,
      'createdAt': createdAt,
    };
  }
}

class ChatWithStore {
  String senderId;
  String receiverId;
  List<ResponseModel> messages;

  ChatWithStore({
    required this.senderId,
    required this.receiverId,
    required this.messages,
  });

  /// Add a message and sort by `createdAt`
  void addMessage(ResponseModel message) {
    messages.add(message);
    messages.sort((a, b) =>
        DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
  }
}
