import 'dart:io';
import 'package:flutter/material.dart';

class PlantaImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onTap;

  const PlantaImagePickerWidget({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(imageFile!),
                    fit: BoxFit.cover,
                  )
                : imageUrl != null && File(imageUrl!).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(imageUrl!)),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
          child: imageFile == null &&
                  (imageUrl == null || !File(imageUrl!).existsSync())
              ? const Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.grey,
                )
              : null,
        ),
      ),
    );
  }
}
