import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {

  const ImageInput({
    super.key,
    this.getImageUrl,
    this.initialImageUrl,
  });

  final void Function(dynamic image)? getImageUrl; // Changed to support File on mobile, XFile on web
  final String? initialImageUrl; // 👈 Add this for network image

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  dynamic _selectedImage; // File on mobile, XFile on web
  Uint8List? _webImageBytes; // Store bytes for web
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

    if (kIsWeb) {
      // For web, read bytes and store them
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImage = pickedImage; // Keep XFile for web
        _webImageBytes = bytes;
        _networkImageUrl = null;
      });
    } else {
      // For mobile/desktop, create File
      setState(() {
        _selectedImage = File(pickedImage.path);
        _webImageBytes = null;
        _networkImageUrl = null;
      });
    }

    widget.getImageUrl?.call(_selectedImage);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;

    if (_selectedImage != null) {
      if (kIsWeb && _webImageBytes != null) {
        // For web, use MemoryImage with bytes
        backgroundImage = MemoryImage(_webImageBytes!);
      } else if (!kIsWeb) {
        // For mobile/desktop, use FileImage
        backgroundImage = FileImage(_selectedImage!);
      }
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
