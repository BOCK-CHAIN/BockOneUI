import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileSoftStakingScreen extends StatefulWidget {
  const MobileSoftStakingScreen({Key? key}) : super(key: key);

  @override
  State<MobileSoftStakingScreen> createState() => _MobileSoftStakingScreenState();
}

class _MobileSoftStakingScreenState extends State<MobileSoftStakingScreen> {
  Timer? _timer;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  
  // Dynamic soft staking data
  List<Map<String, dynamic>> eligibleAssets = [
    {
      'symbol': 'SOL',
      'name': 'Solana',
      'color': Colors.purple,
      'apr': 1.00,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'ADA',
      'name': 'Cardano',
      'color': Colors.blue,
      'apr': 0.50,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'POL',
      'name': 'Polygon',
      'color': Colors.purple.shade700,
      'apr': 0.60,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'BNB',
      'name': 'BNB',
      'color': Colors.orange,
      'apr': 0.15,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'SUI',
      'name': 'Sui',
      'color': Colors.blue.shade600,
      'apr': 1.00,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'ATOM',
      'name': 'Cosmos',
      'color': Colors.purple.shade800,
      'apr': 0.75,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'DOT',
      'name': 'Polkadot',
      'color': Colors.pink,
      'apr': 0.85,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
    {
      'symbol': 'AVAX',
      'name': 'Avalanche',
      'color': Colors.red,
      'apr': 0.45,
      'cumulativeRewards': 0.0,
      'isActive': false,
    },
  ];

  double totalProfit = 0.0;
  bool isActivated = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _updateAPRValues();
        _calculateTotalProfit();
      });
    });
  }

  void _updateAPRValues() {
    final random = Random();
    for (var asset in eligibleAssets) {
      // Small realistic APR fluctuations
      double baseAPR = asset['apr'];
      asset['apr'] = (baseAPR + (random.nextDouble() - 0.5) * 0.1).clamp(0.1, 2.0);
      
      // Update cumulative rewards if active
      if (asset['isActive']) {
        asset['cumulativeRewards'] += (random.nextDouble() * 0.001);
      }
    }
  }

  void _calculateTotalProfit() {
    totalProfit = eligibleAssets
        .where((asset) => asset['isActive'])
        .fold(0.0, (sum, asset) => sum + asset['cumulativeRewards']);
  }

  List<Map<String, dynamic>> get filteredAssets {
    if (searchQuery.isEmpty) {
      return eligibleAssets;
    }
    return eligibleAssets.where((asset) {
      return asset['symbol'].toLowerCase().contains(searchQuery) ||
             asset['name'].toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          'Soft Staking | Earn Staking R...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Text(
              'Soft Staking',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Earn staking rewards from Spot Assets with full flexibility.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            
            // What is Soft Staking Section
            Row(
              children: [
                const Text(
                  'What is Soft Staking',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Total Profit Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Profit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '≈ \$${totalProfit.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Activate Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isActivated = !isActivated;
                    if (isActivated) {
                      // Activate some random assets
                      final random = Random();
                      for (int i = 0; i < eligibleAssets.length; i++) {
                        if (random.nextBool() && i < 3) {
                          eligibleAssets[i]['isActive'] = true;
                        }
                      }
                    } else {
                      // Deactivate all
                      for (var asset in eligibleAssets) {
                        asset['isActive'] = false;
                        asset['cumulativeRewards'] = 0.0;
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActivated ? Colors.green.shade100 : const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: isActivated ? Colors.green.shade700 : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isActivated ? 'Activated ✓' : 'Activate',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Coin',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Eligible Assets Section
            const Text(
              'Eligible Assets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Assets List
            ...filteredAssets.map((asset) => _buildAssetItem(asset)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem(Map<String, dynamic> asset) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Asset Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: asset['color'],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getAssetIcon(asset['symbol']),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Asset Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset['symbol'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Cumulative Rewards',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      asset['cumulativeRewards'] > 0 
                          ? asset['cumulativeRewards'].toStringAsFixed(4)
                          : '--',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // APR and Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${asset['apr'].toStringAsFixed(2)}% APR',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    asset['isActive'] = !asset['isActive'];
                    if (!asset['isActive']) {
                      asset['cumulativeRewards'] = 0.0;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    asset['isActive'] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAssetIcon(String symbol) {
    switch (symbol) {
      case 'SOL':
        return 'S';
      case 'ADA':
        return '₳';
      case 'POL':
        return 'P';
      case 'BNB':
        return 'B';
      case 'SUI':
        return 'S';
      case 'ATOM':
        return 'A';
      case 'DOT':
        return '●';
      case 'AVAX':
        return 'A';
      default:
        return symbol.substring(0, 1);
    }
  }
}