// import 'dart:io';
// import 'dart:typed_data';
// import 'package:business_card/services/image_gallery_saver.dart';
// import 'package:business_card/utils/crop.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
//
// Widget buildActionSheetAction(
//     String text, Color color, VoidCallback onPressed) {
//   return CupertinoActionSheetAction(
//     onPressed: onPressed,
//     child: Text(
//       text,
//       style: TextStyle(color: color),
//     ),
//   );
// }
//
// Future<bool> requestPermission(Permission permission) async {
//   var status = await permission.status;
//   if (status.isDenied ||
//       status.isRestricted ||
//       status.isLimited ||
//       status.isPermanentlyDenied) {
//     var result = await permission.request();
//     if (result.isLimited) {
//       // If the user has granted limited access, treat it as granted for now
//       return true;
//     } else if (result.isPermanentlyDenied) {
//       openAppSettings();
//       return false;
//     }
//     return result.isGranted;
//   }
//   return status.isGranted;
// }
//
// Future<File?> cropGallery(BuildContext context) async {
//   CropImage.init(context);
//   try {
//     final pickedFile = await ImagePicker()
//         .pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//
//     CroppedFile? croppedFile;
//     croppedFile = await CropImage.crop(filePath: pickedFile!.path);
//     if (croppedFile == null) {
//       return null;
//     } else {
//       return File(pickedFile.path);
//     }
//   } catch (e) {
//     print("error $e");
//     if (e is PlatformException && e.code == 'photo_access_denied') {
//       bool permissionGranted = false;
//       if (Platform.isIOS) {
//         permissionGranted = await requestPermission(Permission.photos);
//       } else if (Platform.isAndroid) {
//         permissionGranted = await requestPermission(Permission.storage);
//       }
//       if (!permissionGranted) {
//         return null;
//       }
//     }
//   }
//   return null;
// }
//
// Future<File?> cropCamera(BuildContext context) async {
//   // Request camera permission before proceeding
//   try {
//     CropImage.init(context);
//     final pickedFile = await ImagePicker()
//         .pickImage(source: ImageSource.camera, imageQuality: 80);
//     if (pickedFile == null) {
//       return File(pickedFile!.path);
//     }
//     CroppedFile? croppedFile;
//     croppedFile = await CropImage.crop(filePath: pickedFile.path);
//     if (croppedFile == null) {
//       return null;
//     } else {
//       return File(croppedFile.path);
//     }
//   } catch (e) {
//     print("error $e");
//     if (e is PlatformException && e.code == 'camera_access_denied') {
//       await requestPermission(Permission.camera);
//       bool isPermissionGranted = await requestPermission(Permission.camera);
//       if (!isPermissionGranted) {
//         print("Camera permission denied. Requesting permission...");
//         return null; // Exit if permission is denied
//       }
//     }
//   }
//
//   return null;
// }
//
// Future<void> shareImage(Uint8List imageData) async {
//   final tempDir = await getTemporaryDirectory();
//   final tempFile = File('${tempDir.path}/image.jpg');
//   await tempFile.writeAsBytes(imageData);
//   Share.shareXFiles([XFile(tempFile.path)], text: 'Check out this image!');
//   await tempFile.delete();
// }
// //
// // Future<dynamic> savePhoto() async {
// //   isSave = true;
// //   update();
// //   try{
// //     if(imageBytes != null){
// //       final result = await ImageGallerySaver.saveImage(
// //           imageBytes!,
// //           quality: 100,
// //           name: "${DateTime.now().millisecondsSinceEpoch}");
// //       if(result['isSuccess']){
// //         // saveComplete = true;
// //         // update();
// //       } else {
// //         // saveComplete = false;
// //         // update();
// //       }
// //     }else{
// //       // emptyImage = true;
// //       // update();
// //     }
// //   }catch(e){
// //     // print("save : $e");
// //   }finally{
// //     // isSave = false;
// //     // update();
// //   }
// // }
