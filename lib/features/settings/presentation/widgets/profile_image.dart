import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/widgets/cached_image.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.avatar,
    this.pickImage,
    this.imageFile,
  });
  final String avatar;
  final File? imageFile;
  final VoidCallback? pickImage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).greySwatch.shade200,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).greySwatch.shade100,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child:
                imageFile != null
                    ? Image.file(imageFile!, fit: BoxFit.cover)
                    : dataIsNotEmpty(data: avatar)
                    ? CachedImage(imageUrl: avatar)
                    : Container(
                      color: Theme.of(context).greySwatch.shade100,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).greySwatch.shade400,
                      ),
                    ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
