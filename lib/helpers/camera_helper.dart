import 'package:image_picker/image_picker.dart';

class CameraHelper {
  static Future<PickedFile> getImage({ImageSource imageSource}) async {
    var image = await ImagePicker().getImage(source: imageSource);

    if (image == null) return null;

    return image;
  }
}
