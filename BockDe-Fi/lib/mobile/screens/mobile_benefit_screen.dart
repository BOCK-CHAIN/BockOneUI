import 'package:flutter/material.dart';

class MobileBenefitScreen extends StatefulWidget {
  const MobileBenefitScreen({Key? key}) : super(key: key);

  @override
  State<MobileBenefitScreen> createState() => _MobileBenefitScreenState();
}

class _MobileBenefitScreenState extends State<MobileBenefitScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _tradingTabController;
  late TabController _spotPromotionsTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);
    _tradingTabController = TabController(length: 6, vsync: this);
    _spotPromotionsTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _tradingTabController.dispose();
    _spotPromotionsTabController.dispose();
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
        title: const Text(
          'Fees & Transactions Overview',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My Account Section
            _buildMyAccountSection(),
            
            const SizedBox(height: 20),
            
            // Fee Rate Section with Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Fee Rate',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Invite Friends',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _mainTabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Trading'),
                  Tab(text: 'Spot Promotions'),
                  Tab(text: 'Liquidity Program'),
                ],
              ),
            ),
            SizedBox(
              height: 800,
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  _buildTradingTab(),
                  _buildSpotPromotionsTab(),
                  _buildLiquidityProgramTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyAccountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'My Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color.fromARGB(255, 122, 79, 223)!),
                ),
                child: const Text(
                  'Regular',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BNB Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24H Withdrawal Limit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          '8,000,000.00 USDT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Maker/Taker Fee Rate',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spot',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '0.07500% / 0.07500%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'USD⊗-M Futures',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '0.01800% / 0.04500%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Option',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '0.02400% / 0.02400%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COIN-M Futures',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '0.02000% / 0.05000%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[50]!, Colors.orange[50]!],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 122, 79, 223),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upgrade to VIP1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Following conditions can increase the VIP level',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: Colors.grey[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Discover exclusive VIP Growth Program benefits!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'VIP Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Trader Program',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                        indicatorWeight: 2,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Spot'),
                          Tab(text: 'Futures'),
                          Tab(text: 'Option'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: 0,
                                        strokeWidth: 8,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 122, 79, 223)),
                                      ),
                                    ),
                                    const Text(
                                      '0%',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  '0 / 1,000,000 USD',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '30D Trade Volume',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            '+',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: 0,
                                        strokeWidth: 8,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 122, 79, 223)),
                                      ),
                                    ),
                                    const Text(
                                      '0%',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  '0.00 / 25',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'BNB Requirement',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingTab() {
    return Column(
      children: [
        Container(
          color: Colors.grey[100],
          child: TabBar(
            controller: _tradingTabController,
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 122, 79, 223),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Spot & Margin'),
              Tab(text: 'USD⊗-M Futures'),
              Tab(text: 'COIN-M Futures'),
              Tab(text: 'Options'),
              Tab(text: 'P2P'),
              Tab(text: 'Fiat'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tradingTabController,
            children: [
              _buildSpotAndMarginContent(),
              _buildUsdMFuturesContent(),
              _buildCoinMFuturesContent(),
              _buildOptionsContent(),
              _buildP2PContent(),
              _buildFiatContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpotAndMarginContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserTierCard(
              title: 'Regular User',
              isVerified: true,
              tradeVolume: '< 1,000,000 USD',
              bnbBalance: '≥ 0 BNB',
              makerTaker: '0.1000% / 0.1000%',
              makerTakerWithDiscount: '0.075000% / 0.075000%',
              hasBnbDiscount: true,
              usdcMaker: 'Standard / 0.09500%',
              usdcMakerWithDiscount: 'Standard / 0.071250%',
            ),
            const SizedBox(height: 16),
            _buildUserTierCard(
              title: 'VIP 1',
              isVerified: false,
              tradeVolume: '≥ 1,000,000 USD',
              bnbBalance: '≥ 25 BNB',
              makerTaker: '0.0900% / 0.1000%',
              makerTakerWithDiscount: '0.067500% / 0.075000%',
              hasBnbDiscount: true,
              usdcMaker: 'Standard / 0.09500%',
              usdcMakerWithDiscount: 'Standard / 0.071250%',
              showAnd: true,
            ),
            const SizedBox(height: 16),
            _buildUserTierCard(
              title: 'VIP 2',
              isVerified: false,
              tradeVolume: '≥ 5,000,000 USD',
              bnbBalance: '≥ 50 BNB',
              makerTaker: '0.0800% / 0.1000%',
              makerTakerWithDiscount: '0.060000% / 0.075000%',
              hasBnbDiscount: true,
              usdcMaker: 'Standard / 0.09500%',
              usdcMakerWithDiscount: 'Standard / 0.071250%',
              showAnd: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsdMFuturesContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[700],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please note that ETH/BTC Futures contracts will follow the USDT fee schedule.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildFuturesTierCard(
              title: 'Regular User',
              isVerified: true,
              tradeVolume: '< 15,000,000 USD',
              bnbBalance: '≥ 0 BNB',
              usdtMaker: '0.0200%/0.0500%',
              usdtMakerWithDiscount: '0.0180%/0.0450%',
              usdcMaker: '0.0000%/0.0275%',
              usdcMakerStrikethrough: '0.0200%/0.0500%',
              usdcMakerWithDiscount: '0.0000%/0.0248%',
              usdcMakerWithDiscountStrikethrough: '0.0200%/0.0500%',
              discountLabel: 'BNB BNB 10% off',
            ),
            const SizedBox(height: 16),
            _buildFuturesTierCard(
              title: 'VIP 1',
              isVerified: false,
              tradeVolume: '≥ 15,000,000 USD',
              bnbBalance: '≥ 25 BNB',
              usdtMaker: '0.0160%/0.0400%',
              usdtMakerWithDiscount: '0.0144%/0.0360%',
              usdcMaker: '0.0000%/0.0220%',
              usdcMakerStrikethrough: '0.0160%/0.0400%',
              usdcMakerWithDiscount: '0.0000%/0.0198%',
              usdcMakerWithDiscountStrikethrough: '0.0160%/0.0400%',
              discountLabel: 'BNB BNB 10% off',
              showAnd: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinMFuturesContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSimpleTierCard(
              title: 'Regular User',
              isVerified: true,
              tradeVolume: '< 15,000,000 USD',
              bnbBalance: '≥ 0 BNB',
              maker: '0.0200%',
              taker: '0.0500%',
            ),
            const SizedBox(height: 16),
            _buildSimpleTierCard(
              title: 'VIP 1',
              isVerified: false,
              tradeVolume: '≥ 15,000,000 USD',
              bnbBalance: '≥ 25 BNB',
              maker: '0.0160%',
              taker: '0.0400%',
              showAnd: true,
            ),
            const SizedBox(height: 16),
            _buildSimpleTierCard(
              title: 'VIP 2',
              isVerified: false,
              tradeVolume: '≥ 50,000,000 USD',
              bnbBalance: '≥ 100 BNB',
              maker: '0.0140%',
              taker: '0.0350%',
              showAnd: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please note that the promotional rates below apply only to Options contracts listed after August 4, 2025.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Learn more',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionsTierCard(
              title: 'Regular User',
              isVerified: true,
              tradeVolume: '< 100,000,000 USDT',
              makerTaker: '0.0240%/0.0240%',
              makerTakerStrikethrough: '0.0300%/0.0300%',
            ),
            const SizedBox(height: 16),
            _buildOptionsTierCard(
              title: 'VIP 4',
              isVerified: false,
              tradeVolume: '≥ 100,000,000 USDT',
              makerTaker: '0.0240%/0.0240%',
              makerTakerStrikethrough: '0.0300%/0.0300%',
            ),
            const SizedBox(height: 16),
            _buildOptionsTierCard(
              title: 'VIP 5',
              isVerified: false,
              tradeVolume: '≥ 250,000,000 USDT',
              makerTaker: '0.0240%/0.0240%',
              makerTakerStrikethrough: '0.0300%/0.0300%',
            ),
            const SizedBox(height: 16),
            _buildOptionsTierCard(
              title: 'VIP 6',
              isVerified: false,
              tradeVolume: '≥ 500,000,000 USDT',
              makerTaker: '0.0240%/0.0240%',
              makerTakerStrikethrough: '0.0300%/0.0300%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildP2PContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your P2P User Tier:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Verified User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Maker's discount: : 0.00%,",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 122, 79, 223),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "Taker's discount: : 0.00%",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 122, 79, 223),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Fiat',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.currency_rupee,
                      color: Color.fromARGB(255, 122, 79, 223),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'INR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Trade Zone',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Text(
                    'Express',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildP2PCoinCard(
              coinName: 'BNB',
              coinFullName: 'BOCK De-Fi Coin',
              iconColor: const Color.fromRGBO(255, 193, 7, 1),
              iconData: Icons.currency_bitcoin,
              tradeZone: 'Express',
              makerFee: '0.15% / 0.15%',
              takerFee: '0.1% / 0.1%',
            ),
            const SizedBox(height: 16),
            _buildP2PCoinCard(
              coinName: 'BTC',
              coinFullName: 'Bitcoin',
              iconColor: Colors.orange,
              iconData: Icons.currency_bitcoin,
              tradeZone: 'Express',
              makerFee: '0.15% / 0.15%',
              takerFee: '0.1% / 0.1%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiatContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Text(
                    'TRY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please note below fees will be applied when you trade fiat pairs.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            _buildFiatTierCard(
              title: 'Regular User',
              isVerified: true,
              makerTaker: '0.1000% / 0.1500%',
              makerTakerWithDiscount: '0.0750% / 0.1125%',
            ),
            const SizedBox(height: 16),
            _buildFiatTierCard(
              title: 'VIP 1',
              isVerified: false,
              makerTaker: '0.0900% / 0.1500%',
              makerTakerWithDiscount: '0.0675% / 0.1125%',
            ),
            const SizedBox(height: 16),
            _buildFiatTierCard(
              title: 'VIP 2',
              isVerified: false,
              makerTaker: '0.0800% / 0.1000%',
              makerTakerWithDiscount: '0.0600% / 0.0750%',
            ),
            const SizedBox(height: 16),
            _buildFiatTierCard(
              title: 'VIP 3',
              isVerified: false,
              makerTaker: '0.0400% / 0.0600%',
              makerTakerWithDiscount: '0.0300% / 0.0450%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildP2PCoinCard({
    required String coinName,
    required String coinFullName,
    required Color iconColor,
    required IconData iconData,
    required String tradeZone,
    required String makerFee,
    required String takerFee,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coinName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    coinFullName,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trade Zone',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                tradeZone,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maker Fee (Buy/Sell)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                makerFee,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taker Fee (Buy/Sell)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                takerFee,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiatTierCard({
    required String title,
    required bool isVerified,
    required String makerTaker,
    required String makerTakerWithDiscount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maker / Taker',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                makerTaker,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maker / Taker',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'BNB 25% off',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                makerTakerWithDiscount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsTierCard({
    required String title,
    required bool isVerified,
    required String tradeVolume,
    required String makerTaker,
    required String makerTakerStrikethrough,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '30d Options Trade Volume (USDT)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                tradeVolume,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maker / Taker',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    makerTaker,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  ),
                  Text(
                    makerTakerStrikethrough,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTierCard({
    required String title,
    required bool isVerified,
    required String tradeVolume,
    required String bnbBalance,
    required String maker,
    required String taker,
    bool showAnd = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '30-Day Trade Volume (USD*)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                tradeVolume,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'and/or',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                showAnd ? 'and' : 'or',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BNB Balance',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                bnbBalance,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maker',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                maker,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taker',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                taker,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFuturesTierCard({
    required String title,
    required bool isVerified,
    required String tradeVolume,
    required String bnbBalance,
    required String usdtMaker,
    required String usdtMakerWithDiscount,
    required String usdcMaker,
    required String usdcMakerStrikethrough,
    required String usdcMakerWithDiscount,
    required String usdcMakerWithDiscountStrikethrough,
    required String discountLabel,
    bool showAnd = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '30-Day Trade Volume (USD*)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                tradeVolume,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'and/or',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                showAnd ? 'and' : 'or',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BNB Balance',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                bnbBalance,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'USDT Maker / Taker',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                usdtMaker,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'USDT Maker / Taker',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discountLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                usdtMakerWithDiscount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'USDC Maker / Taker',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    usdcMaker,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  ),
                  Text(
                    usdcMakerStrikethrough,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'USDC Maker / Taker',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discountLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    usdcMakerWithDiscount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  ),
                  Text(
                    usdcMakerWithDiscountStrikethrough,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserTierCard({
    required String title,
    required bool isVerified,
    required String tradeVolume,
    required String bnbBalance,
    required String makerTaker,
    required String makerTakerWithDiscount,
    required bool hasBnbDiscount,
    required String usdcMaker,
    required String usdcMakerWithDiscount,
    bool showAnd = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            '30-Day Trade Volume (USD*)',
            tradeVolume,
            alignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'and/or',
            showAnd ? 'and' : 'or',
            alignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'BNB Balance',
            bnbBalance,
            alignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Maker / Taker',
            makerTaker,
            alignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Maker / Taker',
            makerTakerWithDiscount,
            subtitle: 'BNB 25% off',
            alignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'USDC Maker / Taker',
            usdcMaker,
            alignment: MainAxisAlignment.spaceBetween,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'USDC Maker / Taker',
            usdcMakerWithDiscount,
            subtitle: 'BNB 25% off',
            alignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    String? subtitle,
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 122, 79, 223),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSpotPromotionsTab() {
  return Column(
    children: [
      Container(
        color: Colors.grey[100],
        child: TabBar(
          controller: _spotPromotionsTabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color.fromARGB(255, 122, 79, 223),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Zero Fee'),
            Tab(text: 'FDUSD'),
            Tab(text: 'EUR Promo'),
            Tab(text: 'USDC Promo'),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: _spotPromotionsTabController,
          children: [
            _buildZeroFeeContent(),
            _buildFDUSDContent(),
            _buildEURPromoContent(),
            _buildUSDCPromoContent(),
          ],
        ),
      ),
    ],
  );
}

Widget _buildZeroFeeContent() {
  final zeroFeePairs = [
    'BTC / FDUSD',
    'FDUSD / USDT',
    'OG / FDUSD',
    '1000SATS / FDUSD',
  ];

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search coin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.filter_list,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pairs list
          ...zeroFeePairs.map((pair) => _buildTradingPairCard(pair)).toList(),
        ],
      ),
    ),
  );
}

Widget _buildFDUSDContent() {
  final fdusdPairs = [
    'BTC / FDUSD',
    'BNB / FDUSD',
    'DOGE / FDUSD',
    'ETH / FDUSD',
    'LINK / FDUSD',
    'SOL / FDUSD',
    'XRP / FDUSD',
  ];

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(text: 'Please view promotion details for '),
                        TextSpan(
                          text: 'FDUSD Zero Maker Fee Promotion',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Zero-Fee Promotion for 6 FDUSD pairs',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '. Note that all other FDUSD pairs except the ones in the list apply zero maker fee and standard taker fees.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tabs
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Promotional Pairs'),
                      Tab(text: 'Fees'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Pairs list
          ...fdusdPairs.map((pair) => _buildTradingPairCard(pair)).toList(),
        ],
      ),
    ),
  );
}

Widget _buildEURPromoContent() {
  final eurPairs = [
    'ADA / EUR',
    'AVAX / EUR',
    'BCH / EUR',
    'BNB / EUR',
    'BTC / EUR',
    'DOGE / EUR',
    'DOT / EUR',
    'EGLD / EUR',
  ];

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(text: '• BOCK De-Fi Launches '),
                        TextSpan(
                          text: 'Zero Fee Promotion on EUR/USDC and EUR/USDT Trading Pairs',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' for VIP 2 - 9 users and Spot Liquidity Providers.\n\n'),
                        TextSpan(text: '• BOCK De-Fi Introduces '),
                        TextSpan(
                          text: 'Taker Fee Promotion',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' for EUR Spot and Margin Trading Pairs. Please note that the promotion excludes ongoing Zero Fee pairs.\n\n',
                        ),
                        TextSpan(text: '• BOCK De-Fi updates '),
                        TextSpan(
                          text: 'EUR Fiat Liquidity Provider Program',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' with a new qualification tier and higher rebate incentives.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tabs
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Promotional Pairs'),
                      Tab(text: 'Fees'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search coin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pairs list
          ...eurPairs.map((pair) => _buildTradingPairCard(pair)).toList(),
        ],
      ),
    ),
  );
}

Widget _buildUSDCPromoContent() {
  final usdcPairs = [
    'ADA / USDC',
    'ALGO / USDC',
    'ATOM / USDC',
    'BCH / USDC',
    'BNB / USDC',
    'BTC / USDC',
    'DOGE / USDC',
    'ETC / USDC',
  ];

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(text: '• BOCK De-Fi Introduces '),
                        TextSpan(
                          text: 'Taker Fee Promotion for USDC Spot and Margin Trading Pairs',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '. Please note that the promotional taker fees are only applicable to the trading pairs found in the list below.\n\n',
                        ),
                        TextSpan(
                          text: '• BOCK De-Fi Launches Zero Fee Promotion on BNB/USDC, ADA/USDC, TRX/USDC, XRP/USDC and LINK/USDC Trading Pairs for VIP 2 - 9 Users and Spot Liquidity Providers. ',
                        ),
                        TextSpan(
                          text: 'Learn More',
                          style: TextStyle(
                            color: Color.fromARGB(255, 122, 79, 223),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tabs
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Promotional Pairs'),
                      Tab(text: 'Fees'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search coin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pairs list
          ...usdcPairs.map((pair) => _buildTradingPairCard(pair)).toList(),
        ],
      ),
    ),
  );
}

Widget _buildTradingPairCard(String pair) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          pair,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const Text(
          'Trade',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 122, 79, 223),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildLiquidityProgramTab() {
    return _buildPlaceholderCard('Liquidity Program');
  }

  Widget _buildPlaceholderCard(String title) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Content will be displayed here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}