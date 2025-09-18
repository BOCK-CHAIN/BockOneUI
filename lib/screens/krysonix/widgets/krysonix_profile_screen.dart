import 'package:flutter/material.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int initialTabIndex;
  const ProfileScreen({Key? key, required this.initialTabIndex}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this,initialIndex: widget.initialTabIndex,);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      if (_tabController.index != widget.initialTabIndex) {
        _tabController.animateTo(widget.initialTabIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner + Profile Picture
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  color: Colors.grey[900],
                  child: Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 16,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // Name + Followers / Following
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: const Text(
              "likith",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: const Text(
              "0 Followers   •   0 Following",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),

          // Edit button
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ProfileEditScreen(isSettings: false,isWeb: false,)));
              },
              icon: const Icon(Icons.edit, size: 16, color: Colors.white),
              label: const Text("Edit",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 16),

          // Tabs
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.purple,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Videos"),
              Tab(text: "Playlists"),
              Tab(text: "Announcements"),
              Tab(text: "Following"),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Videos Tab
                _buildNoVideosSection(),
                // Playlists Tab
                _buildEmptyTab("No Playlists Available"),
                // Announcements Tab
                _buildEmptyTab("No Announcements Yet"),
                // Following Tab
                _buildEmptyTab("Not Following Anyone"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoVideosSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow, color: Colors.red, size: 60),
          const SizedBox(height: 12),
          const Text(
            "No Videos Uploaded",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            "Click to upload new video. You have yet to upload a video.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: const Text("New Video",
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTab(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
