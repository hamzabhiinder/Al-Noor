import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class DownloadService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  DownloadService({required this.scaffoldMessengerKey});

  Future<void> downloadImage(String imageUrl, String productName) async {
    try {
      Directory directory = await getDownloadDirectory();
      String filePath = '${directory.path}/$productName.jpg';
      Dio dio = Dio();

      // Show initial "Downloading..." snackbar using the global key
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Downloading..."),
          duration: Duration(minutes: 10), // Longer duration to cover download time
        ),
      );

      await dio.download(imageUrl, filePath);

      // Show success snackbar using the global key
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text("Downloaded to $filePath"),
      ));
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
}
