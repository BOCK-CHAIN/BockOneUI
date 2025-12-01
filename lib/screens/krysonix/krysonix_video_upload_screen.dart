import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class VideoUploadScreen extends StatefulWidget {
  final String hexId;
  const VideoUploadScreen({super.key,required this.hexId});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? videoFile;
  File? thumbnailFile;

  // Categories
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

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() => videoFile = File(result.files.single.path!));
    }
  }

  Future<void> _pickThumbnail() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => thumbnailFile = File(result.files.single.path!));
    }
  }

  Future<void> _uploadVideo() async {
    if (videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video")),
      );
      return;
    }

    var uri = Uri.parse("http://10.0.2.2:5000/api/videos/upload"); // Android Emulator

    var request = http.MultipartRequest("POST", uri);

    request.fields["title"] = _titleController.text;
    request.fields["description"] = _descriptionController.text;
    request.fields["categories"] = selectedCategories.join(",");
    request.fields["owner_hex_id"] = widget.hexId;

    request.files.add(await http.MultipartFile.fromPath("video", videoFile!.path));
    if (thumbnailFile != null) {
      request.files.add(await http.MultipartFile.fromPath("thumbnail", thumbnailFile!.path));
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Video uploaded successfully")),
      );
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        videoFile = null;
        thumbnailFile = null;
        selectedCategories.clear();
      });
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Upload failed: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Upload Video", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF121212),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 600 ? 600 : constraints.maxWidth;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Placeholder
                      GestureDetector(
                        onTap: _pickVideo,
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                          child: Center(
                            child: videoFile == null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.video_call,
                                    color: Colors.white70, size: 40),
                                SizedBox(height: 8),
                                Text("Tap to upload video",
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            )
                                : Text(
                              "📹 Video selected: ${videoFile!.path.split('/').last}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Thumbnail Placeholder
                      GestureDetector(
                        onTap: _pickThumbnail,
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                          child: Center(
                            child: thumbnailFile == null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.image,
                                    color: Colors.white70, size: 40),
                                SizedBox(height: 8),
                                Text("Tap to upload thumbnail",
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            )
                                : Image.file(thumbnailFile!, fit: BoxFit.cover),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title Input
                      const Text("Title",
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter video title",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF2C2C2C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description Input
                      const Text("Description",
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter video description",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF2C2C2C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Categories Section
                      const Text("Categories",
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),

                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5,
                        children: categories.map((category) {
                          final isSelected = selectedCategories.contains(category);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected
                                    ? selectedCategories.remove(category)
                                    : selectedCategories.add(category);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.purple : const Color(0xFF2C2C2C),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.purpleAccent
                                      : Colors.grey.shade700,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      // Upload Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _uploadVideo,
                          icon: const Icon(Icons.cloud_upload, color: Colors.white),
                          label: const Text("Upload",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
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
