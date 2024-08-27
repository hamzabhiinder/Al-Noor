import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  DownloadService({required this.scaffoldMessengerKey});

  Future<void> downloadImage(String imageUrl, String productName) async {
    try {
      // Request storage permission if not granted
      await _requestPermission();

      Directory directory = await getDownloadDirectory();
      String filePath = '${directory.path}/$productName.jpg';

      // Show initial "Downloading..." snackbar using the global key
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Downloading..."),
          duration: Duration(minutes: 10), // Longer duration to cover download time
        ),
      );

      final taskId = await FlutterDownloader.enqueue(
        url: imageUrl,
        savedDir: directory.path,
        fileName: "$productName.jpg",
        showNotification: true, // disable system notifications
        openFileFromNotification: true, // disable file open on notification
      );

      // Show success snackbar using the global key
      if (taskId != null) {
        scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text("Downloaded to $filePath"),
        ));
      }
    } catch (e) {
      // Show failure snackbar using the global key
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text("Failed to download image"),
      ));
    }
  }

  Future<Directory> getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    return directory!;
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }
}
