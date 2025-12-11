import 'dart:io';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File? selectedImage;

  const ImageDisplay({super.key, this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: selectedImage != null
          ? Image.file(selectedImage!, height: 200)
          : Image.asset('assets/images/icon_image.png', height: 200),
    );
  }
}
