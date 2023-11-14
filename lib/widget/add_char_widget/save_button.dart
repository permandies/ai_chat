import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function onTap;

  const SaveButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async => onTap(), child: const Text("Save"));
  }
}
