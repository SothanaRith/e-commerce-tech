import 'dart:convert';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final ApiRepository apiRepository;

  late final String mainPoint = "https://4136-58-97-228-77.ngrok-free.app";
  AuthController() {
    apiRepository = ApiRepository();
  }

  Future<void> getUser() async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/users/getProfile',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzQyNzEzNDM4LCJleHAiOjE3NDMzMTgyMzh9.fsgucNyx_FVMXmfdBefq2KlRJYbifFydYFe-SCiMohI',
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> signup({required String name,required String email, required String password, required String phone, required String role}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/register',
      body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "role": role
      },
      headers: {
        'Content-Type': 'application/json'
      },

    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/login',
      body: {
        "email": email,
        "password": password
      },
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> verifyOTP({required String email, required String otp}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/verify-otp',
      body: {
        "email": email,
        "otp": otp
      },
      headers: {
        'Authorization': '••••••',
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> sendOTP({required String email}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/send-otp',
      body: {
        "email": email
      },
      headers: {
        'Authorization': '••••••',
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> resentPassword({required String email, required String newPassword}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/reset-password',
      body: {
        "email": email,
        "newPassword": newPassword
      },
      headers: {
        'Authorization': '••••••',
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }
}