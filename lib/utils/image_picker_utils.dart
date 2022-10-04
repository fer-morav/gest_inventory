import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  final picker;
  XFile? _image;
  List<File>? _images;

  ImagePickerUtils({required this.picker});

  Future<File?> pickImageFromGallery() async {
    _image = await picker.pickImage(source: ImageSource.gallery);
    return File(_image!.path);
  }

  Future<File?> pickImageFromCamera() async {
    _image = await picker.pickImage(source: ImageSource.camera);
    return _image == null ? null : File(_image!.path);
  }

  Future<File?> pickVideoFromGallery() async {
    _image = await picker.pickVideo(source: ImageSource.gallery);
    return _image == null ? null : File(_image!.path);
  }

  Future<File?> pickVideoFromCamera() async {
    _image = await picker.pickVideo(source: ImageSource.camera);
    return File(_image!.path);
  }

  Future<List<File>?> pickListImageFromCamera() async {
    final images = await picker.pickMultiImage();
    images?.forEach((element) {
      _images?.add(File(element.path));
    });
    return _images;
  }

  Future<void> getLostData() async {
    if (Platform.isAndroid) {
      final response = await picker.retrieveLostData();

      if (response.isEmpty || response.file == null) {
        return;
      }
      _image = response.file;
    }
  }
}
