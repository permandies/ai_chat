import 'package:flutter/material.dart';

class CostumTextField extends StatelessWidget {
  final String text;
  final GlobalKey<FormState> formKey;
  final int? maxline;
  final TextEditingController controller;
  final Widget prefixIcon;

  const CostumTextField(
      {super.key, required this.text, required this.formKey, this.maxline, required this.controller, required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          const SizedBox(height: 5),
          TextFormField(
            onChanged: (var value) {
              formKey.currentState?.validate();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan boş bırakılamaz';
              }
              if (text == "Enter First Favorite Length") {
                try {
                  int.parse(value);
                } catch (e) {
                  return "Yalnızca tam giriniz";
                }
              }
              return null;
            },
            maxLines: maxline,
            controller: controller,
            decoration: InputDecoration(
                prefixIcon: prefixIcon,
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
          ),
        ],
      ),
    );
  }
}
