import 'package:flutter/material.dart';

class MobileSimpleEarnScreen extends StatefulWidget {
  const MobileSimpleEarnScreen({Key? key}) : super(key: key);

  @override
  State<MobileSimpleEarnScreen> createState() => _MobileSimpleEarnScreenState();
}

class _MobileSimpleEarnScreenState extends State<MobileSimpleEarnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Simple Earn',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Principal guaranteed, let your idle funds grow!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Auto-Subscribe Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Auto-Subscribe',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 122, 79, 223),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Activate',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Special Offers Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Special Offers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildSpecialOfferCard(
                                  'HOLO', '01D: 16H: 43M', '200%', Colors.cyan),
                              const SizedBox(width: 8),
                              _buildSpecialOfferCard(
                                  'LINEA', '01D: 16H: 43M', '200%', Colors.blue),
                              const SizedBox(width: 8),
                              _buildSpecialOfferCard('OPEN', '01D: 16H: 43M',
                                  '200%', const Color.fromARGB(255, 122, 79, 223)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // AI Rewards Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Share \$300,000 in AI Rewards',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Subscribe to BNB & AI Simple Earn Products',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.card_giftcard,
                                  color: Color.fromARGB(255, 122, 79, 223), size: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.filter_list, color: Colors.grey),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Flexible'),
                    Tab(text: 'Locked'),
                    Tab(text: 'Hot'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCoinList(_getFlexibleCoins()),
            _buildCoinList(_getLockedCoins()),
            _buildCoinList(_getHotCoins()),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOfferCard(
      String title, String time, String percentage, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'APR',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinList(List<CoinData> coins) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Est. APR',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: coins.length,
            itemBuilder: (context, index) {
              final coin = coins[index];
              return _buildCoinTile(coin);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCoinTile(CoinData coin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoinSubscribeScreen(coin: coin),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: coin.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  coin.symbol.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (coin.hasBonus)
                    const Text(
                      'Bonus',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (coin.hasSpecialOffer)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Special Offer',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (coin.isMax)
                      const Text(
                        'Max ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    Text(
                      '${coin.apr}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<CoinData> _getFlexibleCoins() {
    return [
      CoinData('OG', '19.22', Colors.purple, false, false),
      CoinData('HEMI', '0.95', Colors.orange, false, false),
      CoinData('USDC', '7.53', Colors.blue, true, false, isMax: true),
      CoinData('USDT', '28.68', Colors.green, true, true, isMax: true),
    ];
  }

  List<CoinData> _getLockedCoins() {
    return [
      CoinData('BTC', '5.2', Colors.orange, false, false),
      CoinData('ETH', '4.8', Colors.blue, false, false),
      CoinData('BNB', '12.5', Colors.amber, true, false),
    ];
  }

  List<CoinData> _getHotCoins() {
    return [
      CoinData('SOL', '15.3', Colors.purple, false, true),
      CoinData('AVAX', '8.7', Colors.red, false, false),
      CoinData('MATIC', '11.2', Colors.purple, true, false),
    ];
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class CoinData {
  final String symbol;
  final String apr;
  final Color color;
  final bool hasBonus;
  final bool hasSpecialOffer;
  final bool isMax;

  CoinData(
    this.symbol,
    this.apr,
    this.color,
    this.hasBonus,
    this.hasSpecialOffer, {
    this.isMax = false,
  });
}

class CoinSubscribeScreen extends StatefulWidget {
  final CoinData coin;

  const CoinSubscribeScreen({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinSubscribeScreen> createState() => _CoinSubscribeScreenState();
}

class _CoinSubscribeScreenState extends State<CoinSubscribeScreen> {
  String selectedPlan = 'Flexible';
  bool autoSubscribe = false;
  bool agreedToTerms = false;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.coin.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.coin.symbol.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.coin.symbol} Subscribe',
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Selection
                  Row(
                    children: [
                      _buildPlanCard('Flexible', '19.09%', true),
                      const SizedBox(width: 12),
                      _buildPlanCard('90D', '923,541.02%', false),
                      const SizedBox(width: 12),
                      _buildPlanCard('120D', '913,726.1%', false),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Amount Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Minimum 0.01',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: autoSubscribe,
                        onChanged: (value) {
                          setState(() {
                            autoSubscribe = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 122, 79, 223),
                      ),
                      const Text(
                        'Auto-Subscribe',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Amount Input
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Text(
                          '${widget.coin.symbol} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Max',
                          style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Available Balance
                  Row(
                    children: [
                      const Text('Avail (2 sources) 0 OG'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '+ Top up',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Summary Section
                  const Row(
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Product Rules',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Daily Rewards
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Est. Daily Rewards',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '-- ${widget.coin.symbol}',
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'APR: ${widget.coin.apr}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Disclaimer
                  const Text(
                    '*APR does not represent actual or predicted returns in fiat currency. Please refer to the Product Rules for reward mechanisms.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Bottom Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value ?? false;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 122, 79, 223),
                    ),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I have read and agreed to ',
                          style: TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'BOCK De-Fi Simple Earn Service Agreement',
                              style: TextStyle(
                                color: Color.fromARGB(255, 122, 79, 223),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: agreedToTerms ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          agreedToTerms ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: agreedToTerms ? Colors.black : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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

  Widget _buildPlanCard(String title, String percentage, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPlan = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                percentage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? Colors.black : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}