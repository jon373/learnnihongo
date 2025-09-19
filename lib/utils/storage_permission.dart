import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class StoragePermission {
  /// Request storage permission with Android version checks
  static Future<bool> requestPermission() async {
    if (!Platform.isAndroid) {
      // iOS or other platforms
      final status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return status.isGranted;
    }

    // Android: check SDK version
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13+ no permission needed for file picker access
      return true;
    } else if (sdkInt >= 30) {
      // Android 11 and 12: request MANAGE_EXTERNAL_STORAGE
      var status = await Permission.manageExternalStorage.status;
      if (status.isDenied || status.isRestricted) {
        status = await Permission.manageExternalStorage.request();
      }
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return status.isGranted;
    } else {
      // Android 10 and below: request storage permission normally
      var status = await Permission.storage.status;
      if (status.isDenied || status.isRestricted) {
        status = await Permission.storage.request();
      }
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return status.isGranted;
    }
  }

  /// Check if permission is granted with Android version checks
  static Future<bool> checkPermission() async {
    if (!Platform.isAndroid) {
      return await Permission.storage.isGranted;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      return true;
    } else if (sdkInt >= 30) {
      return await Permission.manageExternalStorage.isGranted;
    } else {
      return await Permission.storage.isGranted;
    }
  }
}
