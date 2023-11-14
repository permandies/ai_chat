// ignore_for_file: library_private_types_in_public_api

import 'package:ai_chat/model/ai_model.dart';
import 'package:ai_chat/services/cloud_firestore_services.dart';
import 'package:ai_chat/view/edit_char_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';

class CharListPage extends StatefulWidget {
  const CharListPage({super.key});

  @override
  _CharListPageState createState() => _CharListPageState();
}

class _CharListPageState extends State<CharListPage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('ai_models').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Text('Something went wrong');
          }
          List<AiModel> data = [];
          for (var element in snapshot.data!.docs) {
            try {
              data.add(AiModel.formJson(element.data() as Map));
            } catch (e) {}
          }
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (c, i) {
                print(i);

                final ref = FirebaseStorage.instance
                    .ref()
                    .child('images/${data[i].id}');

                return FutureBuilder<String>(
                  future: ref.getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      String imageUrl = snapshot.data!;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade200),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageNetwork(
                                  image: imageUrl,
                                  height: 50,
                                  width: 50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[i].name),
                                  Text(data[i].category),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => EditAiModel(
                                          aiModel: data[i],
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )),
                              const SizedBox(width: 10),
                              IconButton(
                                  onPressed: () {
                                    FirebaseServices.deleteData(data[i].id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Beklenmeyen bir durum için bir hata mesajı gösterebilirsiniz.
                      return const Text('Beklenmeyen bir durum oluştu.');
                    }
                  },
                );
              });
        },
      ),
    );
  }
}
