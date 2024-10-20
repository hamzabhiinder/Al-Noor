import 'dart:convert';
import 'dart:io';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/models/moodboard.dart';
import 'package:http/http.dart' as http;
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class MoodboardsRepository {
  Future<List<Moodboard>> fetchMoodboards(search) async {
    var response;

    response = await http.get(
      Uri.parse('https://alnoormdf.com/alnoor/get-moodboard'),
      headers: {
        'Authorization': 'Bearer ${globals.token}',
      },
    ).timeout(Duration(seconds: 60));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<Moodboard> moodboards = (data["moodboards"] as List)
            .map((moodboard) => Moodboard.fromJson(moodboard))
            .toList();

        return moodboards;
      } catch (error) {
        print('Error: $error');
      }
      return [];
    } else {
      throw Exception('Failed to load moodboards');
    }
  }

  Future<void> addMoodboard(
    String? moodboardId,
    String name,
    File? image1,
    File? image2,
    File? image3,
    File? image4,
  ) async {
    var isNew = moodboardId == "" || moodboardId == null;
    final url = isNew
        ? Uri.parse('https://alnoormdf.com/alnoor/create-moodboard')
        : Uri.parse(
            'https://alnoormdf.com/alnoor/update-moodboard/${moodboardId}');
    final request = http.MultipartRequest('POST', url)..fields['name'] = name;

    // Function to add file if not null
    Future<void> addFileIfNotNull(File? image, String fieldName) async {
      if (image != null) {
        final mimeTypeData =
            lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
        if (mimeTypeData != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName,
              image.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
            ),
          );
        }
      }
    }

    // Add each image if not null
    await addFileIfNotNull(image1, 'image1');
    await addFileIfNotNull(image2, 'image2');
    await addFileIfNotNull(image3, 'image3');
    await addFileIfNotNull(image4, 'image4');

    // Add headers
    request.headers['Authorization'] = 'Bearer ${globals.token}';

    try {
      final response = await request.send();

      // Convert the streamed response to a readable response
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        final message = jsonResponse['message'];
        final moodboardId = jsonResponse['moodboard_id'];

        print('Moodboard added successfully');
        print('Message: $message');
        print('Moodboard ID: $moodboardId');
        if (isNew) {
          if (globals.openedTab == 2) {
            ImageManager().setId(2, moodboardId.toString());
          } else {
            ImageManager().setId(4, moodboardId.toString());
          }
        }
      } else {
        print('Moodboard update failed with status: ${response.statusCode}');
        print('Error Body: $responseBody');
      }
    } catch (e) {
      print('Failed to add to moodboards: $e');
    }
  }

  Future<void> updateMoodboard(String name, File image1, File image2,
      File image3, File image4, String id) async {
    var response = await http.post(
      Uri.parse('https://alnoormdf.com/alnoor/update-moodboard/${id}'),
      headers: {
        'Authorization': 'Bearer ${globals.token}',
      },
      body: {
        'name': name,
        'image1': image1,
        'image2': image2,
        'image3': image3,
        'image4': image4,
      },
    ).timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to update moodboard');
    }
  }

  Future<void> deleteMoodboard(String id) async {
    var response = await http.post(
      Uri.parse('https://alnoormdf.com/alnoor/delete-moodboard/${id}'),
      headers: {
        'Authorization': 'Bearer ${globals.token}',
      },
    ).timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete moodboard');
    }
  }
}
