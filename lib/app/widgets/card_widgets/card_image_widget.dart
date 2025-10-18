import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';

class CardImageWidget extends StatelessWidget {
  const CardImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
      // Rounds the top corners of the image
      child: CachedNetworkImage(
        imageUrl: getResizedImageUrl(imageUrl, 800, 800),
        height: 268,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      ),
    );
  }
}