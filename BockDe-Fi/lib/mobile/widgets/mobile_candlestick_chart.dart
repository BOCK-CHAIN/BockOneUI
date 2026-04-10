import 'package:flutter/material.dart';

class MobileCandlestickChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              color: Color(0xFFF0B90B),
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Candlestick Chart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'Chart implementation would go here',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}