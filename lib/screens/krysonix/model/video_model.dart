class VideoModel {
  final int id;
  final String title;
  final String description;
  final List<String> categories;
  final String videoUrl;
  final String? thumbnailUrl;
  final String createdAt;
  final int likes;
  final int dislikes;
  final String uploaderHexId;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categories,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
    required this.uploaderHexId,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      videoUrl: json['video_url'] ?? "",
      thumbnailUrl: json['thumbnail_url'],
      createdAt: json['created_at'] ?? "",
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      uploaderHexId: json['uploader_hex_id'] ??
          json['owner_hex_id'] ?? "", // ✅ fallback added
    );
  }
}
