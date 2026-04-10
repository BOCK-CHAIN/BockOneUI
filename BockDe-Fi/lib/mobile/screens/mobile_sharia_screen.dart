import 'package:flutter/material.dart';

class MobileShariaScreen extends StatefulWidget {
  const MobileShariaScreen({Key? key}) : super(key: key);

  @override
  State<MobileShariaScreen> createState() => _MobileShariaScreenState();
}

class _MobileShariaScreenState extends State<MobileShariaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isFavorited = false;
  String _searchQuery = '';

  final List<ShariaAsset> _allAssets = [
    ShariaAsset(
      symbol: 'BNB',
      name: 'BOCK De-Fi Coin',
      yield: '0.16% ~ 0.32%',
      color: const Color(0xFFF3BA2F),
      icon: Icons.currency_bitcoin,
      isFavorited: false,
    ),
    ShariaAsset(
      symbol: 'ETH',
      name: 'Ethereum',
      yield: '2.79%',
      color: const Color(0xFF627EEA),
      icon: Icons.currency_bitcoin,
      isFavorited: true,
    ),
    ShariaAsset(
      symbol: 'SOL',
      name: 'Solana',
      yield: '5.43%',
      color: const Color(0xFF9945FF),
      icon: Icons.currency_bitcoin,
      isFavorited: false,
    ),
  ];

  List<ShariaAsset> get _filteredAssets {
    if (_searchQuery.isEmpty) {
      return _tabController.index == 0
          ? _allAssets.where((asset) => asset.isFavorited).toList()
          : _allAssets;
    }
    
    final filtered = _allAssets.where((asset) =>
        asset.symbol.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        asset.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    return _tabController.index == 0
        ? filtered.where((asset) => asset.isFavorited).toList()
        : filtered;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
        title: const Text(
          'Sharia Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('Share'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.black54,
                    ),
                    const SizedBox(width: 12),
                    Text(_isFavorited ? 'Unfavorite' : 'Favorite'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('Refresh'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'feedback',
                child: Row(
                  children: [
                    Icon(Icons.feedback_outlined, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('Feedback'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: 'Earn yields that are certified Sharia\n'),
                                TextSpan(text: 'Compliant, tailored to all Sharia compliant\n'),
                                TextSpan(text: 'investors. '),
                                TextSpan(
                                  text: 'View More',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 122, 79, 223),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildShariaIcon(),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {});
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: const Color.fromARGB(255, 122, 79, 223),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Match My Assets'),
                Tab(text: 'All Assets'),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Assets List
          Expanded(
            child: _filteredAssets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAssets.length,
                    itemBuilder: (context, index) {
                      return _buildAssetCard(_filteredAssets[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShariaIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Crescent moon
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF6B7280),
              shape: BoxShape.circle,
            ),
          ),
          // Star
          Positioned(
            top: 20,
            right: 25,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 122, 79, 223),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
          // White crescent cutout effect
          Positioned(
            left: 30,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(ShariaAsset asset) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Asset Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: asset.color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              asset.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Asset Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.symbol,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (asset.name.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    asset.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Yield Info
          Row(
            children: [
              Text(
                asset.yield,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              if (asset.symbol == 'BNB')
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[500],
                  size: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _tabController.index == 0
                ? 'No matching assets found'
                : 'No assets available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'share':
        _showShareDialog();
        break;
      case 'favorite':
        setState(() {
          _isFavorited = !_isFavorited;
        });
        _showSnackBar(_isFavorited ? 'Added to favorites' : 'Removed from favorites');
        break;
      case 'refresh':
        _refreshData();
        break;
      case 'feedback':
        _showFeedbackDialog();
        break;
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Sharia Products'),
          content: const Text('Share this screen with others to help them discover Sharia-compliant investment options.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar('Shared successfully');
              },
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your thoughts about Sharia Products...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar('Feedback sent successfully');
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _refreshData() {
    _showSnackBar('Refreshing data...');
    // Simulate refresh delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        // Update yields with random variations
        for (var asset in _allAssets) {
          if (asset.symbol == 'BNB') {
            asset.yield = '0.${(15 + (DateTime.now().millisecond % 20))}% ~ 0.${(30 + (DateTime.now().millisecond % 15))}%';
          } else if (asset.symbol == 'ETH') {
            asset.yield = '${2 + (DateTime.now().millisecond % 2)}.${70 + (DateTime.now().millisecond % 30)}%';
          } else if (asset.symbol == 'SOL') {
            asset.yield = '${5 + (DateTime.now().millisecond % 2)}.${40 + (DateTime.now().millisecond % 60)}%';
          }
        }
      });
      _showSnackBar('Data refreshed');
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class ShariaAsset {
  String symbol;
  String name;
  String yield;
  Color color;
  IconData icon;
  bool isFavorited;

  ShariaAsset({
    required this.symbol,
    required this.name,
    required this.yield,
    required this.color,
    required this.icon,
    required this.isFavorited,
  });
}