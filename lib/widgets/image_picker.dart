import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {

  const ImageInput({
    super.key,
    this.getImageUrl,
    this.initialImageUrl,
  });

  final void Function(File image)? getImageUrl;
  final String? initialImageUrl; // 👈 Add this for network image

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  late String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    _networkImageUrl = widget.initialImageUrl;
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
    await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
      _networkImageUrl = null; // Clear previous image when new one is picked
    });

    widget.getImageUrl?.call(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;

    if (_selectedImage != null) {
      backgroundImage = FileImage(_selectedImage!);
    } else if (_networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(_networkImageUrl!);
    }

    return Center(
      child: InkWell(
        onTap: _takePicture,
        borderRadius: BorderRadius.circular(100),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.deepPurple.shade100,
              backgroundImage: backgroundImage,
              child: backgroundImage == null
                  ? const Icon(Icons.add_a_photo, color: Color(0xFF7B1FA2), size: 32)
                  : null,
            ),
            if (backgroundImage != null)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.edit, size: 18, color: Color(0xFF7B1FA2)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
