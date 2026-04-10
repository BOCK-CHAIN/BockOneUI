import 'package:flutter/material.dart';

class WalletDiscoverScreen extends StatefulWidget {
  const WalletDiscoverScreen({Key? key}) : super(key: key);

  @override
  State<WalletDiscoverScreen> createState() => _WalletDiscoverScreenState();
}

class _WalletDiscoverScreenState extends State<WalletDiscoverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Airdrops'),
                  Tab(text: 'Exclusive TGE'),
                  Tab(text: 'Booster'),
                  Tab(text: 'DApps'),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for dApps or enter a URL',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAirdropsTab(),
                  _buildExclusiveTGETab(),
                  _buildBoosterTab(),
                  _buildDAppsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Airdrops Tab
  Widget _buildAirdropsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Rewards Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildRewardCard('My Total Rewards', '₹0'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRewardCard('Joined', '0'),
                ),
              ],
            ),
          ),

          // Exclusive Airdrops Section
          _buildSectionHeader('Exclusive Airdrops'),

          _buildAirdropCard(
            title: 'Supply USDG to share \$300,000 USDG Rewards with Jupiter',
            participants: '181.2K+',
            deadline: '2025-10-11 04:29',
            reward: '\$300,000 USDG',
            icon: '',
          ),

          _buildAirdropCard(
            title: 'Deposit USDC to share 5.2 Million SPK Rewards with Spark',
            participants: '273.7K+',
            deadline: '2025-11-11 04:29',
            reward: '5.2M SPK',
            icon: '',
          ),

          _buildAirdropCard(
            title: 'Grab a share of \$1,400,000 Rewards in Sei DeFi Season 4 !',
            participants: '143.6K+',
            deadline: '2025-10-04 05:29',
            reward: '\$1,400,000 SEI',
            icon: '',
          ),
        ],
      ),
    );
  }

  // Exclusive TGE Tab
  Widget _buildExclusiveTGETab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Ended',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildTGECard(
            title: "River's Exclusive TGE",
            endDate: 'Ended on 2025-09-22',
            totalSale: 'Total Sale 2,100,000 RIVER',
            icon: '',
          ),
          _buildTGECard(
            title: "JoJoWorld's Exclusive TGE",
            endDate: 'Ended on 2025-09-19',
            totalSale: 'Total Sale 16,000,000 JOJO',
            icon: '',
          ),
          _buildTGECard(
            title: "Starpower's Exclusive TGE",
            endDate: 'Ended on 2025-09-06',
            totalSale: 'Total Sale 12,500,000 STAR',
            icon: '',
          ),
          _buildTGECard(
            title: "Hyperbot's Exclusive TGE",
            endDate: 'Ended on 2025-09-03',
            totalSale: 'Total Sale 20,000,000 BOT',
            icon: '',
          ),
        ],
      ),
    );
  }

  // Booster Tab
  Widget _buildBoosterTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Ongoing',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildBoosterCard(
            title: 'Codatta Booster Program Season 3 Week 4',
            timeLeft: 'Ends in 00h : 09m : 54s',
            reward: '50,000,000 XNY',
            icon: '',
          ),
          _buildBoosterCard(
            title: 'Pieverse Booster Program Phase 2',
            timeLeft: 'Ends in 3d : 02h : 09m',
            reward: '7,500,000 PIEVERSE',
            icon: '',
          ),
          _buildBoosterCard(
            title: 'Reveel Booster Program Phase 4',
            timeLeft: 'Ends in 3d : 09h : 09m',
            reward: '5,000,000 REVA',
            icon: '',
          ),
          _buildBoosterCard(
            title: 'BAS Booster Program Season 3 Week 2',
            timeLeft: 'Ends in 4d : 00h : 09m',
            reward: '8,000,000 BAS',
            icon: '',
          ),
        ],
      ),
    );
  }

  // DApps Tab
  Widget _buildDAppsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Common Tools
          _buildSectionHeader('Common Tools'),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Recent', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                Text('Favorites', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 16),
                Text('DEX', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 16),
                Text('Staking & Restaking', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          // Trending DApps
          _buildSectionHeader('Trending DApps'),
          _buildDAppItem(
            name: 'ASTER Airdrop Checker',
            description: 'The next-gen Perp DEX Built for Everyone',
            icon: 'A',
          ),
          _buildDAppItem(
            name: 'PancakeSwap V3',
            description: 'Decentralized exchange on BNB Smart Chain',
            icon: 'P',
          ),
          _buildDAppItem(
            name: 'Four.meme',
            description: 'The premier meme fair launch platform',
            icon: 'F',
          ),

          // Earn Points
          _buildSectionHeader('Earn Points'),
          _buildDAppItem(
            name: 'EigenLayer',
            description: 'Ethereum staking protocol with re-staking',
            icon: 'E',
          ),
          _buildDAppItem(
            name: 'Ether.fi',
            description: 'Decentralized staking protocol for Ethereum',
            icon: 'E',
          ),
          _buildDAppItem(
            name: 'Renzo',
            description: 'Platform for real estate tokenization',
            icon: 'R',
          ),

          // BNB Chain Ecosystem
          _buildSectionHeader('BNB Chain Ecosystem'),
          _buildDAppItem(
            name: 'PancakeSwap V3',
            description: 'Decentralized exchange on BNB Smart Chain',
            icon: 'P',
          ),
          _buildDAppItem(
            name: 'Four.meme',
            description: 'The premier meme fair launch platform',
            icon: 'F',
          ),
          _buildDAppItem(
            name: 'Aster',
            description: 'The next-gen Perp DEX Built for Everyone',
            icon: 'A',
          ),

          // Tools
          _buildSectionHeader('Tools'),
          _buildDAppItem(
            name: 'Revoke.cash',
            description: 'Revoke.cash manages and revokes crypto approvals',
            icon: 'R',
          ),
          _buildDAppItem(
            name: 'BeraHub',
            description: "Berachain's DEX",
            icon: 'B',
          ),
          _buildDAppItem(
            name: 'Ave.ai',
            description: 'AI-driven cryptocurrency trading and analytics',
            icon: 'A',
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildAirdropCard({
    required String title,
    required String participants,
    required String deadline,
    required String reward,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(participants, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(deadline, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.card_giftcard, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    reward,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Join Now', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTGECard({
    required String title,
    required String endDate,
    required String totalSale,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      endDate,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    totalSale,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoosterCard({
    required String title,
    required String timeLeft,
    required String reward,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              timeLeft,
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.card_giftcard, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    reward,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDAppItem({
    required String name,
    required String description,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}