import 'package:flutter/material.dart';

class MobileOrderBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Text(
              'Order Book',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade800, height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          ...List.generate(5, (index) => _buildOrderItem(
            price: (43250 + index * 10).toString(),
            amount: '${(1.2 + index * 0.1).toStringAsFixed(3)}',
            isAsk: true,
          )),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              '\$43,250.00',
              style: TextStyle(
                color: Color(0xFF0ECB81),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...List.generate(5, (index) => _buildOrderItem(
            price: (43240 - index * 10).toString(),
            amount: '${(1.5 + index * 0.2).toStringAsFixed(3)}',
            isAsk: false,
          )),
        ],
      ),
    );
  }

  Widget _buildOrderItem({required String price, required String amount, required bool isAsk}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: TextStyle(
              color: isAsk ? Color(0xFFF6465D) : Color(0xFF0ECB81),
              fontSize: 12,
            ),
          ),
          Text(
            amount,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}