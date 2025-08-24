import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:e_commerce_tech/screen/forget_password_page/reset_password_screen.dart';
import 'package:e_commerce_tech/screen/location_page/location_screen.dart';
import 'package:e_commerce_tech/screen/login_page/login_screen.dart';
import 'package:e_commerce_tech/screen/nav_bar_screen.dart';
import 'package:e_commerce_tech/screen/splash_screen.dart';
import 'package:e_commerce_tech/screen/verify_code_page/verify_code_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  late final ApiRepository apiRepository;
  bool isLoading = false;
  String? userProfile;
  // late final String mainPoint = "http://192.168.1.6:6000";
  AuthController() {
    apiRepository = ApiRepository();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  var googleUser = Rxn<GoogleSignInAccount>();

  @override
  void onInit() {
    super.onInit();
    _initializeGoogle();
  }

  Future<void> _initializeGoogle() async {
    await _googleSignIn.initialize(
      clientId: 'YOUR_WEB_OR_ANDROID_CLIENT_ID',
      serverClientId: 'YOUR_SERVER_CLIENT_ID', // optional
    );

    _googleSignIn.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        googleUser.value = event.user;
      } else {
        googleUser.value = null;
      }
    });
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      isLoading = true;
      update();

      final GoogleSignIn signIn = GoogleSignIn.instance;

      // Initialize with your client IDs
      await signIn.initialize(
        clientId: "332120979364-rfeudib1se50316hvbbdr69pjpc15eoq.apps.googleusercontent.com",
        serverClientId: "332120979364-i0lkptmcep7ct6q0nncchks9l0k1praa.apps.googleusercontent.com",
      );

      // Listen for authentication events
      final completer = Completer<GoogleSignInAccount?>();

      final sub = signIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn && !completer.isCompleted) {

          completer.complete(event.user);
        }
      });


      // Attempt silent sign-in, otherwise start interactive sign-in
      await signIn.attemptLightweightAuthentication();
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        await GoogleSignIn.instance.authenticate();
      }

      final GoogleSignInAccount? account = await completer.future;
      await sub.cancel();

      if (account == null) {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Google sign-in failed or canceled",
        );
        return;
      }

      // Get ID token from Google account
      final authHeaders = await account.authorizationClient
          .authorizationHeaders(['email', 'profile']);

      if (authHeaders == null) {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Failed to get Google auth headers",
        );
        return;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      // Send token to your backend for login
      final res = await http.post(
        Uri.parse('$mainPoint/api/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}), // ✅ matches backend
      );

      final jsonData = jsonDecode(res.body);
      if (res.statusCode == 200 && jsonData["success"] == true) {
        await TokenStorage.saveRefreshToken(jsonData["refreshToken"]);
        await TokenStorage.saveToken(jsonData["accessToken"]).then((value) async {
          await getUser(context: context);
          await UserStorage.loadUser();
        },);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await TokenStorage.loadToken();
        showCustomDialog(
            context: context,
            type: CustomDialogType.success,
            title: "${jsonData["message"]}",
            desc: UserStorage.currentUser?.name,
            okOnPress: () {
              jsonData["status"] == "register" ?
              goOff(this, ResetPasswordScreen(isFromRegister: true,)) : goOff(this, MainScreen());
            });

      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Google login failed",
        );
      }
    } catch (e) {
      print("Google sign-in error: $e");
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Google sign-in error: ${e.toString()}",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.disconnect();
    googleUser.value = null;
  }
  Future<bool> getUser({required BuildContext context}) async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/users/getProfile',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      },
      context: context,
    );

    if (response.data != null) {
      try {
        var jsonData = jsonDecode(response.data!);
        debugPrint("Fetched Data: $jsonData");

        if (jsonData["success"] == true && jsonData["filteredUser"] != null) {
          User fetchedUser = User.fromJson(jsonData["filteredUser"]);
          await UserStorage.saveUser(fetchedUser);
          debugPrint("User saved to storage: ${fetchedUser.name}");
          return true;
        } else {
          showCustomDialog(
            context: context,
            type: CustomDialogType.error,
            title: "Failed to fetch user: ${jsonData["message"] ?? "Unknown error"}",
          );
          return false;
        }
      } catch (e) {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Invalid user response: ${e.toString()}",
        );
      return false;
      }
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
      return false;
    }
  }

  Future<void> updateUser(
      {required String name,
        required String phone,
        required BuildContext context}) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/users/updateProfile/${UserStorage.currentUser?.id}',
        body: {
          "name": name,
          "phone": phone,
        },
        headers: {
          'Authorization': TokenStorage.token ?? "",
          'Content-Type': 'application/json'
        }, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
            (value) {
          showCustomDialog(
              context: context,
              type: CustomDialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () async {
                await getUser(context: context);
                await UserStorage.loadUser();
                goOff(
                  this,
                  MainScreen(currentPageIndex: 3),
                );
              });
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> updateUserProfilePicture(BuildContext context, XFile? imageFile) async {

    isLoading = true;
    update();
    // Create request URL
    String url = '$mainPoint/api/users/updateProfilePicture/${UserStorage.currentUser?.id}'; // Replace with your API URL

    // Prepare the file for upload if selected
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add Authorization header with token
    String? token = TokenStorage.token; // Assuming token is stored in TokenStorage
    if (token != null) {
      request.headers.addAll({
        'Authorization': 'Bearer $token', // Adding Bearer token in the Authorization header
      });
    }

    if (imageFile != null) {
      // Send only the first image path as a single string
      String imagePath = imageFile.path;  // Ensure it's a string
      request.files.add(await http.MultipartFile.fromPath(
        'profilePicture', // This should match the server-side field name
        imagePath,
      ));
    }

    try {
      // Send the request and get the response
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(responseData.body);
        TokenStorage.saveToken(jsonData["accessToken"]).then(
              (value) {
            showCustomDialog(
              context: context,
              type: CustomDialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () async {
                await getUser(context: context);
                await UserStorage.loadUser();
                userProfile = UserStorage.currentUser?.coverImage;
                update();
                popBack(this);
              },
            );
          },
        );
      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Something went wrong",
        );
      }
    } catch (e) {
      print('Exception: $e');
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: 'Error: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> signup(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required String role,
      required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/register',
      body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "role": role
      },
      headers: {'Content-Type': 'application/json'}, context: context
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          showCustomDialog(
              context: context,
              type: CustomDialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () {
                goOff(
                    this,
                    OtpScreen(
                      type: ScreenVerifyType.signup,
                    ));
              });
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/login?type=mobile',
      body: {"email": email, "password": password},
      headers: {'Content-Type': 'application/json'}, context: context
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) async {
          await getUser(context: context);
          await UserStorage.loadUser();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await TokenStorage.loadToken();
          showCustomDialog(
              context: context,
              type: CustomDialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () {
                goOff(this, MainScreen());
              });
        },
      );
    } else {
      var jsonData = jsonDecode(response.error!);
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "${jsonData["message"]}");
    }
  }

  Future<void> checkMail(
      {required String email, required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/check-mail',
      body: {"email": email},
      headers: {'Content-Type': 'application/json'}, context: context
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print(jsonData["accessToken"]);
      if (jsonData["accessToken"] == "") {

      }
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          showCustomDialog(
              context: context,
              type: CustomDialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () {
                goOff(
                    this,
                    OtpScreen(
                      type: ScreenVerifyType.forgetPassword,
                    ));
              });
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> refreshToken({
    required String refreshToken,
    required String email,
    required BuildContext context,
  }) async {
    isLoading = true;
    update();

    final response = await apiRepository.postData(
      '$mainPoint/api/auth/refresh-token',
      body: {
        "email": email,
        "refreshToken": refreshToken, // correctly send both fields
      },
      headers: {
        'Content-Type': 'application/json',
      },
      context: context,
    );

    isLoading = false;
    update();

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      await TokenStorage.saveRefreshToken(jsonData["refreshToken"]);
      if (jsonData["accessToken"] != null && jsonData["accessToken"] != "") {
        await TokenStorage.saveToken(jsonData["accessToken"]);
        showCustomDialog(
          context: context,
          type: CustomDialogType.success,
          title: "Token refreshed successfully",
          okOnPress: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            goOff(this, SplashScreen());
          },
        );
      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.info,
          title: "Invalid refresh response: accessToken missing",
          okOnPress: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);
            UserStorage.clearUser();
            goOff(this, SplashScreen());
          }
        );
      }
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Refresh token failed: ${response.error}",
      );
    }
  }

  Future<void> verifyOTP(
      {required String otp,
      required ScreenVerifyType type,
      required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/verify-otp',
      body: {"otp": otp},
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      await TokenStorage.saveRefreshToken(jsonData["refreshToken"]);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) async {
          await getUser(context: context);
          await UserStorage.loadUser();
          if (type == ScreenVerifyType.signup) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await TokenStorage.loadToken();
            showCustomDialog(
                context: context,
                type: CustomDialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, MainScreen());
                });
          } else if (type == ScreenVerifyType.signinPhoneNumber) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await TokenStorage.loadToken();
            showCustomDialog(
                context: context,
                type: CustomDialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, MainScreen());
                });
          } else if (type == ScreenVerifyType.forgetPassword) {
            showCustomDialog(
                context: context,
                type: CustomDialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, ResetPasswordScreen());
                });
          }
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> sendOTP({required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/send-otp',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
      TokenStorage.saveToken(jsonData["accessToken"]);
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> resetPassword(
      {required String newPassword,
      required bool isFromRegister,
      required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/reset-password',
      body: {"newPassword": newPassword},
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context
    );
    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: CustomDialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () {
            isFromRegister ?
            goOff(this, MainScreen())
            :
            goOff(this, LoginScreen());
          });
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> logout(
      {required BuildContext context}) async {
    UserStorage.clearUser();
    TokenStorage.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    showCustomDialog(
        context: context,
        type: CustomDialogType.success,
        title: "logout successfully",
        okOnPress: () {
          goOff(this, LoginScreen());
        });
  }
}
