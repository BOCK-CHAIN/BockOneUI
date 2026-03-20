import 'package:flutter/material.dart';
import '../model/video_model.dart';
import '../model/video_service.dart';

class CreatorStudioScreen extends StatefulWidget {
  final bool isWeb;
  final String hexId;
  const CreatorStudioScreen({super.key, required this.isWeb, required this.hexId});

  @override
  State<CreatorStudioScreen> createState() => _CreatorStudioScreenState();
}

class _CreatorStudioScreenState extends State<CreatorStudioScreen> {
  List<VideoModel> userVideos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserVideos();
  }

  Future<void> fetchUserVideos() async {
    try {
      final videos = await VideoService.fetchUserVideos(widget.hexId);
      setState(() {
        userVideos = videos;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user videos: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              "$count",
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ]),
          Icon(icon, color: Colors.white54, size: 22)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalLikes = userVideos.fold(0, (sum, v) => sum + (v.likes));
    int totalFollowers = 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          const Text("Welcome Back 👋",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text("Track and manage your channel and videos",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),

          // Upload Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            icon: const Icon(Icons.upload, color: Colors.white),
            label: const Text("Upload", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(height: 24),

          // Stats Row
          Column(children: [
            _buildStatCard("Total Followers", totalFollowers, Icons.people_alt_outlined),
            const SizedBox(height: 12),
            _buildStatCard("Total Likes", totalLikes, Icons.favorite_border),
          ]),
          const SizedBox(height: 30),

          // Your Videos Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0B0B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Your Videos",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              const Text("Manage and track your uploaded content",
                  style: TextStyle(color: Colors.white70, fontSize: 15)),
              const SizedBox(height: 16),

              if (isLoading)
                const Center(child: CircularProgressIndicator(color: Colors.purple))
              else if (userVideos.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                      child: Text("You haven't uploaded any videos yet.",
                          style: TextStyle(color: Colors.white70, fontSize: 15))),
                )
              else
                Column(
                  children: userVideos.map((video) {
                    bool isPublished = true;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool isSmallScreen = constraints.maxWidth < 400;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      /*"http://10.0.2.2:5000/${video.thumbnailUrl!}" ?? '',*/
                                      video.thumbnailUrl!,
                                      width: 100,
                                      height: 70,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 100,
                                        height: 70,
                                        color: Colors.grey[800],
                                        child: const Icon(Icons.videocam,
                                            color: Colors.white54, size: 30),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Info + Switch + Actions
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(video.title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                            Switch(
                                              activeColor: Colors.purple,
                                              value: isPublished,
                                              onChanged: (val) {
                                                setState(() => isPublished = val);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(video.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white70, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.thumb_up_alt_outlined,
                                          color: Colors.purpleAccent, size: 16),
                                      const SizedBox(width: 4),
                                      Text("${video.likes}",
                                          style: const TextStyle(
                                              color: Colors.white70, fontSize: 13)),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.thumb_down_alt_outlined,
                                          color: Colors.redAccent, size: 16),
                                      const SizedBox(width: 4),
                                      Text("${video.dislikes}",
                                          style: const TextStyle(
                                              color: Colors.white70, fontSize: 13)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final TextEditingController titleController =
                                          TextEditingController(text: video.title);
                                          final TextEditingController descriptionController =
                                          TextEditingController(text: video.description);

                                          final result = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: const Color(0xFF1C1C1C),
                                              title: const Text("Edit Video",
                                                  style: TextStyle(color: Colors.white)),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: titleController,
                                                    style: const TextStyle(color: Colors.white),
                                                    decoration: const InputDecoration(
                                                      labelText: "Title",
                                                      labelStyle: TextStyle(color: Colors.white70),
                                                      enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.white24)),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.purpleAccent)),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextField(
                                                    controller: descriptionController,
                                                    style: const TextStyle(color: Colors.white),
                                                    maxLines: 3,
                                                    decoration: const InputDecoration(
                                                      labelText: "Description",
                                                      labelStyle: TextStyle(color: Colors.white70),
                                                      enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.white24)),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.purpleAccent)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child:
                                                  const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.purpleAccent),
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text("Save"),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (result == true) {
                                            try {
                                              await VideoService.updateVideo(
                                                  video.id, titleController.text, descriptionController.text);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Video updated successfully"),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );

                                              // Refresh local list
                                              await fetchUserVideos();
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Failed to update video: $e"),
                                                  backgroundColor: Colors.redAccent,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.edit, color: Colors.white70),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: const Color(0xFF1C1C1C),
                                              title: const Text("Delete Video", style: TextStyle(color: Colors.white)),
                                              content: const Text(
                                                "Are you sure you want to delete this video?",
                                                style: TextStyle(color: Colors.white70),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            try {
                                              await VideoService.deleteVideo(video.id);
                                              setState(() {
                                                userVideos.removeWhere((v) => v.id == video.id);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Video deleted successfully"),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Failed to delete video: $e"),
                                                  backgroundColor: Colors.redAccent,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}
