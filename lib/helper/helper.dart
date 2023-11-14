import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class Helper {
  static Future<Uint8List?> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return null;
    return result.files.single.bytes;
  }

  static Future<String?> uploadImage(String id, imageBytes) async {
    try {
      if (imageBytes == null) {
        return null;
      }

      final Reference ref = FirebaseStorage.instance.ref().child('images/$id');
      final UploadTask uploadTask = ref.putData(imageBytes!);
      final TaskSnapshot storageSnapshot =
          await uploadTask.whenComplete(() => null);
      return await storageSnapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
