import 'package:flutter/material.dart';

mixin AppDialog {
  void showAppDialog({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    showDialog(context: context, builder: (context) => child);
  }
}
