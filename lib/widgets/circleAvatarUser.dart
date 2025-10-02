import 'dart:io';
import 'package:conexion_mas/screens/profile_screen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditableCircleAvatar extends StatefulWidget {
  final String idUser;
  final double radius;
  final Function(File)? onImageSelected; // Callback opcional

  const EditableCircleAvatar({
    Key? key,
    required this.idUser,
    this.radius = 40,
    this.onImageSelected,
  }) : super(key: key);

  @override
  State<EditableCircleAvatar> createState() => _EditableCircleAvatarState();
}

class _EditableCircleAvatarState extends State<EditableCircleAvatar> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // CircleAvatar principal
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userId: int.parse(widget.idUser),
                      )),
            );
          },
          child: CircleAvatar(
            radius: widget.radius,
            backgroundColor:
                Colors.white, // Ajusta según tu ColorsUtils.blancoColor
            backgroundImage: _getImage(),
          ),
        ),

        // Botón de edición
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: widget.radius * 0.4,
            height: widget.radius * 0.4,
            decoration: BoxDecoration(
              color: ColorsUtils
                  .principalColor, // Ajusta según tu ColorsUtils.principalColor
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: Icon(Icons.camera_alt,
                  size: widget.radius * 0.2, color: Colors.white),
              onPressed: _showImageSourceDialog,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getImage() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }
    return NetworkImage(
      "${MainUtils.urlHostAssetsImagen}/usuarios/user_${widget.idUser}.png", // Ajusta tu URL
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Elegir de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        // Llamar al callback si existe
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_imageFile!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  // Método para resetear la imagen
  void resetImage() {
    setState(() {
      _imageFile = null;
    });
  }

  // Método para obtener la imagen seleccionada
  File? get selectedImage => _imageFile;
}
