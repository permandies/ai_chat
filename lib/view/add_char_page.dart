// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:ai_chat/services/cloud_firestore_services.dart';
import 'package:ai_chat/view/home_page.dart';
import 'package:ai_chat/widget/add_char_widget/costum_text_field.dart';
import 'package:ai_chat/widget/add_char_widget/image_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCharPage extends StatefulWidget {
  const AddCharPage({Key? key}) : super(key: key);

  @override
  State<AddCharPage> createState() => _AddCharPageState();
}

class _AddCharPageState extends State<AddCharPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController firstFavoriteLengthController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController promptController = TextEditingController();
  TextEditingController firstMessageController = TextEditingController();
  String selectedGender = "Male";
  int photoErrorInt = 0;
  bool isPhotoSelected = false;
  File? selectedImage;
  Uint8List? imageBytes;
  String? imageUrl;
  String? documentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Add New Character",
            style: TextStyle(color: Colors.black),
          )),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(
                  flex: 5,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 19,
                      ),
                      ImageWidget(onTap: () async => await selectImage()),
                      const SizedBox(height: 5),
                      photoErrorInt == -1
                          ? const Text(
                              "Fotoğraf seçilmedi",
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 5),
                      CostumTextField(
                        formKey: _formKey,
                        text: "Name",
                        controller: nameController,
                        maxline: 1,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      CostumTextField(
                        formKey: _formKey,
                        text: "Title",
                        controller: titleController,
                        maxline: 2,
                        prefixIcon: const Icon(Icons.text_fields_outlined),
                      ),
                      CostumTextField(
                        formKey: _formKey,
                        text: "Enter First Favorite Length",
                        controller: firstFavoriteLengthController,
                        maxline: 1,
                        prefixIcon: const Icon(Icons.favorite_border_outlined),
                      ),
                      CostumTextField(
                        formKey: _formKey,
                        text: "Enter Category",
                        controller: categoryController,
                        maxline: 1,
                        prefixIcon: const Icon(Icons.category_rounded),
                      ),
                      CostumTextField(
                        formKey: _formKey,
                        text: "Enter Prompt",
                        controller: promptController,
                        maxline: 5,
                        prefixIcon: const Icon(Icons.text_fields_outlined),
                      ),
                      CostumTextField(
                        formKey: _formKey,
                        text: "Enter First Message",
                        controller: firstMessageController,
                        maxline: 5,
                        prefixIcon: const Icon(Icons.text_fields_outlined),
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                          onPressed: () async {
                            if (isPhotoSelected == false) {
                              photoErrorInt = -1;
                              setState(() {});
                            } else {
                              photoErrorInt = 1;
                              setState(() {});
                            }

                            if (_formKey.currentState!.validate() &&
                                photoErrorInt == 1) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Yükleniyor...'),
                                      ],
                                    ),
                                  );
                                },
                              );
                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('ai_models');
                              String documentId = users.doc().id;

                              try {
                                await FirebaseServices.addAiModel(
                                    voiceId: "voiceId",
                                    category: categoryController.text,
                                    firstFavoriteLength:
                                        firstFavoriteLengthController.text,
                                    firstMessage: firstMessageController.text,
                                    id: documentId,
                                    name: nameController.text,
                                    prompt: promptController.text);
                              } catch (e) {}
                              await uploadImage(documentId);

                              Get.back();
                              Get.offAll(() => HomePage());
                              Get.snackbar("Başarılı", "Yeni Karakter Eklendi",
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          },
                          child: const Text("Save")),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    final file = result.files.single;
    setState(() {
      imageBytes = file.bytes;
      isPhotoSelected = true;
      photoErrorInt = 1;
    });
  }

  Future<void> uploadImage(String id) async {
    try {
      if (imageBytes == null) {
        return;
      }

      final Reference ref = FirebaseStorage.instance.ref().child('images/$id');
      final UploadTask uploadTask = ref.putData(imageBytes!);
      final TaskSnapshot storageSnapshot =
          await uploadTask.whenComplete(() => null);
      imageUrl = await storageSnapshot.ref.getDownloadURL();
      setState(() {});
    } catch (e) {
      print("hata");
      print(e);
    }
  }
}
