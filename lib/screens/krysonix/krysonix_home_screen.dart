import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trial/screens/home_screen.dart';
import 'package:trial/screens/krysonix/contact_screen.dart';
import 'package:trial/screens/krysonix/data/krysonix_policy_data.dart';
import 'package:trial/screens/krysonix/krysonix_video_upload_screen.dart';
import 'package:trial/screens/krysonix/policy_screen.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_creator_studio.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_drawer.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_history.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_profile_edit_screen.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_profile_screen.dart';
import 'package:trial/screens/krysonix/widgets/krysonix_smart_side_bar.dart';

class KrysonixHomeScreen extends StatelessWidget {
  final String hexId;
  const KrysonixHomeScreen({super.key,required this.hexId});

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    if (width>1200) {
      return WebLayout(hexId: hexId,);
    } else {
      return MobileLayout(hexId: hexId,);
    }
  }
}

// ---------------- WEB LAYOUT ----------------
class WebLayout extends StatefulWidget {
  final String hexId;
  const WebLayout({super.key,required this.hexId});

  static PopupMenuItem<dynamic> _popupMenuItem(IconData icon, String text) {
    return PopupMenuItem<dynamic>(
      value: text, // or some identifier
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url =
    Uri.parse('http://3.109.55.254:3000/api/profile/hex/${widget.hexId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch profile. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _showWebMenu(BuildContext context, Offset position) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    var selected = await showMenu<dynamic>(
      color: const Color(0xFF1E1E1E),
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<dynamic>>[
        const PopupMenuItem<dynamic>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              SizedBox(height: 8),
              Text("John Doe", style: TextStyle(color: Colors.white)),
              Text("john@example.com",
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        WebLayout._popupMenuItem(Icons.person, "View Profile"),
        WebLayout._popupMenuItem(Icons.create, "Creator Studio"),
        WebLayout._popupMenuItem(Icons.settings, "Settings"),
        WebLayout._popupMenuItem(Icons.description, "Terms and Conditions"),
        WebLayout._popupMenuItem(Icons.privacy_tip, "Privacy Policy"),
        WebLayout._popupMenuItem(
            Icons.receipt_long, "Refund and Cancellation Policy"),
        WebLayout._popupMenuItem(Icons.contact_mail, "Contact Us"),
        WebLayout._popupMenuItem(Icons.logout, "Log Out"),
      ],
    );

    if (selected != null) {
      if (selected == "Terms and Conditions") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolicyScreen(
              title: "Terms and Conditions",
              lastUpdated: (termsAndConditions["lastUpdated"] ?? "") as String,
              intro: List<String>.from(
                  (termsAndConditions["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from(
                  (termsAndConditions["sections"] ?? []) as List),
            ),
          ),
        );
      } else if (selected == "Privacy Policy") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolicyScreen(
              title: "Privacy Policy",
              lastUpdated: (privacyPolicy["lastUpdated"] ?? "") as String,
              intro:
                  List<String>.from((privacyPolicy["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from(
                  (privacyPolicy["sections"] ?? []) as List),
            ),
          ),
        );
      } else if (selected == "Refund and Cancellation Policy") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolicyScreen(
              title: "Refund and Cancellation Policy",
              lastUpdated:
                  (refundAndCancellation["lastUpdated"] ?? "") as String,
              intro: List<String>.from(
                  (refundAndCancellation["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from(
                  (refundAndCancellation["sections"] ?? []) as List),
            ),
          ),
        );
      } else if (selected == "Contact Us") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const ContactUsScreen(contactData: contactUs)),
        );
      } else if (selected == "View Profile") {
        _openExtraPage(const ProfileScreen(
          initialTabIndex: 0,
        ));
      } else if (selected == "Creator Studio") {
        _openExtraPage(const CreatorStudioScreen(isWeb: true,));
      } else if(selected == "Settings"){
        _openExtraPage(const ProfileEditScreen(isSettings: false, isWeb: true));
      }
    }
  }

  Widget content = GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 16 / 9),
    itemBuilder: (_, index) => const VideoCard(expand: true),
    itemCount: 12,
  );

  void _openExtraPage(Widget page) {
    setState(() {
      content = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartSidebar(
        sidebarItems: [
          const SizedBox(height:20),
          GestureDetector(
            child: Image.asset('assets/images/Bock White.png',height: 50),
            onTap: (){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=> HomeScreen(userName: userData!['username'])),
                    (route) => false,
              );
            },
          ),
          const SizedBox(height: 20,),
        ],
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF121212),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              Container(
                width: 240,
                color: const Color(0xFF121212),
                child: ListView(
                  children: [
                    SizedBox(
                      child: Align(
                        alignment: Alignment.topLeft, // pushes it to the left
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/Krysonix.png',
                            height: 40, // adjust size as needed
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                        leading: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 16 / 9),
                            itemBuilder: (_, index) => const VideoCard(expand: true),
                            itemCount: 12,
                          ));
                        },
                        title: const Text(
                          'Home',
                          style: TextStyle(color: Colors.white),
                        )),
                    ListTile(
                        leading: const Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const ProfileScreen(initialTabIndex: 3));
                        },
                        title: const Text('Following',
                            style: TextStyle(color: Colors.white))),
                    ListTile(
                        leading: const Icon(
                          Icons.video_library,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const ProfileScreen(initialTabIndex: 1));
                        },
                        title: const Text('Library',
                            style: TextStyle(color: Colors.white))),
                    ListTile(
                        leading: const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const PlaylistCardDemo(name: "History",));
                        },
                        title: const Text('History',
                            style: TextStyle(color: Colors.white))),
                    ListTile(
                        leading: const Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const PlaylistCardDemo(name: "Liked Videos"));
                        },
                        title: const Text('Liked Videos',
                            style: TextStyle(color: Colors.white))),
                    ListTile(
                        leading: const Icon(
                          Icons.video_call,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const ProfileScreen(initialTabIndex: 0));
                        },
                        title: const Text('Your Videos',
                            style: TextStyle(color: Colors.white))),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Shopping',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.music_note_outlined,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Music',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.movie_creation_outlined,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Movies',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.gamepad_outlined,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Gaming',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.newspaper,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('News',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.sports_baseball_outlined,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Sports',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.leaderboard_outlined,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Courses',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.podcasts,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Podcast',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onTap: (){},
                      title: const Text('Fashion & Beauty',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                        leading: const Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const CreatorStudioScreen(isWeb: true,));
                        },
                        title: const Text('Creator Studio',
                            style: TextStyle(color: Colors.white))),
                    ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onTap: (){
                          _openExtraPage(const ProfileEditScreen(isSettings: false, isWeb: true));
                        },
                        title: const Text('Settings',
                            style: TextStyle(color: Colors.white),
                        ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Column(
                  children: [
                    // Top bar
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: const Color(0xFF121212),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                filled: true,
                                fillColor: const Color(0xFF2C2C2C),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide.none),
                                prefixIcon:
                                    const Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const VideoUploadScreen()));
                            },
                            icon: const Icon(Icons.upload, color: Colors.white),
                            label: const Text(
                              "Upload",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTapDown: (details) =>
                                _showWebMenu(context, details.globalPosition),
                            child:
                                const CircleAvatar(backgroundColor: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 8,
                    ),
                    // Video grid
                    Expanded(child: content)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- MOBILE LAYOUT ----------------
class MobileLayout extends StatefulWidget {
  final String hexId;
  const MobileLayout({super.key,required this.hexId});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _currentIndex = 0;
  Widget? _extraPage;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url =
    Uri.parse('http://3.109.55.254:3000/api/profile/hex/${widget.hexId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch profile. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  final List<Widget> _pages = [
    // Home
    Column(
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
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: VideoCard(),
            ),
          ),
        )
      ],
    ),
    const ProfileScreen(initialTabIndex: 3),
    const ProfileScreen(initialTabIndex: 1),
    const PlaylistCardDemo(name: "History",),
  ];

  void _openExtraPage(Widget page) {
    setState(() {
      _extraPage = page;
      Navigator.pop(context); // close the drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/Krysonix.png', height: 50),
        ),
      ),
      drawer: KrysonixDrawer(
        onProfileTap: () {
          _openExtraPage(const ProfileScreen(
            initialTabIndex: 0,
          ));
        },
        onCreatorStudioTap: () {
          _openExtraPage(const CreatorStudioScreen(isWeb: false,));
        },
        onSettingsTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProfileEditScreen(
                isSettings: true,
                isWeb: false,
              ),
          ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _extraPage = null; // 👈 reset extra page when user switches tabs
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Following"),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
      body: SmartSidebar(
        sidebarItems: [
          const SizedBox(height:20),
          GestureDetector(
              child: Image.asset('assets/images/Bock White.png',height: 50),
            onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=> HomeScreen(userName: userData!['username'])),
                  (route) => false,
                );
            },
          ),
          const SizedBox(height: 20,),
        ],
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
            ),
          ),
          child: _extraPage ?? _pages[_currentIndex], // 👈 show extra page if open
        ),
      ),
    );
  }
}

// ---------------- VIDEO CARD ----------------
class VideoCard extends StatelessWidget {
  final bool expand;

  const VideoCard({super.key, this.expand = false});

  @override
  Widget build(BuildContext context) {
    final thumbnail = Container(
      height: expand ? null : 180,
      color: Colors.grey[800],
      child: const Center(
        child: Text("Thumbnail", style: TextStyle(color: Colors.white70)),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          expand ? Expanded(child: thumbnail) : thumbnail,
          const ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey),
            title: Text("Video title",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("8 Views • 5 months ago\nChannel name",
                style: TextStyle(color: Colors.white70)),
          )
        ],
      ),
    );
  }
}
