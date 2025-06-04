import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // Request Camera Permission
  if (await Permission.camera.request().isGranted) {
    print("Camera permission granted");
  } else {
    print("Camera permission denied");
  }

  // Request Location Permission (Foreground)
  if (await Permission.location.request().isGranted) {
    print("Location permission granted (foreground)");

    // Request Background Location Permission (if required)
    if (await Permission.locationAlways.request().isGranted) {
      print("Background location permission granted");
    } else {
      print("Background location permission denied");
    }
  } else {
    print("Location permission denied (foreground)");
  }

  // Request Photos Permission
  if (await Permission.photos.request().isGranted) {
    print("Photos permission granted");
  } else {
    print("Photos permission denied");
  }
}
