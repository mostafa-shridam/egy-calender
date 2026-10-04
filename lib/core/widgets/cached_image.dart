import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.imageUrl,
    this.icon,
    this.fit = BoxFit.cover,
  });
  final String imageUrl;
  final IconData? icon;
  final BoxFit fit;
  ImageProvider get provider => CachedNetworkImageProvider(imageUrl);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder:
          (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget:
          (context, url, error) => Icon(icon ?? Icons.hide_image, size: 60),
    );
  }
}
