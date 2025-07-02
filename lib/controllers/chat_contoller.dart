import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  var messages = <ResponseModel>[].obs;
  var isLoading = false.obs;

  // Retrieve shared preferences
  Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  // Store tokens securely in SharedPreferences
  Future<void> storeTokens(String accessToken, String refreshToken) async {
    final prefs = await _prefs();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Retrieve stored access token from SharedPreferences
  Future<String?> getAccessToken() async {
    final prefs = await _prefs();
    return prefs.getString('access_token');
  }

  // Retrieve stored refresh token from SharedPreferences
  Future<String?> getRefreshToken() async {
    final prefs = await _prefs();
    return prefs.getString('refresh_token');
  }

  // A list to keep track of the conversation content
  List<Map<String, dynamic>> conversation = [];

  // Refresh the access token using the refresh token
  Future<String?> refreshAccessToken(String refreshToken) async {
    var url = Uri.parse('https://oauth2.googleapis.com/token');
    var response = await http.post(url, body: {
      /// add Key client_id and client_secret///
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String newAccessToken = data['access_token'];
      String newRefreshToken = data['refresh_token'] ?? refreshToken; // Use new refresh token if available
      // Optionally store the new tokens
      await storeTokens(newAccessToken, newRefreshToken);
      return newAccessToken;
    } else {
      // Handle error (invalid refresh token or other issues)
      print('Error refreshing token: ${response.body}');
      return null;
    }
  }

  // Send a message to the API and handle the conversation
  Future<void> sendMessage(String text) async {
    // Add user's message to the conversation
    String fullMessage = "$text with short answer but clearly to understand";

    conversation.add({
      "role": "user",
      "parts": [{"text": fullMessage}],
    });

    // Add user's message to the chat (Only show the user input part)
    messages.add(ResponseModel(
      candidates: [
        Candidate(
          content: Content(
            role: 'user',
            parts: [Part(text: text)], // Show original input text
          ),
          finishReason: 'STOP',
        )
      ],
      usageMetadata: UsageMetadata(
        promptTokenCount: 1,
        candidatesTokenCount: 10,
        totalTokenCount: 35,
        trafficType: 'ON_DEMAND',
        promptTokensDetails: [
          TokenDetails(modality: 'TEXT', tokenCount: 1)
        ],
        candidatesTokensDetails: [
          TokenDetails(modality: 'TEXT', tokenCount: 10)
        ],
        thoughtsTokenCount: 24,
      ),
      modelVersion: 'gemini-2.5-flash',
      createTime: DateTime.parse("2025-07-02T13:44:34.082552Z"),
      responseId: 'wjdlaPiEBezMseMPo7Oe0Qw',
    ));

    // Get the current access token
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      // If access token is missing or expired, refresh it
      String? refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        accessToken = await refreshAccessToken(refreshToken);
      }
    }

    // If we don't have a valid access token, prompt the user to log in again
    if (accessToken == null) {
      print('Please log in again.');
      return;
    }

    // Prepare the request with the valid access token
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken', // Use the valid access token
    };

    var request = http.Request(
      'POST',
      Uri.parse(
        'https://aiplatform.googleapis.com/v1/projects/swift-impulse-430315-g1/locations/global/publishers/google/models/gemini-2.5-flash:streamGenerateContent',
      ),
    );

    // Prepare the request body with the dynamic conversation
    request.body = json.encode({
      "contents": conversation,
      "generationConfig": {
        "temperature": 1,
        "maxOutputTokens": 65535,
        "topP": 1,
        "seed": 0,
        "thinkingConfig": {"thinkingBudget": -1}
      },
      "safetySettings": [
        {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "OFF"},
        {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "OFF"},
        {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "OFF"},
        {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "OFF"}
      ]
    });

    request.headers.addAll(headers);

    // Send the request and handle the response
    isLoading(true);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final data = json.decode(responseString);

        print(data);
        // Parse the response data into the dynamic model
        List<ResponseModel> responseModels = [];
        for (var item in data) {
          responseModels.add(ResponseModel.fromJson(item));
        }

        // Extract bot's messages and add them to the conversation
        for (var responseModel in responseModels) {
          for (var candidate in responseModel.candidates ?? []) {
            for (var part in candidate.content.parts) {
              // Add each part to the conversation
              conversation.add({
                "role": "model",
                "parts": [{"text": part.text}],
              });

              // Add the part to the messages list
              messages.add(ResponseModel(
                candidates: [
                  Candidate(
                    content: Content(
                      role: 'model',
                      parts: [Part(text: part.text)],
                    ),
                    finishReason: 'STOP',
                  ),
                ],
                usageMetadata: responseModel.usageMetadata,
                modelVersion: responseModel.modelVersion,
                createTime: responseModel.createTime,
                responseId: responseModel.responseId,
              ));
            }
          }
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}

class ResponseModel {
  List<Candidate>? candidates;
  UsageMetadata? usageMetadata; // Optional
  String? modelVersion;
  DateTime? createTime;
  String? responseId;

  ResponseModel({
    this.candidates,
    this.usageMetadata,
    this.modelVersion,
    this.createTime,
    this.responseId,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      candidates: (json['candidates'] as List?)
          ?.map((candidate) => Candidate.fromJson(candidate))
          .toList(),
      usageMetadata: json['usageMetadata'] != null
          ? UsageMetadata.fromJson(json['usageMetadata'])
          : null,
      modelVersion: json['modelVersion'],
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'])
          : null,
      responseId: json['responseId'],
    );
  }
}

class Candidate {
  Content? content;
  String? finishReason;

  Candidate({
    this.content,
    this.finishReason,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      finishReason: json['finishReason'],
    );
  }
}

class Content {
  String? role;
  List<Part>? parts;

  Content({
    this.role,
    this.parts,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      role: json['role'],
      parts: (json['parts'] as List?)
          ?.map((part) => Part.fromJson(part))
          .toList(),
    );
  }
}

class Part {
  String? text;

  Part({this.text});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(text: json['text']);
  }
}

class UsageMetadata {
  int? promptTokenCount;
  int? candidatesTokenCount;
  int? totalTokenCount;
  String? trafficType;
  List<TokenDetails>? promptTokensDetails;
  List<TokenDetails>? candidatesTokensDetails;
  int? thoughtsTokenCount;

  UsageMetadata({
    this.promptTokenCount,
    this.candidatesTokenCount,
    this.totalTokenCount,
    this.trafficType,
    this.promptTokensDetails,
    this.candidatesTokensDetails,
    this.thoughtsTokenCount,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) {
    return UsageMetadata(
      promptTokenCount: json['promptTokenCount'],
      candidatesTokenCount: json['candidatesTokenCount'],
      totalTokenCount: json['totalTokenCount'],
      trafficType: json['trafficType'],
      promptTokensDetails: (json['promptTokensDetails'] as List?)
          ?.map((detail) => TokenDetails.fromJson(detail))
          .toList(),
      candidatesTokensDetails: (json['candidatesTokensDetails'] as List?)
          ?.map((detail) => TokenDetails.fromJson(detail))
          .toList(),
      thoughtsTokenCount: json['thoughtsTokenCount'],
    );
  }
}

class TokenDetails {
  String? modality;
  int? tokenCount;

  TokenDetails({
    this.modality,
    this.tokenCount,
  });

  factory TokenDetails.fromJson(Map<String, dynamic> json) {
    return TokenDetails(
      modality: json['modality'],
      tokenCount: json['tokenCount'],
    );
  }
}


