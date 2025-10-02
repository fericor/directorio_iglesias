import 'dart:io';

import 'package:conexion_mas/controllers/MisIglesiaService.dart';
import 'package:conexion_mas/helper/snackbar.dart';
import 'package:conexion_mas/models/MisIglesiaImagen.dart';
import 'package:conexion_mas/utils/colorsUtils.dart';
import 'package:conexion_mas/utils/mainUtils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GaleriaImagenesField extends StatefulWidget {
  final List<IglesiaImagen>? imagenes;
  final ValueChanged<List<File>> onImagenesChanged;
  final String iglesiaId;
  final String token;

  const GaleriaImagenesField({
    Key? key,
    this.imagenes,
    required this.onImagenesChanged,
    required this.iglesiaId,
    required this.token,
  }) : super(key: key);

  @override
  _GaleriaImagenesFieldState createState() => _GaleriaImagenesFieldState();
}

class _GaleriaImagenesFieldState extends State<GaleriaImagenesField> {
  final List<File> _nuevasImagenes = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagenes() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (images != null) {
      setState(() {
        _nuevasImagenes.addAll(images.map((xfile) => File(xfile.path)));
      });
      widget.onImagenesChanged(_nuevasImagenes);
    }
  }

  void _eliminarImagen(int index) {
    setState(() {
      _nuevasImagenes.removeAt(index);
    });
    widget.onImagenesChanged(_nuevasImagenes);
  }

  Future<void> _eliminarImagenExistente(
      String idIglesia, String imagenId) async {
    try {
      // Llamar al servicio para eliminar la imagen
      await MisIglesiaService(baseUrl: MainUtils.urlHostApi)
          .eliminarImagenGaleria(idIglesia, imagenId, widget.token);

      AppSnackbar.show(
        context,
        message: 'Imagen eliminada con exito.',
        type: SnackbarType.success,
      );

      // Recargar la galería
      setState(() {});
    } catch (e) {
      AppSnackbar.show(
        context,
        message: 'Error al eliminar imagen: $e',
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity - 100,
      decoration: BoxDecoration(
        color: ColorsUtils.terceroColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsUtils.principalColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Galería de imágenes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsUtils.principalColor,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsUtils.principalColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _seleccionarImagenes,
              child: Text(
                'Agregar imágenes a la galería',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorsUtils.blancoColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nuevas imágenes seleccionadas
            if (_nuevasImagenes.isNotEmpty) ...[
              Text(
                'Nuevas imágenes (${_nuevasImagenes.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _nuevasImagenes.asMap().entries.map((entry) {
                  return _ImagenGaleriaItem(
                    imageFile: entry.value,
                    onDelete: () => _eliminarImagen(entry.key),
                    isNew: true,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Imágenes existentes
            if (widget.imagenes != null && widget.imagenes!.isNotEmpty) ...[
              Text(
                'Imágenes existentes (${widget.imagenes!.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.imagenes!.map((imagen) {
                  return _ImagenGaleriaItem(
                    imageUrl: imagen.imagen,
                    onDelete: () => _eliminarImagenExistente(
                        imagen.idIglesia.toString(),
                        imagen.idImagen!.toString()),
                    isNew: false,
                  );
                }).toList(),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagenGaleriaItem extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onDelete;
  final bool isNew;

  const _ImagenGaleriaItem({
    this.imageFile,
    this.imageUrl,
    required this.onDelete,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageFile != null
              ? Image.file(imageFile!, fit: BoxFit.cover)
              : imageUrl != null
                  ? Image.network("${MainUtils.urlHostAssetsImagen}/$imageUrl",
                      fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 40),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: IconButton(
              icon: const Icon(Icons.close, size: 12, color: Colors.white),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        if (isNew)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Nueva',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
