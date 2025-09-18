import 'package:flutter/material.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? videoPath;
  String? thumbnailPath;

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

  // Selected categories
  final Set<String> selectedCategories = {};

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
                        onTap: () {},
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                          child: Center(
                            child: videoPath == null
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
                                : const Text("Video selected",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Thumbnail Placeholder
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple, width: 1),
                          ),
                          child: Center(
                            child: thumbnailPath == null
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
                                : const Text("Thumbnail selected",
                                style: TextStyle(color: Colors.white)),
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
                        crossAxisCount: 3, // 3 items per row
                        shrinkWrap: true, // makes it fit inside Column
                        physics: const NeverScrollableScrollPhysics(), // disable inner scrolling
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5, // adjust width/height ratio of boxes
                        children: categories.map((category) {
                          final isSelected = selectedCategories.contains(category);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedCategories.remove(category);
                                } else {
                                  selectedCategories.add(category);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.purple : const Color(0xFF2C2C2C),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? Colors.purpleAccent : Colors.grey.shade700,
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
                          onPressed: () {},
                          icon: const Icon(Icons.cloud_upload, color: Colors.white),
                          label: const Text("Upload",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16)),
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
