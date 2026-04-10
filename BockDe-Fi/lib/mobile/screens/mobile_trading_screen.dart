import 'package:flutter/material.dart';
import '../widgets/mobile_price_ticker.dart';
import '../widgets/mobile_candlestick_chart.dart';
import '../widgets/mobile_order_book.dart';
import '../widgets/mobile_trade_form.dart';

class MobileTradingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MobilePriceTicker(),
          SizedBox(height: 16),
          MobileCandlestickChart(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: MobileOrderBook()),
              SizedBox(width: 8),
              Expanded(child: MobileTradeForm()),
            ],
          ),
        ],
      ),
    );
  }
}