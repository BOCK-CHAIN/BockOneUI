import 'package:flutter/material.dart';

class MobileAlphaEventsScreen extends StatefulWidget {
  const MobileAlphaEventsScreen({Key? key}) : super(key: key);

  @override
  State<MobileAlphaEventsScreen> createState() => _MobileAlphaEventsScreenState();
}

class _MobileAlphaEventsScreenState extends State<MobileAlphaEventsScreen> {
  bool _showBalancePointsRule = false;
  bool _showVolumePointsRule = false;
  bool _showTaskPointsRule = false;
  bool _showDailyBreakdown = false;
  
  // Expandable date entries
  Map<String, bool> _expandedDates = {
    '2025-09-23': false,
    '2025-09-22': false,
    '2025-09-21': false,
    '2025-09-20': false,
    '2025-09-19': false,
  };

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
        title: const Text(
          'Alpha Events',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with points and UID
            _buildHeaderSection(),
            
            const SizedBox(height: 32),
            
            // Navigation icons
            _buildNavigationIcons(),
            
            const SizedBox(height: 32),
            
            // What are Alpha Points section
            if (!_showDailyBreakdown) _buildAlphaPointsSection(),
            
            // Daily Points Breakdown section
            if (_showDailyBreakdown) _buildDailyBreakdownSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Total Points',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Text(
              'UID 1158450833',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '0',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavigationIcon(
          Icons.air_outlined,
          'Airdrop',
          () {},
        ),
        _buildNavigationIcon(
          Icons.bar_chart,
          'Competition',
          () {},
        ),
        _buildNavigationIcon(
          Icons.monetization_on_outlined,
          'Earn',
          () {},
        ),
        _buildNavigationIcon(
          Icons.token_outlined,
          'TGE',
          () {},
        ),
        _buildNavigationIcon(
          Icons.rocket_launch_outlined,
          'Booster',
          () {},
        ),
      ],
    );
  }

  Widget _buildNavigationIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlphaPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What are Alpha Points?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'BOCK De-Fi Alpha Points is a scoring system designed to evaluate user activity within the BOCK De-Fi Alpha and BOCK De-Fi Wallet ecosystem which determines your eligibility for campaigns, such as Token Generation Event (TGE) participation and Alpha token airdrops. BOCK De-Fi Alpha Points are calculated daily based on the sum of your assets balance and Alpha token purchase volume on BOCK De-Fi exchange and BOCK De-Fi Wallet (Keyless address). Please note that selling Alpha tokens do not contribute to Alpha Points at the current stage. The Alpha Points are a cumulative sum of daily points combining Balance Points and Volume Point over the past 15 days.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Learn more in FAQs',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 122, 79, 223),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 32),
        
        // Dropdown sections
        _buildDropdownSection(
          'Rule of Balance Points',
          _showBalancePointsRule,
          () => setState(() => _showBalancePointsRule = !_showBalancePointsRule),
          'Balance Points are calculated based on your daily Alpha token balance in BOCK De-Fi exchange and BOCK De-Fi Wallet (Keyless address). The more Alpha tokens you hold, the higher your Balance Points.',
        ),
        
        _buildDropdownSection(
          'Rule of Volume Points',
          _showVolumePointsRule,
          () => setState(() => _showVolumePointsRule = !_showVolumePointsRule),
          'Volume Points are earned through Alpha token trading activities. Each purchase contributes to your Volume Points, while selling does not currently contribute to the point calculation.',
        ),
        
        _buildDropdownSection(
          'Rule of Task Points',
          _showTaskPointsRule,
          () => setState(() => _showTaskPointsRule = !_showTaskPointsRule),
          'Task Points are earned by completing specific activities and challenges within the BOCK De-Fi Alpha ecosystem. These tasks may include social media engagement, referrals, and other promotional activities.',
        ),
        
        const SizedBox(height: 24),
        
        // Daily breakdown button
        GestureDetector(
          onTap: () => setState(() => _showDailyBreakdown = true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'View Daily Points Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyBreakdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _showDailyBreakdown = false),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            const SizedBox(width: 16),
            const Text(
              'Daily Points Breakdown',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          '09/09/2025 - 09/23/2025 The previous day\'s data will be updated before 11:30 UTC+5.5 on the current day.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Today section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This trading volume is for reference only; the actual data will be updated on 2025-09-26 at 11:30 UTC+5.5',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trading Volume',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    '0',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Historical dates
        ..._expandedDates.keys.map((date) => _buildDateEntry(date)),
      ],
    );
  }

  Widget _buildDateEntry(String date) {
    bool isExpanded = _expandedDates[date] ?? false;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedDates[date] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      '0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        if (isExpanded) ...[
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildBreakdownRow('Balance', '\$0.00'),
                _buildBreakdownRow('Balance points', '0', isPoints: true),
                _buildBreakdownRow('Volume', '\$0.00'),
                _buildBreakdownRow('Volume points', '0', isPoints: true),
                _buildBreakdownRow('Task points', '0', isPoints: true),
              ],
            ),
          ),
        ] else ...[
          const Divider(color: Colors.grey, height: 1),
        ],
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isPoints = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPoints ? Colors.teal : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection(
    String title,
    bool isExpanded,
    VoidCallback onTap,
    String content,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        
        if (isExpanded) ...[
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ] else ...[
          const Divider(color: Colors.grey, height: 1),
        ],
        
        const SizedBox(height: 8),
      ],
    );
  }
}