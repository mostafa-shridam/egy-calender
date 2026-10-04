import 'dart:async';

import 'package:flutter/material.dart';

mixin ShowOptionsMenu {
  void showOptionsMenu({
    required BuildContext context,
    required LongPressStartDetails details,
    required Future<void> Function(String?)? onValue,
    required List<PopupMenuEntry<String>> items,
  }) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: items,
      position: position,
    ).then((value) => onValue?.call(value));
  }
}
