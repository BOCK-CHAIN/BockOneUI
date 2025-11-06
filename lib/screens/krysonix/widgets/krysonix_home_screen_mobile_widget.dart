import 'package:flutter/material.dart';

import 'package:trial/screens/krysonix/model/video_service.dart';
import 'package:trial/screens/krysonix/model/video_model.dart';
import 'package:trial/screens/krysonix/widgets/video_card.dart';


class HomeScreenWidget extends StatefulWidget {
  final String hexId;
  const HomeScreenWidget({super.key,required this.hexId});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWidget> {
  late Future<List<VideoModel>> videosFuture;

  @override
  void initState() {
    super.initState();
    videosFuture = VideoService.fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<VideoModel>>(
            future: videosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No videos available", style: TextStyle(color: Colors.white70)),
                );
              }

              final videos = snapshot.data!;
              return ListView.builder(
                itemCount: videos.length,
                itemBuilder: (_, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: VideoCard(video: videos[index],hexId: widget.hexId,allVideos:videosFuture),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
