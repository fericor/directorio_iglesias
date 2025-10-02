import 'dart:io';

import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatefulWidget {
  final String? imageUrl;
  final ValueChanged<File?> onImageChanged;
  final String? labelText;

  const ImageUploadField({
    Key? key,
    this.imageUrl,
    required this.onImageChanged,
    this.labelText = 'Imagen de portada',
  }) : super(key: key);

  @override
  _ImageUploadFieldState createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    final option = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (option != null) {
      try {
        final XFile? image = await _picker.pickImage(
          source: option,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _selectedImage = File(image.path);
          });
          widget.onImageChanged(_selectedImage);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.labelText!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ColorsUtils.principalColor,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectImage,
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorsUtils.principalColor,
              ),
              borderRadius: BorderRadius.circular(10),
              color: ColorsUtils.blancoColor,
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : widget.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            Image.network(widget.imageUrl!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Subir imagen',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
          ),
        ),
        if (_selectedImage != null || widget.imageUrl != null)
          TextButton(
            onPressed: _removeImage,
            child: const Text('Quitar imagen'),
          ),
      ],
    );
  }
}
