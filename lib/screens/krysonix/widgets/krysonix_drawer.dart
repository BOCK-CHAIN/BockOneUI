import "package:flutter/material.dart";
import 'package:trial/screens/krysonix/contact_screen.dart';
import 'package:trial/screens/krysonix/data/krysonix_policy_data.dart';
import 'package:trial/screens/krysonix/krysonix_video_upload_screen.dart';
import 'package:trial/screens/krysonix/policy_screen.dart';

class KrysonixDrawer extends StatelessWidget {
  final String hexId;
  final VoidCallback onCreatorStudioTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onProfileTap;

  const KrysonixDrawer({super.key, required this.onCreatorStudioTap, required this.onSettingsTap,  required this.onProfileTap,required this.hexId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== Top Navigation ====
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text("Profile", style: TextStyle(color: Colors.white)),
                onTap: onProfileTap,
              ),
              ListTile(
                leading: const Icon(Icons.create, color: Colors.white),
                title: const Text("Creator Studio", style: TextStyle(color: Colors.white)),
                onTap: onCreatorStudioTap,
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text("Settings", style: TextStyle(color: Colors.white)),
                onTap: onSettingsTap,
              ),
              const SizedBox(height: 10),

              // ==== Upload Button ====
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> VideoUploadScreen(hexId: hexId,)));
                  },
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Text("Upload", style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(color: Colors.white24),

              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                title: const Text("Shopping", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.music_note_outlined, color: Colors.white),
                title: const Text("Music", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.movie_creation_outlined, color: Colors.white),
                title: const Text("Movies", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),ListTile(
                leading: const Icon(Icons.gamepad_outlined, color: Colors.white),
                title: const Text("Gaming", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.newspaper, color: Colors.white),
                title: const Text("News", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),ListTile(
                leading: const Icon(Icons.sports_baseball_outlined, color: Colors.white),
                title: const Text("Sports", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.leaderboard_outlined, color: Colors.white),
                title: const Text("Courses", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.podcasts, color: Colors.white),
                title: const Text("Podcast", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.face_outlined, color: Colors.white),
                title: const Text("Fashion and Beauty", style: TextStyle(color: Colors.white)),
                onTap: (){},
              ),


              const Divider(color: Colors.white24),

              // ==== Policy Section ====
              ListTile(
                leading: const Icon(Icons.description, color: Colors.white),
                title: const Text("Terms and Conditions", style: TextStyle(color: Colors.white)),
                onTap: () {
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.white),
                title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PolicyScreen(
                        title: "Privacy Policy",
                        lastUpdated: (privacyPolicy["lastUpdated"] ?? "") as String,
                        intro: List<String>.from(
                            (privacyPolicy["content"] ?? []) as List),
                        sections: List<Map<String, dynamic>>.from(
                            (privacyPolicy["sections"] ?? []) as List),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long, color: Colors.white),
                title: const Text("Refund and Cancellation Policy", style: TextStyle(color: Colors.white)),
                onTap: () {
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
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail, color: Colors.white),
                title: const Text("Contact Us", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ContactUsScreen(contactData: contactUs)
                    ),
                  );
                },
              ),

              const Spacer(),

              // ==== Bottom User Info ====
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("likith", style: TextStyle(color: Colors.white)),
                          Text("abcdef@gmail.com",
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                    ),
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
