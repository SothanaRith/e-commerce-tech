import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // Request Camera Permission
  if (await Permission.camera.request().isGranted) {
    print("Camera permission granted");
  }

  // Request Location Permission
  if (await Permission.location.request().isGranted) {
    print("Location permission granted");
  }

  // Request Photos Permission
  if (await Permission.photos.request().isGranted) {
    print("Photos permission granted");
  }

}
