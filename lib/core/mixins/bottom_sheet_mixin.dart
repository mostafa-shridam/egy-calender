import 'package:flutter/material.dart';

mixin BottomSheetMixin {
  void showCustomBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: child,
        );
      },
    );
  }
}
