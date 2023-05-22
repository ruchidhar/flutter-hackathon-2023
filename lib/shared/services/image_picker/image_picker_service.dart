import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<FileDetails> pickImage();
}

class ImagePickerServiceImpl implements ImagePickerService {
  @override
  Future<FileDetails> pickImage() async {
    final picker = ImagePicker();

    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );

    if (imageFile == null) {
      return FileDetails(Uint8List(0), '', null);
    }

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    return FileDetails(bytes, fileName, imageFile);
  }
}

class FileDetails {
  FileDetails(this.bytes, this.fileName, this.imageFile);

  Uint8List bytes;
  String fileName;
  XFile? imageFile;
}
