import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration loginDecoration({
    required String label,
    required String placeholder,
    IconData? icon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
      ),
      hintText: placeholder,
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: Colors.deepPurple,
            )
          : null,
    );
  }
}
