import 'package:calender/core/widgets/cached_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/help_functions.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String? createdAt;
  final String? updatedAt;
  final String id;
  final String? image;
  final Widget? trailing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color? color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.trailing,
    required this.onEdit,
    required this.onDelete,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading:
            color != null || dataIsNotEmpty(data: image)
                ? CircleAvatar(
                  backgroundColor: color,
                  backgroundImage: CachedImage(imageUrl: image ?? '').provider,
                  radius: dataIsNotEmpty(data: image) ? null : 10,
                )
                : null,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            createdAt != null
                ? SelectableText(
                  '$id\nCreated: ${formatDateTime(createdAt!, context)} | Updated: ${formatDateTime(updatedAt ?? '', context)}',
                )
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
