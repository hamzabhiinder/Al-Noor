import 'package:flutter/widgets.dart';

class ImageManager {
  static final ImageManager _instance = ImageManager._internal();

  ValueNotifier<String?> image1 = ValueNotifier<String?>(null);
  ValueNotifier<String?> image2 = ValueNotifier<String?>(null);
  ValueNotifier<String?> image3 = ValueNotifier<String?>(null);
  ValueNotifier<String?> image4 = ValueNotifier<String?>(null);
  ValueNotifier<String?> image5 = ValueNotifier<String?>(null);
  ValueNotifier<String?> image6 = ValueNotifier<String?>(null);
  ValueNotifier<String?> moodboard2Name = ValueNotifier<String?>("");
  ValueNotifier<String?> moodboard4Name = ValueNotifier<String?>("");
  ValueNotifier<String?> moodboardId = ValueNotifier<String?>("");

  factory ImageManager() {
    return _instance;
  }

  ImageManager._internal();

  void setImageFromCamera(dynamic path) {
    if (image1.value == null || image1.value!.isEmpty) {
      image1.value = path;
    } else if (image2.value == null || image2.value!.isEmpty) {
      image2.value = path;
    } else if (image3.value == null || image3.value!.isEmpty) {
      image3.value = path;
    } else if (image4.value == null || image4.value!.isEmpty) {
      image4.value = path;
    } else if (image5.value == null || image5.value!.isEmpty) {
      image5.value = path;
    } else if (image6.value == null || image6.value!.isEmpty) {
      image6.value = path;
    } else {
      image1.value = path;
    }
  }

  void setId(String id) {
    moodboardId.value = id;
  }

  void setImage(int index, dynamic path) {
    switch (index) {
      case 1:
        image1.value = path;
        break;
      case 2:
        image2.value = path;
        break;
      case 3:
        image3.value = path;
        break;
      case 4:
        image4.value = path;
        break;
      case 5:
        image5.value = path;
        break;
      case 6:
        image6.value = path;
        break;
      default:
        image1.value = path;
    }
  }

  void setName(int index, String name) {
    switch (index) {
      case 2:
        moodboard2Name.value = name;
        break;
      case 4:
        moodboard4Name.value = name;
        break;
    }
  }

  ValueNotifier<String?> getMoodboardIdNotifier() {
    return moodboardId;
  }

  ValueNotifier<String?> getImageNotifier(int index) {
    switch (index) {
      case 1:
        return image1;
      case 2:
        return image2;
      case 3:
        return image3;
      case 4:
        return image4;
      case 5:
        return image5;
      case 6:
        return image6;
      default:
        return image1;
    }
  }

  ValueNotifier<String?> getNameNotifier(int index) {
    switch (index) {
      case 2:
        return moodboard2Name;
      default:
        return moodboard4Name;
    }
  }

  String? getId() {
    return moodboardId.value;
  }

  String? getName(int index) {
    switch (index) {
      case 2:
        return moodboard2Name.value;
      default:
        return moodboard4Name.value;
    }
  }

  String? getImage(int index) {
    switch (index) {
      case 1:
        return image1.value;
      case 2:
        return image2.value;
      case 3:
        return image3.value;
      case 4:
        return image4.value;
      case 5:
        return image5.value;
      case 6:
        return image6.value;
      default:
        return null;
    }
  }
}
