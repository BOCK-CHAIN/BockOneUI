import 'package:flutter/material.dart';

class MobileAssetList extends StatelessWidget {
  final List<Map<String, dynamic>> assets = [
    {
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'balance': '2.35420000',
      'value': '\$101,525.50',
      'change': '+2.45',
    },
    {
      'symbol': 'ETH',
      'name': 'Ethereum',
      'balance': '8.75300000',
      'value': '\$23,456.15',
      'change': '-1.20',
    },
    {
      'symbol': 'BNB',
      'name': 'BOCK De-Fi Coin',
      'balance': '15.20000000',
      'value': '\$4,800.16',
      'change': '+0.85',
    },
    {
      'symbol': 'USDT',
      'name': 'Tether',
      'balance': '1,250.00000000',
      'value': '\$1,250.00',
      'change': '0.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Assets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...assets.map((asset) => _buildAssetItem(asset)).toList(),
      ],
    );
  }

  Widget _buildAssetItem(Map<String, dynamic> asset) {
    final isPositive = !asset['change'].toString().startsWith('-');
    final isZero = asset['change'].toString() == '0.00';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFF0B90B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                asset['symbol'].substring(0, 1),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset['symbol'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  asset['name'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                asset['value'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    asset['balance'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${isPositive && !isZero ? '+' : ''}${asset['change']}%',
                    style: TextStyle(
                      color: isZero ? Colors.grey : (isPositive ? Color(0xFF0ECB81) : Color(0xFFF6465D)),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
}