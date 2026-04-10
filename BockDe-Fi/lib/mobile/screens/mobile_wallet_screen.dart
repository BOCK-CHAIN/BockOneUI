import 'package:flutter/material.dart';
import '../widgets/mobile_balance_card.dart';
import '../widgets/mobile_asset_list.dart';

class MobileWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          MobileBalanceCard(),
          SizedBox(height: 20),
          MobileAssetList(),
        ],
      ),
    );
  }
}