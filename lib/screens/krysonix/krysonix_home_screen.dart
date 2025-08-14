import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trial/screens/krysonix/data/krysonix_policy_data.dart';
import 'package:trial/screens/krysonix/policy_screen.dart';

class KrysonixHomeScreen extends StatelessWidget {
  const KrysonixHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebLayout();
    } else {
      return const MobileLayout();
    }
  }
}

// ---------------- WEB LAYOUT ----------------
class WebLayout extends StatelessWidget {
  const WebLayout({super.key});

  void _showWebMenu(BuildContext context, Offset position) async {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu<dynamic>(
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
        _popupMenuItem(Icons.person, "View Profile"),
        _popupMenuItem(Icons.create, "Creator Studio"),
        _popupMenuItem(Icons.settings, "Settings"),
        _popupMenuItem(Icons.description, "Terms and Conditions"),
        _popupMenuItem(Icons.privacy_tip, "Privacy Policy"),
        _popupMenuItem(Icons.receipt_long, "Refund and Cancellation Policy"),
        _popupMenuItem(Icons.contact_mail, "Contact Us"),
        _popupMenuItem(Icons.logout, "Log Out"),
      ],
    );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          children: [
            // Sidebar
            Container(
              width: 240,
              color: const Color(0xFF121212),
              child: ListView(
                children: const [
                  DrawerHeader(
                    child: Text("Krysonix",
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(leading: Icon(Icons.home), title: Text('Home')),
                  ListTile(leading: Icon(Icons.people), title: Text('Following')),
                  ListTile(leading: Icon(Icons.video_library), title: Text('Library')),
                  ListTile(leading: Icon(Icons.history), title: Text('History')),
                  ListTile(leading: Icon(Icons.thumb_up), title: Text('Liked Videos')),
                  ListTile(leading: Icon(Icons.video_call), title: Text('Your Videos')),
                  Divider(),
                  ListTile(leading: Icon(Icons.create), title: Text('Creator Studio')),
                  ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
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
                        const Text("Krysonix",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
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
                          onPressed: () {},
                          icon: const Icon(Icons.upload, color: Colors.white),
                          label: const Text("Upload"),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTapDown: (details) =>
                              _showWebMenu(context, details.globalPosition),
                          child: const CircleAvatar(backgroundColor: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Video grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 16 / 9),
                      itemBuilder: (_, index) => const VideoCard(expand: true),
                      itemCount: 12,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- MOBILE LAYOUT ----------------
class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  void _showMobileDropdown(BuildContext context, Offset position) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    var selected = await showMenu<dynamic>(
      color: const Color(0xFF1E1E1E),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<dynamic>>[
        const PopupMenuItem<dynamic>(
          enabled: false,
          child: Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("John Doe", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5,),
                  Text("john@example.com",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
        const PopupMenuDivider(),
        _popupMenuItem(Icons.person, "View Profile"),
        _popupMenuItem(Icons.create, "Creator Studio"),
        _popupMenuItem(Icons.settings, "Settings"),
        const PopupMenuDivider(),
        _popupMenuItem(Icons.description, "Terms and Conditions"),
        _popupMenuItem(Icons.privacy_tip, "Privacy Policy"),
        _popupMenuItem(Icons.receipt_long, "Refund and Cancellation Policy"),
        _popupMenuItem(Icons.contact_mail, "Contact Us"),
        const PopupMenuDivider(),
        _popupMenuItem(Icons.logout, "Log Out"),
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
              intro: List<String>.from((termsAndConditions["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from((termsAndConditions["sections"] ?? []) as List),
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
              intro: List<String>.from((privacyPolicy["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from((privacyPolicy["sections"] ?? []) as List),
            )
          ),
        );
      } else if (selected == "Refund and Cancellation Policy") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolicyScreen(
              title: "Refund and Cancellation Policy",
              lastUpdated: (refundAndCancellation["lastUpdated"] ?? "") as String,
              intro: List<String>.from((refundAndCancellation["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from((refundAndCancellation["sections"] ?? []) as List),
            ),
          ),
        );
      } else if (selected == "Contact Us") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolicyScreen(
              title: "Contact Us",
              lastUpdated: (termsAndConditions["lastUpdated"] ?? "") as String,
              intro: List<String>.from((termsAndConditions["content"] ?? []) as List),
              sections: List<Map<String, dynamic>>.from((termsAndConditions["sections"] ?? []) as List),
            ),
          ),
        );
      }
    }

  }

  static PopupMenuItem<dynamic> _popupMenuItem(IconData icon, String text) {
    return PopupMenuItem<dynamic>(
      value: text,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.asset('assets/images/Krysonix.png', height: 50),
              const Spacer(),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showMobileDropdown(context, details.globalPosition);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF121212),
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text("Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Home', style: TextStyle(color: Colors.white))),
            ListTile(
                leading: Icon(Icons.people),
                title: Text('Following', style: TextStyle(color: Colors.white))),
            ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Library', style: TextStyle(color: Colors.white))),
            ListTile(
                leading: Icon(Icons.history),
                title: Text('History', style: TextStyle(color: Colors.white))),
            ListTile(
                leading: Icon(Icons.thumb_up),
                title:
                Text('Liked Videos', style: TextStyle(color: Colors.white))),
            ListTile(
                leading: Icon(Icons.video_call),
                title:
                Text('Your Videos', style: TextStyle(color: Colors.white))),
            Divider(),
            ListTile(
                leading: Icon(Icons.create),
                title:
                Text('Creator Studio', style: TextStyle(color: Colors.white))),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
      body: Container(
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
        child: Column(
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
                      borderSide: BorderSide.none),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {},
        child: const Icon(Icons.upload, color: Colors.white),
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
