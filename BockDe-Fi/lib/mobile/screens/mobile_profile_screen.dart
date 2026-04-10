import 'package:bockchain/mobile/screens/mobile_accountinfo_screen.dart';
import 'package:bockchain/mobile/screens/mobile_alphaevents_screen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_earn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_newlisting_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_referral_screen.dart';
import 'package:bockchain/mobile/screens/mobile_service_screen.dart';
import 'package:bockchain/mobile/screens/mobile_simpleearn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_square_screen.dart';
import 'package:flutter/material.dart';

class MobileProfileScreen extends StatelessWidget {
  const MobileProfileScreen({Key? key, required String username, required String email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MobileAccountInfoScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, size: 40, color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ID: 1158450833',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'User-4991c',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Regular',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 122, 79, 223),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Shortcut Section
              const Text(
                'Shortcut',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildShortcutItem(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      label: 'Buy crypto',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileBuyScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildShortcutItem(
                      context,
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Earn',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileEarnScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildShortcutItem(
                      context,
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Recommend Section
              const Text(
                'Recommend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildRecommendItem(
                      context,
                      icon: Icons.local_offer_outlined,
                      label: 'New Listing\nPromos',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileNewListingScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildRecommendItem(
                      context,
                      icon: Icons.monetization_on_outlined,
                      label: 'Simple Earn',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileSimpleEarnScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildRecommendItem(
                      context,
                      icon: Icons.person_add_outlined,
                      label: 'Referral',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileReferralScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildRecommendItem(
                      context,
                      icon: Icons.event_outlined,
                      label: 'Alpha Events',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileAlphaEventsScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildRecommendItem(
                      context,
                      icon: Icons.people_outline,
                      label: 'P2P',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileP2pScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildRecommendItem(
                      context,
                      icon: Icons.chat_bubble_outline,
                      label: 'Square',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileSquareScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // More Services Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileServiceScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'More Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // BOCK De-Fi Lite Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/BOCK De-Fi_logo.png',
                      height: 30,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.currency_bitcoin, size: 30);
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'BOCK De-Fi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Lite',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 24),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 24),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}