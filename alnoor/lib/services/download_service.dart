import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'notification_service.dart';

class DownloadService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  DownloadService({required this.scaffoldMessengerKey});

  Future<void> downloadImage(String imageUrl, String productName) async {
    try {
      // Show initial "Downloading..." snackbar using the global key
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Downloading..."),
          duration:
              Duration(minutes: 10), // Longer duration to cover download time
        ),
      );

      // Use flutter_file_downloader to download the image
      await FileDownloader.downloadFile(
        url: imageUrl,
        name: "$productName.jpg",
        onDownloadCompleted: (path) {
          // Hide the download snackbar
          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

          // Show success notification
          NotificationService.showNotification("Download Complete",
              "$productName.jpg has been downloaded", path);
        },
        onDownloadError: (errorMessage) {
          // Show failure snackbar using the global key
          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
            content: Text("Failed to download image: $errorMessage"),
          ));
        },
      );
    } catch (e) {
      // Show failure snackbar using the global key
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text("Failed to download image"),
      ));
    }
  }
}
