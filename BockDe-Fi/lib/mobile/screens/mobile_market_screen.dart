import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_data_screen.dart';
import 'package:bockchain/mobile/screens/mobile_grow_screen.dart';
import 'package:bockchain/mobile/screens/mobile_square_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileMarketScreen extends StatefulWidget {
  final WalletService walletService;
  const MobileMarketScreen({Key? key, required this.walletService}) : super(key: key);
  
  @override
  _MobileMarketScreenState createState() => _MobileMarketScreenState();
}

class _MobileMarketScreenState extends State<MobileMarketScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _priceUpdateTimer;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // All crypto data for Favorites
  List<CryptoAsset> _allAssets = [
    CryptoAsset(name: 'BNB', pair: '/USDT', leverage: '10x', price: 990.00, volume: '340.65M', priceInr: '₹87,248.70', change24h: -0.75, isFavorite: true),
    CryptoAsset(name: 'BTC', pair: '/USDT', leverage: '10x', price: 116147.83, volume: '1.17B', priceInr: '₹10,236,108.25', change24h: -1.17, isFavorite: true),
    CryptoAsset(name: 'ETH', pair: '/USDT', leverage: '10x', price: 4512.75, volume: '1.30B', priceInr: '₹397,708.65', change24h: -1.76, isFavorite: true),
    CryptoAsset(name: 'SOL', pair: '/USDT', leverage: '10x', price: 240.80, volume: '936.33M', priceInr: '₹21,221.70', change24h: -2.77, isFavorite: true),
    CryptoAsset(name: 'DOGE', pair: '/USDT', leverage: '10x', price: 0.27019, volume: '447.93M', priceInr: '₹23.81', change24h: -4.80, isFavorite: true),
    CryptoAsset(name: 'WLFI', pair: '/USDT', leverage: '5x', price: 0.2328, volume: '122.46M', priceInr: '₹20.51', change24h: 4.44, isFavorite: true),
    CryptoAsset(name: 'ADA', pair: '/USDT', leverage: '10x', price: 0.9043, volume: '151.14M', priceInr: '₹79.68', change24h: -1.51, isFavorite: true),
    CryptoAsset(name: 'PEPE', pair: '/USDT', leverage: '5x', price: 0.00001090, volume: '118.37M', priceInr: '₹0.00096061', change24h: -4.05, isFavorite: true),
  ];

  // Markets data
  List<CoinData> cryptoCoins = [];
  List<CoinData> spotCoins = [];
  List<CoinData> usdmCoins = [];
  List<CoinData> coinmCoins = [];
  List<CoinData> optionsCoins = [];

  // Total pages: Favorites + 5 Markets tabs + Alpha + Grow + Square(5 sub-tabs) + Data = 14 pages
  // 0: Favorites
  // 1: Markets-Crypto, 2: Markets-Spot, 3: Markets-USD-M, 4: Markets-COIN-M, 5: Markets-Options
  // 6: Alpha
  // 7: Grow
  // 8-12: Square (5 sub-tabs)
  // 13: Data

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initializeMarketsData();
    _startPriceUpdates();
  }

  void _initializeMarketsData() {
    cryptoCoins = [
      CoinData('BTC', 'Bitcoin', 116376.61, -0.65, '₹10,253,943.10', 'assets/btc.png'),
      CoinData('1INCH', '1inch', 0.2613, -2.75, '₹23.02', 'assets/1inch.png'),
      CoinData('AAVE', 'Aave', 306.58, -0.14, '₹27,012.76', 'assets/aave.png'),
      CoinData('ACM', 'AC Milan Fan Token', 0.908, 1.00, '₹80.00', 'assets/acm.png'),
      CoinData('ADA', 'Cardano', 0.9061, -0.69, '₹79.83', 'assets/ada.png'),
      CoinData('ALGO', 'Algorand', 0.2413, -1.79, '₹21.26', 'assets/algo.png'),
      CoinData('ALICE', 'My Neighbor Alice', 0.3684, -2.85, '₹32.45', 'assets/alice.png'),
      CoinData('ANKR', 'Ankr', 0.01518, -2.94, '₹1.33', 'assets/ankr.png'),
      CoinData('ARDR', 'Ardor', 0.08672, -1.36, '₹7.64', 'assets/ardr.png'),
    ];

    spotCoins = List.from(cryptoCoins);
    usdmCoins = List.from(cryptoCoins);
    coinmCoins = List.from(cryptoCoins);
    optionsCoins = List.from(cryptoCoins);
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          for (var asset in _allAssets) {
            final random = Random();
            final changePercent = (random.nextDouble() - 0.5) * 0.1;
            asset.price = asset.price * (1 + changePercent);
            final changeDirection = random.nextBool() ? 1 : -1;
            asset.change24h += (random.nextDouble() * 0.1 * changeDirection);
            asset.priceInr = '₹${(asset.price * 88.2).toStringAsFixed(2)}';
          }
          
          _updatePrices(cryptoCoins);
          _updatePrices(spotCoins);
          _updatePrices(usdmCoins);
          _updatePrices(coinmCoins);
          _updatePrices(optionsCoins);
        });
      }
    });
  }

  void _updatePrices(List<CoinData> coins) {
    final random = Random();
    for (var coin in coins) {
      double changePercent = (random.nextDouble() - 0.5) * 10;
      coin.price24hChange = double.parse(changePercent.toStringAsFixed(2));
      double newPrice = coin.lastPrice * (1 + changePercent / 100);
      coin.lastPrice = double.parse(newPrice.toStringAsFixed(coin.lastPrice < 1 ? 6 : 2));
      coin.inrPrice = '₹${(coin.lastPrice * 88).toStringAsFixed(2)}';
    }
  }

  String _getCurrentTopTabName() {
    if (_currentPage == 0) return 'Favorites';
    if (_currentPage >= 1 && _currentPage <= 5) return 'Market';
    if (_currentPage == 6) return 'Alpha';
    if (_currentPage == 7) return 'Grow';
    //if (_currentPage >= 8 && _currentPage <= 12) return 'Square';
    if (_currentPage == 13) return 'Data';
    return 'Favorites';
  }

  String _getCurrentSubTabName() {
    if (_currentPage == 1) return 'Crypto';
    if (_currentPage == 2) return 'Spot';
    if (_currentPage == 3) return 'USD©-M';
    if (_currentPage == 4) return 'COIN-M';
    if (_currentPage == 5) return 'Options';
    /*if (_currentPage >= 8 && _currentPage <= 12) {
      return ['Square DiscoverTab', 'Square FollowingTabState', 'Square NewsTab', 'Square AcademyTab', 'Square MomentsTab'][_currentPage - 8];
    }*/
    return '';
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    _pageController.dispose();
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
            // Search Bar
            Container(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Coin Pairs',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.grey[700]),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),
            
            // Main Navigation Tabs
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMainTab('Favorites', 0),
                    _buildMainTab('Market', 1),
                    _buildMainTab('Alpha', 6),
                    _buildMainTab('Grow', 7),
                    //_buildMainTab('Square', 8),
                    _buildMainTab('Data', 13),
                  ],
                ),
              ),
            ),
            
            // Sub Navigation (if applicable)
            if (_currentPage >= 1 && _currentPage <= 5)
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSubTab('Crypto', 1),
                      SizedBox(width: 20),
                      _buildSubTab('Spot', 2),
                      SizedBox(width: 20),
                      _buildSubTab('USD©-M', 3),
                      SizedBox(width: 20),
                      _buildSubTab('COIN-M', 4),
                      SizedBox(width: 20),
                      _buildSubTab('Options', 5),
                    ],
                  ),
                ),
              ),
            
            if (_currentPage >= 8 && _currentPage <= 12)
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSubTab('Dicover', 8),
                      SizedBox(width: 20),
                      _buildSubTab('Following', 9),
                      SizedBox(width: 20),
                      _buildSubTab('News', 10),
                      SizedBox(width: 20),
                      _buildSubTab('Academy', 11),
                      SizedBox(width: 20),
                      _buildSubTab('Moments', 12),
                    ],
                  ),
                ),
              ),
            
            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  // 0: Favorites
                  _buildFavoritesPage(),
                  
                  // 1-5: Markets tabs
                  _buildMarketsPage(cryptoCoins, 'Crypto'),
                  _buildMarketsPage(spotCoins, 'Spot'),
                  _buildMarketsPage(usdmCoins, 'USD©-M'),
                  _buildMarketsPage(coinmCoins, 'COIN-M'),
                  _buildMarketsPage(optionsCoins, 'Options'),
                  
                  // 6: Alpha
                  MobileAlphaScreen(),
                  
                  // 7: Grow
                  MobileGrowScreen(),
                  
                  // 8-12: Square sub-tabs
                 /* _buildSquareSubTab('Square DiscoverTab'),
                  _buildSquareSubTab('Square FollowingTabState'),
                  _buildSquareSubTab('Square NewsTab'),
                  _buildSquareSubTab('Square AcademyTab'),
                  _buildSquareSubTab('Square MomentsTab'),*/
                  
                  // 13: Data
                  MobileDataScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTab(String title, int targetPage) {
    bool isActive = (_currentPage == targetPage) || 
                    (title == 'Market' && _currentPage >= 1 && _currentPage <= 5) ||
                    (title == 'Square' && _currentPage >= 8 && _currentPage <= 12);
    
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          targetPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildSubTab(String title, int targetPage) {
    bool isActive = _currentPage == targetPage;
    
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          targetPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.grey[600],
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildFavoritesPage() {
    final favoriteAssets = _allAssets.where((a) => a.isFavorite).toList();
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('Name ↕ / Vol ↕', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500))),
              Expanded(flex: 2, child: Text('Last Price ↕', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('24h Chg% ↕', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: favoriteAssets.length,
            itemBuilder: (context, index) => _buildCryptoAssetItem(favoriteAssets[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketsPage(List<CoinData> coins, String marketType) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                SizedBox(width: 12),
                _buildFilterChip('BNB Chain', false),
                SizedBox(width: 12),
                _buildFilterChip('Solana', false),
                SizedBox(width: 12),
                _buildFilterChip('RWA', false),
                SizedBox(width: 12),
                _buildFilterChip('Meme', false),
                SizedBox(width: 12),
                _buildFilterChip('Payment', false),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('Name', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500))),
              Expanded(flex: 2, child: Text('Last Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500))),
              Expanded(flex: 1, child: Text('24h Chg%', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: coins.length,
            itemBuilder: (context, index) => _buildCoinItem(coins[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.black : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  /*Widget _buildSquareSubTab(String tabName) {
    return MobileSquareScreen(); // You can pass different parameters or create different views
  }*/

  Widget _buildCryptoAssetItem(CryptoAsset asset) {
    final isPositive = asset.change24h > 0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(asset.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                    Text(asset.pair, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey[600])),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      child: Text(asset.leverage, style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(asset.volume, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_formatPrice(asset.price), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black), textAlign: TextAlign.right),
                SizedBox(height: 2),
                Text(asset.priceInr, style: TextStyle(fontSize: 13, color: Colors.grey[500]), textAlign: TextAlign.right),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: isPositive ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(4)),
                child: Text('${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinItem(CoinData coin) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: _getCoinColor(coin.symbol), shape: BoxShape.circle),
                  child: Center(child: Text(coin.symbol.substring(0, min(3, coin.symbol.length)).toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coin.symbol, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                    Text(coin.name, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(coin.lastPrice.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                Text(coin.inrPrice, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: coin.price24hChange >= 0 ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(4)),
              child: Text('${coin.price24hChange >= 0 ? '+' : ''}${coin.price24hChange.toStringAsFixed(2)}%', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCoinColor(String symbol) {
    final colors = [Colors.orange, Colors.blue, Colors.purple, Colors.green, Colors.red, Colors.indigo, Colors.pink, Colors.teal, Colors.amber];
    return colors[symbol.hashCode % colors.length];
  }

  String _formatPrice(double price) {
    if (price < 0.001) return price.toStringAsExponential(4);
    if (price < 1) return price.toStringAsFixed(5);
    if (price < 100) return price.toStringAsFixed(4);
    return price.toStringAsFixed(2);
  }
}

class CryptoAsset {
  final String name;
  final String pair;
  final String leverage;
  double price;
  final String volume;
  String priceInr;
  double change24h;
  bool isFavorite;

  CryptoAsset({required this.name, required this.pair, required this.leverage, required this.price, required this.volume, required this.priceInr, required this.change24h, required this.isFavorite});
}

class CoinData {
  String symbol;
  String name;
  double lastPrice;
  double price24hChange;
  String inrPrice;
  String iconPath;

  CoinData(this.symbol, this.name, this.lastPrice, this.price24hChange, this.inrPrice, this.iconPath);
}