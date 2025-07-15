import 'package:flutter/material.dart';

class SnackBarHelper {

  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({required String message}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message))
    );
  }

}