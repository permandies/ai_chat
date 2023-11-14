import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTile extends StatelessWidget {
  final Function onTap;
  final String title;
  const HomeTile({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.all(12),
          height: Get.height / 12,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromARGB(255, 248, 214, 253)),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
