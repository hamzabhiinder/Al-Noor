class ImageManager {
  static final ImageManager _instance = ImageManager._internal();

  var _image1;
  var _image2;
  var _image3;
  var _image4;
  var _image5;
  var _image6;

  factory ImageManager() {
    return _instance;
  }

  ImageManager._internal();

  void setImageFromCamera(dynamic path) {
    if (_image1 == null || _image1!.isEmpty) {
      _image1 = path;
    } else if (_image2 == null || _image2!.isEmpty) {
      _image2 = path;
    } else if (_image3 == null || _image3!.isEmpty) {
      _image3 = path;
    } else if (_image4 == null || _image4!.isEmpty) {
      _image4 = path;
    } else if (_image5 == null || _image5!.isEmpty) {
      _image5 = path;
    } else if (_image6 == null || _image6!.isEmpty) {
      _image6 = path;
    } else {
      _image1 = path;
    }
  }

  void setImage(int index, dynamic path) {
    switch (index) {
      case 1:
        _image1 = path;
        break;
      case 2:
        _image2 = path;
        break;
      case 3:
        _image3 = path;
        break;
      case 4:
        _image4 = path;
        break;
      case 5:
        _image5 = path;
        break;
      case 6:
        _image6 = path;
        break;
      default:
        _image1 = path;
    }
  }

  String? getImage(int index) {
    switch (index) {
      case 1:
        return _image1;
      case 2:
        return _image2;
      case 3:
        return _image3;
      case 4:
        return _image4;
      case 5:
        return _image5;
      case 6:
        return _image6;
      default:
        return null;
    }
  }
}
