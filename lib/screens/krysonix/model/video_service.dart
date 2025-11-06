import 'dart:convert';
import 'package:http/http.dart' as http;
import 'video_model.dart';

class VideoService {
  static const String baseUrl = "http://10.0.2.2:5000/api/videos";

  // 🧾 Fetch all videos
  static Future<List<VideoModel>> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch videos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching videos: $e");
    }
  }

  // 🎥 Fetch single video by ID
  static Future<VideoModel> fetchVideoById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return VideoModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to fetch video: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching video: $e");
    }
  }

  // 🎥 Fetch videos uploaded by a specific user
  static Future<List<VideoModel>> fetchUserVideos(String hexId) async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/user/$hexId'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch user videos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching user videos: $e");
    }
  }


  // 👍 Like a video
  static Future<void> likeVideo(int videoId, String userHexId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$videoId/like'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'hexId': userHexId}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to like video: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error liking video: $e");
    }
  }

  // 👎 Dislike a video
  static Future<void> dislikeVideo(int videoId, String userHexId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$videoId/dislike'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'hexId': userHexId}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to dislike video: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error disliking video: $e");
    }
  }

  // ⚙️ Get user’s current like/dislike status
  static Future<String?> getUserStatus(int videoId, String userHexId) async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/$videoId/status/$userHexId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status']; // "like", "dislike", or null
      } else {
        throw Exception("Failed to get status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching user status: $e");
    }
  }

  // 🗑️ Delete Video
  static Future<void> deleteVideo(int videoId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$videoId'));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete video: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting video: $e");
    }
  }

  // ✏️ Update Video (Title + Description)
  static Future<void> updateVideo(int videoId, String title, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$videoId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'description': description}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update video: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating video: $e");
    }
  }

}
