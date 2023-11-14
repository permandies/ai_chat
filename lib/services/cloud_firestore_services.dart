import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  static CollectionReference users =
      FirebaseFirestore.instance.collection('ai_models');

  static Future<void> addAiModel({
    required String voiceId,
    required String category,
    required String firstFavoriteLength,
    required String firstMessage,
    required String id,
    required String name,
    required String prompt,
  }) async {
    try {
      await users.doc(id).set({
        "voiceId": voiceId,
        "category": category,
        "firstFavoriteLength": firstFavoriteLength,
        "firstMessage": firstMessage,
        "id": id,
        "name": name,
        "prompt": prompt,
      });
    } catch (e) {
      print("eror");
      print(e);
    }
  }

  static Future<void> updateData(
    String name,
    String title,
    String firstFavoriteLength,
    String category,
    String selectedGender,
    String prompt,
    String firstMessage,
    String id,
  ) async {
    await users
        .doc(id)
        .update({
          "id": id,
          'name': name,
          'title': title,
          'firstFavoriteLength': firstFavoriteLength,
          'category': category,
          'prompt': prompt,
          'firstMessage': firstMessage,
        })
        .then((value) {})
        .catchError((error) {});
  }

  static void deleteData(var id) async {
    await users.doc(id).delete();
    await FirebaseStorage.instance.ref("image/$id").delete();
  }
}
