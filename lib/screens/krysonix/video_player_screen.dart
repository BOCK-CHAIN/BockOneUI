import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:trial/screens/krysonix/model/video_model.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String hexId; // current logged-in user
  final VideoModel video;
  final Future<List<VideoModel>>? allVideos; // Optional list to support "Next Video"
  const VideoPlayerScreen({
    super.key,
    required this.video,
    required this.hexId,
    this.allVideos,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? uploaderData;
  List<VideoModel>? allVideos;
  bool _showControls = false;
  Timer? _hideControlsTimer;

  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isFollowing = false;
  int _likes = 0;
  int _dislikes = 0;
  double _playbackSpeed = 1.0;

  List<dynamic> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  final String baseUrl = "http://10.0.2.2:5000/api/videos";
  final String followBaseUrl = "http://10.0.2.2:5000/api/follow";

  @override
  void initState() {
    super.initState();
    _loadAllVideos();
    _initializeVideo(widget.video.videoUrl);
    fetchUserData();
    fetchUploaderData();
    _fetchVideoData();
    _fetchComments();
    _fetchUserLikeStatus();
    _fetchFollowStatus();
  }

  Future<void> _loadAllVideos() async {
    if (widget.allVideos != null) {
      final videos = await widget.allVideos!;
      setState(() {
        allVideos = videos;
      });
    }
  }

  void _initializeVideo(String url) {
    _controller = VideoPlayerController.networkUrl(Uri.parse("http://10.0.2.2:5000/$url"))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });

    // ✅ Add listener to rebuild when position changes
    _controller.addListener(() {
      if (mounted) setState(() {});

      // ✅ Auto play next video when finished
      if (_controller.value.position >= _controller.value.duration &&
          _controller.value.isInitialized &&
          !_controller.value.isPlaying) {
        _playNextVideo();
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });

    // Reset the auto-hide timer
    _hideControlsTimer?.cancel();
    if (_showControls) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showControls = false);
      });
    }
  }

  void _openFullScreen() async {
    // Lock orientation to landscape
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide status + navigation bars
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Push fullscreen route
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: _controller),
      ),
    );

    // Restore portrait and UI
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }


  Future<void> fetchUserData() async {
    final url = Uri.parse('http://13.233.163.28:3000/api/profile/hex/${widget.hexId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    }
  }

  Future<void> fetchUploaderData() async {
    final uploaderHexId = widget.video.uploaderHexId;
    final url = Uri.parse('http://13.233.163.28:3000/api/profile/hex/$uploaderHexId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        uploaderData = jsonDecode(response.body);
      });
    }
  }

  Future<void> _fetchVideoData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final videos = jsonDecode(response.body) as List;
        final thisVideo =
        videos.firstWhere((v) => v["id"] == widget.video.id, orElse: () => null);
        if (thisVideo != null) {
          setState(() {
            _likes = thisVideo["likes"] ?? 0;
            _dislikes = thisVideo["dislikes"] ?? 0;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching video data: $e");
    }
  }

  Future<void> _fetchComments() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/${widget.video.id}/comments"));
      if (res.statusCode == 200) {
        setState(() {
          _comments = jsonDecode(res.body);
        });
      }
    } catch (e) {
      debugPrint("Error fetching comments: $e");
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/${widget.video.id}/comments"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": userData?['username'] ?? 'User',
          "text": text,
        }),
      );
      if (res.statusCode == 201) {
        _commentController.clear();
        _fetchComments();
      }
    } catch (e) {
      debugPrint("Error adding comment: $e");
    }
  }

  Future<void> _fetchUserLikeStatus() async {
    try {
      final res =
      await http.get(Uri.parse("$baseUrl/${widget.video.id}/status/${widget.hexId}"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _isLiked = data['status'] == 'like';
          _isDisliked = data['status'] == 'dislike';
        });
      }
    } catch (e) {
      debugPrint("Error fetching user like status: $e");
    }
  }

  Future<void> _fetchFollowStatus() async {
    try {
      final res = await http.get(Uri.parse(
          "$followBaseUrl/status/${widget.hexId}/${widget.video.uploaderHexId}"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _isFollowing = data['is_following'] ?? false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching follow status: $e");
    }
  }

  Future<void> _toggleFollow() async {
    try {
      debugPrint("Trying to ${_isFollowing ? 'unfollow' : 'follow'}:");
      debugPrint("followerHexId: ${widget.hexId}");
      debugPrint("followingHexId: ${widget.video.uploaderHexId}");

      final url = _isFollowing
          ? "$followBaseUrl/unfollow"
          : "$followBaseUrl/follow";

      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "followerHexId": widget.hexId,
          "followingHexId": widget.video.uploaderHexId,
        }),
      );

      if (res.statusCode == 200) {
        setState(() {
          _isFollowing = !_isFollowing;
        });
      } else {
        debugPrint("Follow API failed: ${res.statusCode} → ${res.body}");
      }
    } catch (e) {
      debugPrint("Error toggling follow: $e");
    }
  }


  Future<void> _likeVideo() async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/${widget.video.id}/like"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'hexId': widget.hexId}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _isLiked = data['liked'] ?? false;
          if (_isLiked) _likes++; else _likes = (_likes > 0) ? _likes - 1 : 0;
          if (_isDisliked && _dislikes > 0) _dislikes--;
          _isDisliked = false;
        });
      }
    } catch (e) {
      debugPrint("Error liking video: $e");
    }
  }

  Future<void> _dislikeVideo() async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/${widget.video.id}/dislike"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'hexId': widget.hexId}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _isDisliked = data['disliked'] ?? false;
          if (_isDisliked) _dislikes++; else _dislikes = (_dislikes > 0) ? _dislikes - 1 : 0;
          if (_isLiked && _likes > 0) _likes--;
          _isLiked = false;
        });
      }
    } catch (e) {
      debugPrint("Error disliking video: $e");
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  // ✅ Skip ±10 seconds
  void _skipForward() {
    final pos = _controller.value.position;
    final dur = _controller.value.duration;
    final newPos = pos + const Duration(seconds: 10);
    _controller.seekTo(newPos < dur ? newPos : dur);
  }

  void _skipBackward() {
    final pos = _controller.value.position;
    final newPos = pos - const Duration(seconds: 10);
    _controller.seekTo(newPos > Duration.zero ? newPos : Duration.zero);
  }

  // ✅ Change playback speed
  void _changeSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
    setState(() {
      _playbackSpeed = speed;
    });
  }

  // ✅ Play next video
  void _playNextVideo() {
    if (allVideos == null) {
      print("null it is");
      return;
    }
    final currentIndex = allVideos!.indexWhere((v) => v.id == widget.video.id);
    if (currentIndex != -1 && currentIndex < allVideos!.length - 1) {
      final nextVideo = allVideos![currentIndex + 1];

      _controller.pause();
      _controller.dispose();

      setState(() {
        _isPlaying = false;
      });

      // ✅ Reinitialize next video after short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _initializeVideo(nextVideo.videoUrl);
      });
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            // ▶ Video Player with new controls
            GestureDetector(
              onTap: _toggleControlsVisibility,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 9 / 16, // ✅ Fixes 16:9 ratio
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _controller.value.isInitialized
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    )
                        : const Center(child: CircularProgressIndicator()),

                    // ▶ Controls overlay
                    if (_showControls)
                      Positioned(
                        bottom: 40,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: _skipBackward,
                                icon: const Icon(Icons.replay_10,
                                    color: Colors.white, size: 30)),
                            IconButton(
                                onPressed: _togglePlayPause,
                                icon: Icon(
                                  _isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 40,
                                )),
                            IconButton(
                                onPressed: _skipForward,
                                icon: const Icon(Icons.forward_10,
                                    color: Colors.white, size: 30)),
                            IconButton(
                                onPressed: _playNextVideo,
                                icon: const Icon(Icons.skip_next,
                                    color: Colors.white, size: 30)),
                            PopupMenuButton<double>(
                              color: Colors.black87,
                              icon: Text("${_playbackSpeed}x",
                                  style: const TextStyle(color: Colors.white)),
                              onSelected: _changeSpeed,
                              itemBuilder: (context) => [
                                for (var s in [0.5, 1.0, 1.5, 2.0])
                                  PopupMenuItem(
                                    value: s,
                                    child: Text("${s}x",
                                        style: const TextStyle(color: Colors.white)),
                                  ),
                              ],
                            ),
                            // ✅ Fullscreen button
                            IconButton(
                              onPressed: _openFullScreen,
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                      ),

                    // ✅ Progress bar always visible
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: _controller.value.isInitialized
                          ? VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.redAccent,
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white10,
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // ▶ Rest of your existing UI (likes, follow, comments, etc.)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(widget.video.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "$_likes Likes • $_dislikes Dislikes",
                        style:
                        const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionButton(
                            icon: _isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            label: "Like ($_likes)",
                            onTap: _likeVideo),
                        _actionButton(
                            icon: _isDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            label: "Dislike ($_dislikes)",
                            onTap: _dislikeVideo),
                      ],
                    ),
                    const Divider(color: Colors.white24),

                    // Channel info (dynamic)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              uploaderData?['username'] ?? "Channel",
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _toggleFollow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              _isFollowing ? Colors.grey[800] : Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(
                              _isFollowing ? "Following" : "Follow",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 1),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.video.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),

                    // Comments
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text("Comments",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Add a comment...",
                                hintStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _addComment,
                            icon: const Icon(Icons.send, color: Colors.white),
                          )
                        ],
                      ),
                    ),

                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _comments.length,
                      itemBuilder: (_, i) {
                        final c = _comments[i];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white70),
                          ),
                          title: Text(c["username"] ?? "User",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(c["text"] ?? "",
                              style: const TextStyle(color: Colors.white70)),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = false;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  Timer? _hideControlsTimer;

  VideoPlayerController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _isPlaying = _controller.value.isPlaying;
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _toggleControlsVisibility() {
    setState(() => _showControls = !_showControls);

    _hideControlsTimer?.cancel();
    if (_showControls) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showControls = false);
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _skipForward() {
    final pos = _controller.value.position;
    final dur = _controller.value.duration;
    final newPos = pos + const Duration(seconds: 10);
    _controller.seekTo(newPos < dur ? newPos : dur);
  }

  void _skipBackward() {
    final pos = _controller.value.position;
    final newPos = pos - const Duration(seconds: 10);
    _controller.seekTo(newPos > Duration.zero ? newPos : Duration.zero);
  }

  void _changeSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
    setState(() {
      _playbackSpeed = speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🎥 Fullscreen video
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

            // ▶️ Overlay Controls
            if (_showControls)
              Positioned(
                bottom: 40,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: _skipBackward,
                      icon: const Icon(Icons.replay_10,
                          color: Colors.white, size: 30),
                    ),
                    IconButton(
                      onPressed: _togglePlayPause,
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: _skipForward,
                      icon: const Icon(Icons.forward_10,
                          color: Colors.white, size: 30),
                    ),
                    PopupMenuButton<double>(
                      color: Colors.black87,
                      icon: Text("${_playbackSpeed}x",
                          style: const TextStyle(color: Colors.white)),
                      onSelected: _changeSpeed,
                      itemBuilder: (context) => [
                        for (var s in [0.5, 1.0, 1.5, 2.0])
                          PopupMenuItem(
                            value: s,
                            child: Text("${s}x",
                                style: const TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.fullscreen_exit,
                          color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),

            // 📊 Progress bar
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: _controller.value.isInitialized
                  ? VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.redAccent,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white10,
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
