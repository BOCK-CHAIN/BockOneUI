import 'package:flutter/material.dart';

class MobileCustomerServiceScreen extends StatefulWidget {
  const MobileCustomerServiceScreen({Key? key}) : super(key: key);

  @override
  State<MobileCustomerServiceScreen> createState() =>
      _MobileCustomerServiceScreenState();
}

class _MobileCustomerServiceScreenState
    extends State<MobileCustomerServiceScreen> {
  bool _showFAQ = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),
            
            // Main Content
            Expanded(
              child: _showFAQ ? _buildFAQView(size) : _buildMainView(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_showFAQ) {
                setState(() => _showFAQ = false);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.arrow_back, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'BOCK De-Fi Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brightness_4_outlined, size: 24),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.language, size: 24),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, size: 24),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 122, 79, 223), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'My account verification failed',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Update Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.campaign_outlined, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Update on BSC Trading Competition Volu...',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Alpha Points Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Discover Alpha Points and Join Air...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.campaign,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Want to learn what BOCK De-Fi Alpha Points are, how to earn them, and how they\'re calculated?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Click here to learn more',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // You might be looking for
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'You might be looking for',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showFAQ = true),
                  child: Icon(Icons.refresh, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildSuggestionItem(
            'Complete October\'s Challenge to Unlock Your Share of 150,000 NXPC!',
          ),
          _buildSuggestionItem('Deposit Crypto to BOCK De-Fi'),
          _buildSuggestionItem(
            'Crypto deposit from the external platform to BOCK De-Fi not credited',
          ),
          _buildSuggestionItem('APP Settings'),

          const SizedBox(height: 24),

          // Self Service
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Self Service',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.refresh, color: Colors.grey.shade600),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Self Service Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildServiceCard(
                    icon: Icons.person_off_outlined,
                    title: 'Disable Account',
                    subtitle: 'Request to manually disable account',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildServiceCard(
                    icon: Icons.people_outline,
                    title: 'Lift P2P Suspension',
                    subtitle: 'Review inappropriate P2P trade suspensions.',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFAQView(Size size) {
    return Column(
      children: [
        // View All Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // FAQ Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'FAQ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // FAQ List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFAQItem('TOP FAQ 🔥', true),
              _buildFAQItem('Account Function', false),
              _buildFAQItem('P2P Trading', false),
              _buildFAQItem('Crypto Deposit', false),
              _buildFAQItem('Crypto Withdrawal', false),
              _buildFAQItem('Buy/Sell Crypto (Fiat)', false),
              _buildFAQItem('Spot Trading', false),
              _buildFAQItem('Futures Trading', false),
              _buildFAQItem('Web3 Wallet', false),
              _buildFAQItem('News / Announcement', false),
              _buildFAQItem('BOCK De-Fi Earn', false),
              _buildFAQItem('BOCK De-Fi Pay', false),
              const SizedBox(height: 20),
              _buildBottomButton(
                icon: Icons.edit_outlined,
                text: 'Product Feedback & Suggestions',
              ),
              const SizedBox(height: 12),
              _buildBottomButton(
                icon: Icons.headset_mic_outlined,
                text: 'Get Support',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade800,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.grey.shade700),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String title, bool hasEmoji) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_drop_down,
            color: Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}