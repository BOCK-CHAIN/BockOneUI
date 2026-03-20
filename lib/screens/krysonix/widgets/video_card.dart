import 'package:flutter/material.dart';
import 'package:trial/screens/krysonix/model/video_model.dart';
import 'package:trial/screens/krysonix/video_player_screen.dart';


class VideoCard extends StatelessWidget {
  final String hexId;
  final VideoModel video;
  final bool expand;
  final Future<List<VideoModel>>? allVideos;

  const VideoCard({super.key, required this.video, this.expand = false,required this.hexId,this.allVideos});

  @override
  Widget build(BuildContext context) {
    final thumbnail = Container(
      height: expand ? null : 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[800],
        image: video.thumbnailUrl != null
            ? DecorationImage(
          // image: NetworkImage("http://10.0.2.2:5000/${video.thumbnailUrl!}"),
          image: NetworkImage(video.thumbnailUrl!),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: video.thumbnailUrl == null
          ? const Center(
        child: Text("No Thumbnail", style: TextStyle(color: Colors.white70)),
      )
          : null,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(video: video,hexId: hexId,),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            expand ? Expanded(child: thumbnail) : thumbnail,
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.grey),
              title: Text(
                video.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${video.description}\n${video.categories.join(", ")}",
                style: const TextStyle(color: Colors.white70),
              ),
            )
          ],
        ),
      ),
    );
  }
}
