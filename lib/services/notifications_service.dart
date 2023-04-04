import 'package:flutter/material.dart';
import 'package:products_app/theme/theme.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: AppTheme.primary,
      showCloseIcon: true,
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
