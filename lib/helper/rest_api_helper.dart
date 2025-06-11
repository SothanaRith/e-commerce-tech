import 'dart:convert';

import 'package:e_commerce_tech/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// Generic API Response Model
class ApiResponse {
  final String? data; // Keep response as raw JSON string
  final String? error;

  ApiResponse({this.data, this.error});
}

// API Repository with Debugging and Reusability
class ApiRepository {
  Future<ApiResponse> _handleRequest(
      Future<http.Response> Function() request,
      {String method = "", String url = "", required BuildContext context, Map<String, String>? headers, dynamic body}) async {
    try {
      // ✅ Log Request Details
      print("\n🔹 [DEBUG] HTTP Request - Method: $method, URL: $url");
      print("🔹 Headers: ${headers ?? 'No Headers'}");
      if (body != null) print("🔹 Body: $body");

      // Make HTTP request
      final response = await request();

      // ✅ Log Response
      print("🔹 [DEBUG] HTTP Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(data: response.body); // Keep JSON as string
      } else {
        return ApiResponse(error: response.body);
      }
    } catch (e) {
      print("❌ [ERROR] Exception: $e");
      return ApiResponse(error: e.toString());
    }

  }

  // Fetch (GET)
  Future<ApiResponse> fetchData(String url, {Map<String, String>? headers, required BuildContext context }) async {
    return _handleRequest(
          () => http.get(Uri.parse(url), headers: headers),
      method: "GET",
      url: url,
      headers: headers, context: context,
    );
  }

  // Post (POST)
  Future<ApiResponse> postData(String url, {Map<String, dynamic>? body, Map<String, String>? headers, required BuildContext context}) async {
    return _handleRequest(
          () => http.post(Uri.parse(url), headers: headers ?? {'Content-Type': 'application/json'}, body: json.encode(body ?? {})),
      method: "POST",
      url: url,
      headers: headers,
      body: body, context: context,
    );
  }

  // Put (PUT)
  Future<ApiResponse> putData(String url, {Map<String, dynamic>? body, Map<String, String>? headers, required BuildContext context}) async {
    return _handleRequest(
          () => http.put(Uri.parse(url), headers: headers ?? {'Content-Type': 'application/json'}, body: json.encode(body ?? {})),
      method: "PUT",
      url: url,
      headers: headers,
      body: body, context: context,
    );
  }

  // Delete (DELETE)
  Future<ApiResponse> deleteData(String url, {Map<String, String>? headers, required BuildContext context}) async {
    return _handleRequest(
          () => http.delete(Uri.parse(url), headers: headers),
      method: "DELETE",
      url: url,
      headers: headers, context: context,
    );
  }
}
