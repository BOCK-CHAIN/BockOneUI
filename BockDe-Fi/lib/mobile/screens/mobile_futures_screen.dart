import 'dart:async';
import 'package:bockchain/mobile/screens/mobile_coin_screen.dart';
import 'package:bockchain/mobile/screens/mobile_options_screem.dart';
import 'package:bockchain/mobile/screens/mobile_smart_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';
// Import your actual screen files here
// import 'package:bockchain/mobile/screens/mobile_coin_m_screen.dart';
// import 'package:bockchain/mobile/screens/mobile_options_screen.dart';
// import 'package:bockchain/mobile/screens/mobile_smart_money_screen.dart';

class MobileFuturesScreen extends StatefulWidget {
  final WalletService walletService;
  const MobileFuturesScreen({Key? key, required this.walletService}) : super(key: key);

  @override
  State<MobileFuturesScreen> createState() => _MobileFuturesScreenState();
}

class _MobileFuturesScreenState extends State<MobileFuturesScreen> with SingleTickerProviderStateMixin {
  Timer? _priceUpdateTimer;
  late TabController _tabController;
  late PageController _pageController;
  
  double currentPrice = 115517.0;
  List<OrderBookEntry> asks = [];
  List<OrderBookEntry> bids = [];
  
  double orderPrice = 115517.2;
  int orderPercentage = 25;
  double priceChange = -1.17;
  double fundingRate = -0.0008;
  String fundingCountdown = '03:06:31';
  
  int _currentNavIndex = 3;
  int _selectedLeverageIndex = 1;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _pageController = PageController(initialPage: 0);
    
    // Listen to tab controller changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    _initializeOrderBook();
    _startPriceUpdates();
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _initializeOrderBook() {
    asks = [
      OrderBookEntry(115518.2, 0.014),
      OrderBookEntry(115518.1, 0.002),
      OrderBookEntry(115517.8, 0.006),
      OrderBookEntry(115517.6, 0.004),
      OrderBookEntry(115517.3, 0.004),
      OrderBookEntry(115517.1, 0.005),
      OrderBookEntry(115517.0, 0.384),
    ];
    bids = [
      OrderBookEntry(115516.9, 18.559),
      OrderBookEntry(115516.8, 0.220),
      OrderBookEntry(115516.7, 0.011),
      OrderBookEntry(115516.6, 0.005),
      OrderBookEntry(115516.5, 0.004),
      OrderBookEntry(115516.4, 0.009),
      OrderBookEntry(115516.3, 0.140),
    ];
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        setState(() {
          double change = (DateTime.now().millisecondsSinceEpoch % 100 - 50) / 20.0;
          currentPrice += change;
          orderPrice = currentPrice + 0.2;
          
          double base = currentPrice;
          for (int i = 0; i < asks.length; i++) {
            asks[i].price = base + (7 - i) * 0.1;
          }
          for (int i = 0; i < bids.length; i++) {
            bids[i].price = base - (i + 1) * 0.1;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildPairHeader(),
            _buildPriceChangeRow(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _tabController.animateTo(index);
                  });
                },
                children: [
                  _buildUSDMContent(),
                  MobileCoinScreen(), // Replace with MobileCoinMScreen() when imported
                  MobileOptionsScreen(), // Replace with MobileOptionsScreen() when imported
                  MobileSmartScreen(), // Replace with MobileSmartMoneyScreen() when imported
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUSDMContent() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildLeftPanel()),
              Container(width: 1, color: const Color(0xFFE0E0E5)),
              Expanded(child: _buildRightPanel()),
            ],
          ),
        ),
        _buildWelcomeBanner(),
        _buildPositionsTabs(),
        _buildChartPlaceholder(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFF7C3AED),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: const Color(0xFF7C3AED),
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: const [
                Tab(text: 'USD©-M'),
                Tab(text: 'COIN-M'),
                Tab(text: 'Options'),
                Tab(text: 'Smart Money'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF6B7280), size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPairHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      color: Colors.white,
      child: Row(
        children: [
          const Text('BTCUSDT', style: TextStyle(color: Color(0xFF111827), fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)),
            child: const Text('Perp', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 20),
          const Spacer(),
          IconButton(icon: const Icon(Icons.card_giftcard_outlined, color: Color(0xFF7C3AED), size: 22), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          const SizedBox(width: 4),
          IconButton(icon: const Icon(Icons.show_chart, color: Color(0xFF6B7280), size: 22), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: Color(0xFF6B7280), size: 22),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Color(0xFF6B7280), size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: Color(0xFF7C3AED), shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChangeRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      color: Colors.white,
      child: Row(
        children: [
          Text('${priceChange.toStringAsFixed(2)}%', style: const TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Funding / Countdown', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
              Text('$fundingRate%/$fundingCountdown', style: const TextStyle(color: Color(0xFF111827), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildOrderTypeRow(),
            const SizedBox(height: 12),
            _buildAvailableRow(),
            const SizedBox(height: 16),
            _buildLimitOrderSection(),
            const SizedBox(height: 12),
            _buildPriceInput(),
            const SizedBox(height: 12),
            _buildAmountInput(),
            const SizedBox(height: 16),
            _buildSlider(),
            const SizedBox(height: 16),
            _buildTPSLRow(),
            const SizedBox(height: 12),
            _buildReduceOnlyRow(),
            const SizedBox(height: 16),
            _buildCostRow(),
            const SizedBox(height: 12),
            _buildBuyButton(),
            const SizedBox(height: 12),
            _buildCostRow(),
            const SizedBox(height: 12),
            _buildSellButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeRow() {
    return Row(
      children: [
        _buildTypeButton('Cross', 0),
        const SizedBox(width: 8),
        _buildTypeButton('20x', 1),
        const SizedBox(width: 8),
        _buildTypeButton('S', 2),
      ],
    );
  }

  Widget _buildTypeButton(String text, int index) {
    final isSelected = _selectedLeverageIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedLeverageIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE0E0E5)),
        ),
        child: Text(text, style: TextStyle(color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF6B7280), fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }

  Widget _buildAvailableRow() {
    return Row(
      children: [
        const Text('Avbl', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
        const Spacer(),
        const Text('--', style: TextStyle(color: Color(0xFF111827), fontSize: 12)),
        const SizedBox(width: 6),
        const Icon(Icons.sync, color: Color(0xFF7C3AED), size: 16),
      ],
    );
  }

  Widget _buildLimitOrderSection() {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.info_outline, color: Color(0xFF6B7280), size: 12),
        ),
        const SizedBox(width: 8),
        const Text('Limit', style: TextStyle(color: Color(0xFF111827), fontSize: 15, fontWeight: FontWeight.w600)),
        const Spacer(),
        const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 20),
      ],
    );
  }

  Widget _buildPriceInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Price (USDT)', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                const SizedBox(height: 4),
                Text(orderPrice.toStringAsFixed(1), style: const TextStyle(color: Color(0xFF111827), fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => setState(() => orderPrice += 0.1),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.add, color: Color(0xFF6B7280), size: 18),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => setState(() => orderPrice -= 0.1),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.remove, color: Color(0xFF6B7280), size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('BBO', style: TextStyle(color: Color(0xFF111827), fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Amount', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                const SizedBox(height: 4),
                Text('$orderPercentage%', style: const TextStyle(color: Color(0xFF111827), fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => setState(() => orderPercentage = (orderPercentage + 5).clamp(0, 100)),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.add, color: Color(0xFF6B7280), size: 18),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => setState(() => orderPercentage = (orderPercentage - 5).clamp(0, 100)),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.remove, color: Color(0xFF6B7280), size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: const [
                Text('BTC', style: TextStyle(color: Color(0xFF111827), fontSize: 12, fontWeight: FontWeight.w500)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7C3AED), width: 2),
            color: Colors.white,
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: SliderComponentShape.noThumb,
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: const Color(0xFF7C3AED),
              inactiveTrackColor: const Color(0xFFE0E0E5),
            ),
            child: Slider(
              value: orderPercentage.toDouble(),
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => orderPercentage = value.toInt()),
            ),
          ),
        ),
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0E0E5),
          ),
        ),
      ],
    );
  }

  Widget _buildTPSLRow() {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        const Text('TP/SL', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, decoration: TextDecoration.underline, decorationColor: Color(0xFF6B7280))),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE0E0E5)),
          ),
          child: Row(
            children: const [
              Text('GTC', style: TextStyle(color: Color(0xFF111827), fontSize: 11)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReduceOnlyRow() {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Reduce Only', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, decoration: TextDecoration.underline, decorationColor: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildCostRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Max\nCost', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, height: 1.3)),
        const Text('0.000 BTC\n0.00 USDT', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF111827), fontSize: 11, height: 1.3)),
      ],
    );
  }

  Widget _buildBuyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: const [
          Text('Buy / Long', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          SizedBox(height: 2),
          Text('≈ 0.000 BTC', style: TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSellButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: const [
          Text('Sell / Short', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          SizedBox(height: 2),
          Text('≈ 0.000 BTC', style: TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: const Color(0xFFF5F5F7),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildOrderBookHeader(),
          Expanded(child: _buildOrderBookList()),
          _buildCurrentPrice(),
          const SizedBox(height: 8),
          _buildOrderBookStats(),
          const SizedBox(height: 8),
          _buildOrderBookControls(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOrderBookHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: const [
          Expanded(child: Text('Price\n(USDT)', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10, height: 1.3))),
          Expanded(child: Text('Amount\n(BTC)', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF6B7280), fontSize: 10, height: 1.3))),
        ],
      ),
    );
  }

  Widget _buildOrderBookList() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ...asks.reversed.map((e) => _buildOrderBookRow(e.price, e.amount, false)),
        const SizedBox(height: 2),
        ...bids.map((e) => _buildOrderBookRow(e.price, e.amount, true)),
      ],
    );
  }

  Widget _buildOrderBookRow(double price, double amount, bool isBid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              price.toStringAsFixed(1),
              style: TextStyle(
                color: isBid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              amount.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color(0xFF111827), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: [
          Text(
            currentPrice.toStringAsFixed(1),
            style: const TextStyle(color: Color(0xFF10B981), fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          const Text('115,518.3', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildOrderBookStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text('97.46%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 97,
            child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(2))),
          ),
          Expanded(
            flex: 3,
            child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text('2.54%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderBookControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE0E0E5)),
            ),
            child: Row(
              children: const [
                Text('0.1', style: TextStyle(color: Color(0xFF111827), fontSize: 11)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 14),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE0E0E5)),
            ),
            child: const Icon(Icons.more_vert, color: Color(0xFF6B7280), size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: Color(0xFF7C3AED), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(text: 'Welcome\n', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
                  TextSpan(text: 'Open Account to Trade Futures Today', style: TextStyle(color: Color(0xFF111827), fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('Claim', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFF5F5F7),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 6),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF7C3AED), width: 2)),
            ),
            child: const Text('Positions (0)', style: TextStyle(color: Color(0xFF111827), fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 24),
          const Text('Open Orders (0)', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(width: 24),
          const Text('Bots', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const Spacer(),
          const Icon(Icons.open_in_new, color: Color(0xFF6B7280), size: 18),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E5)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, color: Color(0xFFD1D5DB), size: 48),
            SizedBox(height: 8),
            Text(
              'BTCUSDT Perp Chart',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder screens - Replace these with your actual screen imports
  Widget _buildCoinMScreen() {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.currency_bitcoin, size: 64, color: Color(0xFF7C3AED)),
            SizedBox(height: 16),
            Text(
              'COIN-M Futures',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Swipe to navigate between sections',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsScreen() {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.settings, size: 64, color: Color(0xFF7C3AED)),
            SizedBox(height: 16),
            Text(
              'Options Trading',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Swipe to navigate between sections',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartMoneyScreen() {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lightbulb, size: 64, color: Color(0xFF7C3AED)),
            SizedBox(height: 16),
            Text(
              'Smart Money',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Swipe to navigate between sections',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderBookEntry {
  double price;
  final double amount;
  OrderBookEntry(this.price, this.amount);
}