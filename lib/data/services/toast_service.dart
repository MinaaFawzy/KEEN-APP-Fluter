import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';


class ToastManager {
  static void showSuccess(BuildContext context, String message, {String? title}) {
    toastification.show(
      context: context,
      borderSide: const BorderSide(width: 1.5, color: Colors.green),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      type: ToastificationType.success,
      description: Text(message),
      closeButtonShowType: CloseButtonShowType.onHover,
      primaryColor: Colors.green,
      backgroundColor: Colors.green.shade50,
      foregroundColor: Colors.black,
      autoCloseDuration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(8),
      showIcon: true,
      icon: const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green),
      showProgressBar: false,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  static void showError(BuildContext context, String message, {String? title}) {
    toastification.show(
      context: context,
      borderSide: const BorderSide(width: 1.5, color: Colors.red),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      type: ToastificationType.error,
      description: Text(message),
      closeButtonShowType: CloseButtonShowType.onHover,
      primaryColor: Colors.red,
      backgroundColor: Colors.red.shade50,
      foregroundColor: Colors.black,
      autoCloseDuration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(8),
      showIcon: true,
      icon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.red),
      showProgressBar: false,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}