import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final Function(String?) onSaved;
  final TextInputType keyboardType;

  CustomTextFormField({
    required this.label,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: (value) {
        if (value!.isEmpty) {
          return "$label cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter your $label",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
