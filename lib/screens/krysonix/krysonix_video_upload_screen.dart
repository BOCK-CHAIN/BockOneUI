import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:trial/screens/configuration/backend_url_resolver.dart';

class VideoUploadScreen extends StatefulWidget {
  final String hexId;
  const VideoUploadScreen({super.key, required this.hexId});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();

  // ---------- VIDEO ----------
  File? videoFile;
  Uint8List? videoWebBytes;
  String? videoWebName;

  // ---------- THUMBNAIL ----------
  File? thumbnailFile;
  Uint8List? thumbnailWebBytes;
  String? thumbnailWebName;

  final List<String> categories = [
    "Shopping",
    "Movies",
    "Music",
    "Gaming",
    "News",
    "Sports",
    "Courses",
    "Fashion & Beauty",
    "Podcast",
  ];

  final Set<String> selectedCategories = {};

  // ---------------- PICK VIDEO ----------------
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true, // IMPORTANT for web
    );

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          videoWebBytes = result.files.single.bytes;
          videoWebName = result.files.single.name;
          videoFile = null;
        });
      } else {
        setState(() {
          videoFile = File(result.files.single.path!);
          videoWebBytes = null;
          videoWebName = null;
        });
      }
    }
  }

  // ---------------- PICK THUMBNAIL ----------------
  Future<void> _pickThumbnail() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          thumbnailWebBytes = result.files.single.bytes;
          thumbnailWebName = result.files.single.name;
          thumbnailFile = null;
        });
      } else {
        setState(() {
          thumbnailFile = File(result.files.single.path!);
          thumbnailWebBytes = null;
          thumbnailWebName = null;
        });
      }
    }
  }

  // ---------------- UPLOAD ----------------
  Future<void> _uploadVideo() async {
    if ((!kIsWeb && videoFile == null) ||
        (kIsWeb && videoWebBytes == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video")),
      );
      return;
    }

    final backendBaseUrl = await BackendUrlResolver.resolve(
      configuredBaseUrl: 'http://127.0.0.1:5000',
      defaultPort: 5000,
    );
    final uri = Uri.parse("$backendBaseUrl/api/videos/upload");

    var request = http.MultipartRequest("POST", uri);

    request.fields["title"] = _titleController.text;
    request.fields["description"] = _descriptionController.text;
    request.fields["categories"] = selectedCategories.join(",");
    request.fields["owner_hex_id"] = widget.hexId;

    // ---------- VIDEO ----------
    if (kIsWeb && videoWebBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "video",
          videoWebBytes!,
          filename: videoWebName,
        ),
      );
    } else if (videoFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "video",
          videoFile!.path,
        ),
      );
    }

    // ---------- THUMBNAIL ----------
    if (kIsWeb && thumbnailWebBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "thumbnail",
          thumbnailWebBytes!,
          filename: thumbnailWebName,
        ),
      );
    } else if (thumbnailFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "thumbnail",
          thumbnailFile!.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video uploaded successfully")),
      );

      _titleController.clear();
      _descriptionController.clear();

      setState(() {
        videoFile = null;
        videoWebBytes = null;
        videoWebName = null;

        thumbnailFile = null;
        thumbnailWebBytes = null;
        thumbnailWebName = null;

        selectedCategories.clear();
      });

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${response.statusCode}")),
      );
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Upload Video",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF121212),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth =
              constraints.maxWidth > 600 ? 600 : constraints.maxWidth;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // -------- VIDEO --------
                      GestureDetector(
                        onTap: _pickVideo,
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple),
                          ),
                          child: Center(
                            child: (videoFile == null &&
                                    videoWebBytes == null)
                                ? const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.video_call,
                                          color: Colors.white70, size: 40),
                                      SizedBox(height: 8),
                                      Text("Tap to upload video",
                                          style: TextStyle(
                                              color: Colors.white70)),
                                    ],
                                  )
                                : Text(
                                    "Video selected: ${videoFile != null ? videoFile!.path.split('/').last : videoWebName}",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------- THUMBNAIL --------
                      GestureDetector(
                        onTap: _pickThumbnail,
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple),
                          ),
                          child: Center(
                            child: (kIsWeb &&
                                    thumbnailWebBytes != null)
                                ? Image.memory(thumbnailWebBytes!,
                                    fit: BoxFit.cover)
                                : (thumbnailFile != null)
                                    ? Image.file(thumbnailFile!,
                                        fit: BoxFit.cover)
                                    : const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image,
                                              color: Colors.white70,
                                              size: 40),
                                          SizedBox(height: 8),
                                          Text(
                                            "Tap to upload thumbnail",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: _titleController,
                        style:
                            const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Title",
                          hintStyle:
                              TextStyle(color: Colors.white54),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style:
                            const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Description",
                          hintStyle:
                              TextStyle(color: Colors.white54),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _uploadVideo,
                          child: const Text("Upload"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
