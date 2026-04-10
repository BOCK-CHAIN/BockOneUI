import 'package:flutter/material.dart';

class MobileFutureMastersScreen extends StatefulWidget {
  const MobileFutureMastersScreen({super.key});

  @override
  State<MobileFutureMastersScreen> createState() => _MobileFutureMastersScreenState();
}

class _MobileFutureMastersScreenState extends State<MobileFutureMastersScreen> 
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _rankingTabController;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _rankingTabController = TabController(length: 3, vsync: this);
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens.addAll([
      const ArenaTab(),
      const BattlefieldTab(),
      RankingTab(tabController: _rankingTabController),
      const RegularTasksTab(),
    ]);
  }

  @override
  void dispose() {
    _rankingTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: isTablet ? 80 : 70,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 10,
              vertical: isTablet ? 15 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Arena', isTablet),
                _buildNavItem(1, Icons.gps_fixed_outlined, Icons.gps_fixed, 'Battlefields', isTablet),
                _buildNavItem(2, Icons.people_outline, Icons.people, 'Ranking', isTablet),
                _buildNavItem(3, Icons.assignment_outlined, Icons.assignment, 'Regular Tasks', isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, String label, bool isTablet) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? filledIcon : outlinedIcon,
            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey,
            size: isTablet ? 26 : 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey,
              fontSize: isTablet ? 11 : 9,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Arena Tab - Main competition interface
class ArenaTab extends StatelessWidget {
  const ArenaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'BOCK De-Fi Futures Arena',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Golden Background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 150, 107, 250),
                    const Color.fromARGB(255, 122, 79, 223).withOpacity(0.8),
                    const Color.fromARGB(255, 54, 46, 73),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 32 : 24),
                    child: Column(
                      children: [
                        // Round Info
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Round 2: 2025/09/18 00:00 - 2025/10/15 23:59 UTC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Title
                        Text(
                          'Futures Masters Arena',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 36 : 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Prize Pool
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                            children: [
                              const TextSpan(
                                text: 'Compete for a Multi-Token Prize Pool Worth Up to ',
                                style: TextStyle(color: Colors.white),
                              ),
                              const TextSpan(
                                text: '1,000,000',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 122, 79, 223),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' USDT!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Countdown Timer
                        const Text(
                          'Ending in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTimeUnit('19', 'days', isTablet),
                            _buildTimeSeparator(),
                            _buildTimeUnit('05', 'hours', isTablet),
                            _buildTimeSeparator(),
                            _buildTimeUnit('32', 'mins', isTablet),
                            _buildTimeSeparator(),
                            _buildTimeUnit('03', 'secs', isTablet),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Join Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              'Join Now',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Participation Requirements
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Participation Requirements',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // How to Participate Section
            Padding(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Participate',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildParticipationStep(
                    '1',
                    'Join the Futures Masters Arena',
                    'Click "Join Now" to participate in the Futures Masters Arena.',
                    isTablet,
                  ),
                  
                  _buildParticipationStep(
                    '2',
                    'Collect Points',
                    'Complete the Regular Tasks or join battles in Battlefields to collect points.',
                    isTablet,
                  ),
                  
                  _buildParticipationStep(
                    '3',
                    'Win Rewards',
                    'Top participants share the prize pool based on their Ranking.',
                    isTablet,
                  ),
                ],
              ),
            ),
            
            // Prize Pool Section
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prize Pool',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Total Prize Pool Worth up to',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  Text(
                    '\$1,000,000',
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 122, 79, 223),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    '5 Tokens:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      _buildTokenIcon(Colors.orange),
                      _buildTokenIcon(Colors.purple),
                      _buildTokenIcon(Colors.blue),
                      _buildTokenIcon(Colors.pink),
                      _buildTokenIcon(Colors.green),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    '8,000,000 HOME / 8,000,000 HUMA / 1,500,000 DODO / 300,000 ERA / 300,000 PROVE',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Share Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 122, 79, 223),
                    side: const BorderSide(color: Color.fromARGB(255, 122, 79, 223)),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Terms & Conditions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    '• All Promotions are only available to users who are eligible for BOCK De-Fi Futures trading and may not be available or may be restricted in certain jurisdictions. Rewards to certain users depending on legal and regulatory requirements.',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    '• Users are responsible for informing themselves about and observing any restrictions and/or requirements imposed with respect to the access to and use of BOCK De-Fi Futures trading services in each country/region from which the services are accessed.',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label, bool isTablet) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 32 : 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParticipationStep(String step, String title, String description, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isTablet ? 32 : 28,
            height: isTablet ? 32 : 28,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenIcon(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Battlefield Tab - Trading challenges
class BattlefieldTab extends StatefulWidget {
  const BattlefieldTab({super.key});

  @override
  State<BattlefieldTab> createState() => _BattlefieldTabState();
}

class _BattlefieldTabState extends State<BattlefieldTab> {
  String selectedFilter = 'Ongoing';
  
  final List<BattleChallenge> challenges = [
    BattleChallenge(
      title: 'MIRA Trading Challenge',
      participants: 3540,
      prizePool: 'Up to 500,000 MIRA',
      timeLeft: '9D : 05 : 30 : 45',
      status: 'NEW',
      tokenColor: Colors.white,
      isNew: true,
    ),
    BattleChallenge(
      title: 'BTC Futures Battle',
      participants: 2180,
      prizePool: 'Up to 100,000 USDT',
      timeLeft: '5D : 12 : 45 : 23',
      status: 'ONGOING',
      tokenColor: const Color.fromARGB(255, 122, 79, 223),
      isNew: false,
    ),
    BattleChallenge(
      title: 'ETH Masters Challenge',
      participants: 1890,
      prizePool: 'Up to 75,000 USDT',
      timeLeft: '3D : 08 : 15 : 12',
      status: 'ONGOING',
      tokenColor: Colors.blue,
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'BOCK De-Fi Futures Arena',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Battlefields',
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Participants can join a battle by clicking the "Join" button on its activity page. They will be ranked based on ROI, PnL, or Trading Volume. The top 100 eligible users will win the daily points and share the battle\'s prize pool.',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
            child: Row(
              children: [
                _buildFilterTab('Ongoing 11', 'Ongoing', isTablet),
                const SizedBox(width: 20),
                _buildFilterTab('Ended 0', 'Ended', isTablet),
                const SizedBox(width: 20),
                _buildFilterTab('Upcoming 0', 'Upcoming', isTablet),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Challenges List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return _buildChallengeCard(challenges[index], isTablet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, String value, bool isTablet) {
    final isSelected = selectedFilter == value;
    
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isTablet ? 16 : 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildChallengeCard(BattleChallenge challenge, bool isTablet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Challenge Visual
          Container(
            height: isTablet ? 200 : 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
              ),
            ),
            child: Stack(
              children: [
                // Decorative elements
                Positioned.fill(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30,
                        right: 30,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 122, 79, 223),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 40,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 60,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 122, 79, 223),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main Token/Logo
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Golden platform
                      Container(
                        width: isTablet ? 120 : 100,
                        height: isTablet ? 60 : 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                              const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Token circle
                      Container(
                        width: isTablet ? 80 : 70,
                        height: isTablet ? 80 : 70,
                        decoration: BoxDecoration(
                          color: challenge.tokenColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            challenge.title.substring(0, 1),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isTablet ? 32 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // NEW badge
                if (challenge.isNew)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Challenge Details
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Total Participants',
                        challenge.participants.toString(),
                        isTablet,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Total Prize Pool',
                        challenge.prizePool,
                        isTablet,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                _buildDetailItem(
                  'Ends In',
                  challenge.timeLeft,
                  isTablet,
                  isCountdown: true,
                ),
                
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Visit',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isTablet, {bool isCountdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 10,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: isCountdown ? const Color.fromARGB(255, 122, 79, 223) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Ranking Tab with three sub-tabs
class RankingTab extends StatelessWidget {
  final TabController tabController;
  
  const RankingTab({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'BOCK De-Fi Futures Arena',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color.fromARGB(255, 122, 79, 223),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Masters ranking'),
            Tab(text: 'Top Traders'),
            Tab(text: 'Hall of Fame'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Description and Links
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The top 100 participants will be ranked based on the points they earn from Battlefields and Regular Tasks. Rewards for each round will be distributed to eligible users according to their rankings.',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'View Prize Pool Allocation',
                        style: TextStyle(
                          color: Color.fromARGB(255, 122, 79, 223),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'View Ranking History',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '*Data is updated hourly, last updated: 2025-09-26 17:38:52 (UTC)',
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildRankingList(isTablet),
                _buildRankingList(isTablet),
                _buildRankingList(isTablet),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList(bool isTablet) {
    return Column(
      children: [
        // Top 3 Podium
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumUser(2, 'xpl', '428', isTablet),
              _buildPodiumUser(1, 'User-cef4d', '983', isTablet),
              _buildPodiumUser(3, 'Bad', '422', isTablet),
            ],
          ),
        ),
        
        // Rankings List Header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Rank / User Nickname',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                'Points in this round',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Rankings List
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              final users = [
                {'name': 'User-cef4d', 'points': '983', 'avatar': 'U'},
                {'name': 'xpl', 'points': '428', 'avatar': 'X'},
                {'name': 'BAD', 'points': '422', 'avatar': 'B'},
                {'name': 'CryptoMaster99', 'points': '387', 'avatar': 'C'},
                {'name': 'TradingPro', 'points': '345', 'avatar': 'T'},
                {'name': 'FuturesKing', 'points': '298', 'avatar': 'F'},
                {'name': 'MarketWhale', 'points': '276', 'avatar': 'M'},
                {'name': 'BullRun2025', 'points': '254', 'avatar': 'B'},
                {'name': 'DiamondHands', 'points': '223', 'avatar': 'D'},
                {'name': 'MoonTrader', 'points': '198', 'avatar': 'M'},
              ];

              final user = users[index];
              final rank = index + 1;
              
              return _buildRankingItem(
                rank,
                user['name']!,
                user['points']!,
                user['avatar']!,
                isTablet,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumUser(int rank, String name, String points, bool isTablet) {
    Color rankColor;
    IconData rankIcon;
    
    switch (rank) {
      case 1:
        rankColor = const Color.fromARGB(255, 122, 79, 223);
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0);
        rankIcon = Icons.military_tech;
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32);
        rankIcon = Icons.workspace_premium;
        break;
      default:
        rankColor = Colors.grey;
        rankIcon = Icons.person;
    }

    return Column(
      children: [
        Container(
          width: isTablet ? 80 : 70,
          height: isTablet ? 80 : 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: rankColor,
              width: rank == 1 ? 4 : 3,
            ),
          ),
          child: CircleAvatar(
            radius: isTablet ? 36 : 32,
            backgroundColor: Colors.grey[200],
            child: Text(
              name.isNotEmpty ? name.substring(0, 1) : '?',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: rankColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            rankIcon,
            color: Colors.white,
            size: isTablet ? 16 : 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name.length > 10 ? '${name.substring(0, 10)}...' : name,
          style: TextStyle(
            fontSize: isTablet ? 12 : 10,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Color.fromARGB(255, 122, 79, 223),
              size: 14,
            ),
            const SizedBox(width: 2),
            Text(
              points,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 122, 79, 223),
              ),
            ),
          ],
        ),
        Text(
          'Points in this round',
          style: TextStyle(
            fontSize: isTablet ? 10 : 8,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRankingItem(int rank, String name, String points, String avatar, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: isTablet ? 40 : 32,
            height: isTablet ? 40 : 32,
            decoration: BoxDecoration(
              color: rank <= 3 
                  ? _getRankColor(rank).withOpacity(0.2)
                  : Colors.grey[100],
              shape: BoxShape.circle,
              border: rank <= 3
                  ? Border.all(color: _getRankColor(rank), width: 2)
                  : null,
            ),
            child: Center(
              child: rank <= 3
                  ? Icon(
                      _getRankIcon(rank),
                      color: _getRankColor(rank),
                      size: isTablet ? 20 : 16,
                    )
                  : Text(
                      '$rank',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // User Avatar
          CircleAvatar(
            radius: isTablet ? 20 : 16,
            backgroundColor: Colors.grey[200],
            child: Text(
              avatar,
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // User Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.length > 20 ? '${name.substring(0, 20)}...' : name,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (rank <= 3)
                  Text(
                    'Top ${rank == 1 ? 'Champion' : rank == 2 ? 'Runner-up' : 'Third'}',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: _getRankColor(rank),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          
          // Points
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Color.fromARGB(255, 122, 79, 223),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                points,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 122, 79, 223),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color.fromARGB(255, 122, 79, 223); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.military_tech;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.person;
    }
  }
}

// Regular Tasks Tab
class RegularTasksTab extends StatelessWidget {
  const RegularTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final tasks = [
      RegularTask(
        title: 'First-Time Deposit',
        description: 'Fund your futures wallet for the first time with ≥ 100 USDT in a single transaction',
        points: 20,
        icon: Icons.account_balance_wallet,
        buttonText: 'Deposit Now',
        isCompleted: false,
      ),
      RegularTask(
        title: 'First-time futures trade',
        description: 'Complete the first futures trade with a trading volume > 0',
        points: 30,
        icon: Icons.trending_up,
        buttonText: 'Trade Now',
        isCompleted: false,
      ),
      RegularTask(
        title: 'Participated in More Battles',
        description: 'Battles you\'ve joined: 0',
        points: 35,
        icon: Icons.emoji_events,
        buttonText: 'Join Now',
        isCompleted: false,
        hasProgressSteps: true,
        progressSteps: [
          {'battles': '3 Battles', 'points': '5 Points'},
          {'battles': '5 Battles', 'points': '10 Points'},
          {'battles': '10 Battles', 'points': '20 Points'},
        ],
        currentBattles: 0,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'BOCK De-Fi Futures Arena',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants can complete the one-off tasks below to earn points, which will be distributed approximately 5 minutes after task completion.',
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 24),
            
            ...tasks.map((task) => _buildTaskCard(task, isTablet)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(RegularTask task, bool isTablet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Task Icon
              Container(
                width: isTablet ? 50 : 40,
                height: isTablet ? 50 : 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  task.icon,
                  color: const Color.fromARGB(255, 122, 79, 223),
                  size: isTablet ? 24 : 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Task Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Points Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 122, 79, 223),
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '×${task.points}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        fontSize: isTablet ? 12 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (task.hasProgressSteps) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${task.currentBattles} Battles',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...task.progressSteps!.asMap().entries.map((entry) {
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            step['battles']!,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            step['points']!,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                task.buttonText,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class BattleChallenge {
  final String title;
  final int participants;
  final String prizePool;
  final String timeLeft;
  final String status;
  final Color tokenColor;
  final bool isNew;

  BattleChallenge({
    required this.title,
    required this.participants,
    required this.prizePool,
    required this.timeLeft,
    required this.status,
    required this.tokenColor,
    required this.isNew,
  });
}

class RegularTask {
  final String title;
  final String description;
  final int points;
  final IconData icon;
  final String buttonText;
  final bool isCompleted;
  final bool hasProgressSteps;
  final List<Map<String, String>>? progressSteps;
  final int currentBattles;

  RegularTask({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.buttonText,
    required this.isCompleted,
    this.hasProgressSteps = false,
    this.progressSteps,
    this.currentBattles = 0,
  });
}