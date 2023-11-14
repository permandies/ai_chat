// ignore_for_file: use_build_context_synchronously

import 'package:ai_chat/helper/helper.dart';
import 'package:ai_chat/services/cloud_firestore_services.dart';
import 'package:ai_chat/widget/add_char_widget/costum_text_field.dart';
import 'package:ai_chat/widget/add_char_widget/image_widget.dart';
import 'package:ai_chat/widget/add_char_widget/save_button.dart';
import 'package:ai_chat/widget/common/costum_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class AddCharPage extends StatefulWidget {
  const AddCharPage({Key? key}) : super(key: key);

  @override
  State<AddCharPage> createState() => _AddCharPageState();
}

class _AddCharPageState extends State<AddCharPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController firstFavoriteLengthController;
  late TextEditingController categoryController;
  late TextEditingController promptController;
  late TextEditingController firstMessageController;

  int photoErrorInt = 0;
  Uint8List? imageBytes;
  String? imageUrl;

  @override
  void initState() {
    nameController = TextEditingController();
    firstFavoriteLengthController = TextEditingController();
    categoryController = TextEditingController();
    promptController = TextEditingController();
    firstMessageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    firstFavoriteLengthController.dispose();
    categoryController.dispose();
    promptController.dispose();
    firstMessageController.dispose();
    super.dispose();
  }

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
                const Spacer(),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 19,
                      ),
                      ImageWidget(onTap: (image) => imageBytes = image),
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
                      SaveButton(onTap: () async => await save()),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  save() async {
    print("saveee");
    if (imageBytes == null) {
      photoErrorInt = -1;
      setState(() {});
    } else {
      photoErrorInt = 1;
      setState(() {});
    }
    if (_formKey.currentState!.validate() && photoErrorInt == 1) {
      Get.dialog(const CostumDialog());

      final documentId =
          FirebaseFirestore.instance.collection('ai_models').doc().id;

      try {
        await FirebaseServices.addAiModel(
            voiceId: "voiceId",
            category: categoryController.text,
            firstFavoriteLength: firstFavoriteLengthController.text,
            firstMessage: firstMessageController.text,
            id: documentId,
            name: nameController.text,
            prompt: promptController.text);
      } catch (e) {}
      await Helper.uploadImage(documentId, imageBytes);

      Get.back();
      Get.offAll(() => HomePage());
      Get.snackbar("Başarılı", "Yeni Karakter Eklendi",
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
