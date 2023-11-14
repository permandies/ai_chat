// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:ai_chat/helper/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final int photoErrorInt = 0;
  final File? selectedImage;
  Uint8List? imageBytes;
  final String? imageUrl;
  final String? documentId;
  final Function onTap;
  ImageWidget(
      {super.key,
      this.selectedImage,
      this.imageBytes,
      this.imageUrl,
      this.documentId,
      required this.onTap});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: InkWell(
        onTap: () async {
          var image = await Helper.selectImage();
          widget.onTap(image);
          widget.imageBytes = image;
          setState(() {});
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: widget.imageBytes != null
              ? ClipOval(
                  child: Image.memory(
                    widget.imageBytes!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              : const Center(
                  child: Icon(Icons.camera_alt_outlined),
                ),
        ),
      ),
    );
  }
}
