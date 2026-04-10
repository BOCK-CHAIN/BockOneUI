import 'package:flutter/material.dart';

class CoinStatus {
  final String symbol;
  final String name;
  final String iconUrl;
  final bool depositNormal;
  final bool withdrawalNormal;
  final String? withdrawalNote;

  CoinStatus({
    required this.symbol,
    required this.name,
    required this.iconUrl,
    this.depositNormal = true,
    this.withdrawalNormal = true,
    this.withdrawalNote,
  });
}

class MobileDepWithStatusScreen extends StatefulWidget {
  const MobileDepWithStatusScreen({Key? key}) : super(key: key);

  @override
  State<MobileDepWithStatusScreen> createState() =>
      _MobileDepWithStatusScreenState();
}

class _MobileDepWithStatusScreenState extends State<MobileDepWithStatusScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showAbnormalOnly = false;
  bool _hideSuspended = false;
  String _searchQuery = '';

  final List<CoinStatus> _coins = [
    CoinStatus(
      symbol: 'BTC',
      name: 'Bitcoin',
      iconUrl: '🟠',
    ),
    CoinStatus(
      symbol: 'ETH',
      name: 'Ethereum',
      iconUrl: '🔷',
    ),
    CoinStatus(
      symbol: 'XRP',
      name: 'XRP',
      iconUrl: '⚫',
    ),
    CoinStatus(
      symbol: 'USDT',
      name: 'TetherUS',
      iconUrl: '🟢',
    ),
    CoinStatus(
      symbol: 'TON',
      name: 'Toncoin',
      iconUrl: '🔵',
      withdrawalNormal: false,
      withdrawalNote: 'Partial Withdrawal Suspended',
    ),
    CoinStatus(
      symbol: 'DOT',
      name: 'Polkadot',
      iconUrl: '🔴',
      withdrawalNormal: false,
      withdrawalNote: 'Partial Withdrawal Suspended',
    ),
    CoinStatus(
      symbol: 'DAI',
      name: 'Dai',
      iconUrl: '🟡',
      withdrawalNormal: false,
      withdrawalNote: 'Partial Withdrawal Suspended',
    ),
    CoinStatus(
      symbol: 'WLD',
      name: 'Worldcoin',
      iconUrl: '⚫',
      withdrawalNormal: false,
      withdrawalNote: 'Partial Withdrawal Suspended',
    ),
    CoinStatus(
      symbol: 'UNI',
      name: 'Uniswap',
      iconUrl: '🦄',
    ),
    CoinStatus(
      symbol: 'WLFI',
      name: 'World Liberty Financial',
      iconUrl: '🟤',
    ),
  ];

  List<CoinStatus> get _filteredCoins {
    return _coins.where((coin) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!coin.symbol.toLowerCase().contains(query) &&
            !coin.name.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Show abnormal networks only
      if (_showAbnormalOnly) {
        if (coin.depositNormal && coin.withdrawalNormal) {
          return false;
        }
      }

      // Hide suspended coins
      if (_hideSuspended) {
        if (!coin.depositNormal || !coin.withdrawalNormal) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'BOCK De-Fi.com/en/network',
          style: TextStyle(
            color: Colors.black,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deposit & Withdrawal Status',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    'Check the deposit and withdrawal status of each coin in BOCK De-Fi at real time',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Search and Filters
            Container(
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 12 : 16,
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search coin',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),

                  // Checkboxes
                  Row(
                    children: [
                      Checkbox(
                        value: _showAbnormalOnly,
                        onChanged: (value) {
                          setState(() {
                            _showAbnormalOnly = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 122, 79, 223),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAbnormalOnly = !_showAbnormalOnly;
                            });
                          },
                          child: Text(
                            'Show abnormal networks only',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _hideSuspended,
                        onChanged: (value) {
                          setState(() {
                            _hideSuspended = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 122, 79, 223),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _hideSuspended = !_hideSuspended;
                            });
                          },
                          child: Text(
                            'Hide suspended coins',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Last Updated
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Row(
                    children: [
                      Text(
                        'Last updated: ${_getFormattedDateTime()}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.refresh,
                        size: isSmallScreen ? 16 : 18,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Coin List
            Container(
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _filteredCoins.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final coin = _filteredCoins[index];
                  return _CoinStatusItem(
                    coin: coin,
                    isSmallScreen: isSmallScreen,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _CoinStatusItem extends StatefulWidget {
  final CoinStatus coin;
  final bool isSmallScreen;

  const _CoinStatusItem({
    Key? key,
    required this.coin,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  State<_CoinStatusItem> createState() => _CoinStatusItemState();
}

class _CoinStatusItemState extends State<_CoinStatusItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(widget.isSmallScreen ? 16 : 20),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: widget.isSmallScreen ? 36 : 40,
                    height: widget.isSmallScreen ? 36 : 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.coin.iconUrl,
                        style: TextStyle(
                          fontSize: widget.isSmallScreen ? 20 : 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: widget.isSmallScreen ? 12 : 16),

                  // Symbol and Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.coin.symbol,
                          style: TextStyle(
                            fontSize: widget.isSmallScreen ? 15 : 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.coin.name,
                          style: TextStyle(
                            fontSize: widget.isSmallScreen ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand Icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: widget.isSmallScreen ? 20 : 24,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Status Details
          if (_isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(
                widget.isSmallScreen ? 16 : 20,
                0,
                widget.isSmallScreen ? 16 : 20,
                widget.isSmallScreen ? 16 : 20,
              ),
              child: Column(
                children: [
                  // Deposit Status
                  _StatusRow(
                    label: 'Deposit Status',
                    isNormal: widget.coin.depositNormal,
                    note: null,
                    isSmallScreen: widget.isSmallScreen,
                  ),
                  SizedBox(height: widget.isSmallScreen ? 12 : 16),

                  // Withdrawal Status
                  _StatusRow(
                    label: 'Withdrawal Status',
                    isNormal: widget.coin.withdrawalNormal,
                    note: widget.coin.withdrawalNote,
                    isSmallScreen: widget.isSmallScreen,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final bool isNormal;
  final String? note;
  final bool isSmallScreen;

  const _StatusRow({
    Key? key,
    required this.label,
    required this.isNormal,
    this.note,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 15,
              color: Colors.grey[600],
            ),
          ),
        ),
        Row(
          children: [
            if (isNormal)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: isSmallScreen ? 18 : 20,
              )
            else
              Icon(
                Icons.warning,
                color: const Color.fromARGB(255, 122, 79, 223),
                size: isSmallScreen ? 18 : 20,
              ),
            const SizedBox(width: 8),
            Text(
              isNormal ? 'Normal' : (note ?? 'Suspended'),
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}