import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableNetworkImage extends StatelessWidget {
  const ZoomableNetworkImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      backgroundDecoration: BoxDecoration(color: Colors.white),
      imageProvider: NetworkImage(imageUrl),
      enableRotation: true,
    );
  }
}
