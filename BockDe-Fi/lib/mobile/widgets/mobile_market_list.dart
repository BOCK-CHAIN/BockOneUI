import 'package:flutter/material.dart';

class MobileMarketList extends StatelessWidget {
  final List<Map<String, dynamic>> markets = [
    {'symbol': 'BTC/USDT', 'price': '43,250.00', 'change': '+2.45', 'volume': '23.45K'},
    {'symbol': 'ETH/USDT', 'price': '2,680.50', 'change': '-1.20', 'volume': '156.7K'},
    {'symbol': 'BNB/USDT', 'price': '315.80', 'change': '+0.85', 'volume': '45.2K'},
    {'symbol': 'ADA/USDT', 'price': '0.4250', 'change': '+3.15', 'volume': '89.5K'},
    {'symbol': 'DOT/USDT', 'price': '6.75', 'change': '-0.50', 'volume': '12.8K'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Color(0xFF1E2329),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pair', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('24h Change', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Volume', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: markets.length,
              itemBuilder: (context, index) {
                final market = markets[index];
                final isPositive = !market['change'].toString().startsWith('-');
                
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        market['symbol'],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${market['price']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${market['change']}%',
                        style: TextStyle(
                          color: isPositive ? Color(0xFF0ECB81) : Color(0xFFF6465D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        market['volume'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}