import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CropImage {
  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static Future<CroppedFile?>? crop({required String filePath}) async {
    if (_context == null) {
      return null;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: false,
            activeControlsWidgetColor: Colors.blue,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: _context!,
        ),
      ],
    );

    return croppedFile;
  }
}