import 'package:bockchain/mobile/screens/mobile_0fee_screen.dart';
import 'package:bockchain/mobile/screens/mobile_accountstate_screen.dart';
import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_alphaevents_screen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_copytrading_screen.dart';
import 'package:bockchain/mobile/screens/mobile_customerservice_screen.dart';
import 'package:bockchain/mobile/screens/mobile_depwith_screen.dart';
import 'package:bockchain/mobile/screens/mobile_disable_screen.dart';
import 'package:bockchain/mobile/screens/mobile_discountbuy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_dualinvest_screen.dart';
import 'package:bockchain/mobile/screens/mobile_earn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_ethstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futuremasters_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futures_screen.dart';
import 'package:bockchain/mobile/screens/mobile_launchpool_screen.dart';
import 'package:bockchain/mobile/screens/mobile_learnearn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_loan_screen.dart';
import 'package:bockchain/mobile/screens/mobile_newlisting_screen.dart';
import 'package:bockchain/mobile/screens/mobile_options_screem.dart';// hide MobileOptionsScreen; //hide MobileOptionsScreen;
import 'package:bockchain/mobile/screens/mobile_otc_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_referral_screen.dart';
import 'package:bockchain/mobile/screens/mobile_rewards_screen.dart';
import 'package:bockchain/mobile/screens/mobile_rwusd_screen.dart';
import 'package:bockchain/mobile/screens/mobile_sharia_screen.dart';
import 'package:bockchain/mobile/screens/mobile_simpleearn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_softstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_solstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spot_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spotcolo_screen.dart';
import 'package:bockchain/mobile/screens/mobile_square_screen.dart';
import 'package:bockchain/mobile/screens/mobile_transfer_screen.dart';
import 'package:bockchain/mobile/screens/mobile_wallet_screen.dart';
import 'package:bockchain/mobile/screens/mobile_yeildarena_screen.dart';
import 'package:bockchain/mobile/screens/smart_arbitrage_screen.dart';
import 'package:bockchain/mobile/screens/wallet_home_screen.dart';
import 'package:flutter/material.dart';

class MobileServiceScreen extends StatelessWidget {
  const MobileServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search more services',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            
            // Shortcut Section
            _buildShortcutSection(),
            
            const SizedBox(height: 16),
            
            _buildSectionWithGrid(context, 'Recommend', _buildRecommendItems(context)),
            
            const SizedBox(height: 16),

            // Common Function Section
            _buildSectionWithGrid(context, 'Common Function', _buildCommonFunctionItems(context)),
            
            const SizedBox(height: 16),
            
            // Gift & Campaign Section
            _buildSectionWithGrid(context, 'Gift & Campaign', _buildGiftCampaignItems(context)),
            
            const SizedBox(height: 16),
            
            // Trade Section
            _buildSectionWithGrid(context, 'Trade', _buildTradeItems(context)),
            
            const SizedBox(height: 16),
            
            // Earn Section
            _buildSectionWithGrid(context, 'Earn', _buildEarnItems(context)),
            
            const SizedBox(height: 16),
            
            // Finance Section
            _buildSectionWithGrid(context, 'Finance', _buildFinanceItems(context)),
            
            const SizedBox(height: 16),
            
            // Information Section
            _buildSectionWithGrid(context, 'Information', _buildInformationItems(context)),
            
            const SizedBox(height: 16),
            
            // Help & Support Section
            _buildSectionWithGrid(context, 'Help & Support', _buildHelpSupportItems(context)),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionWithGrid(BuildContext context, String title, List<Widget> items) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shortcut',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add to Homepage'),
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: const Color.fromARGB(255, 122, 79, 223),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShortcutIcon(Icons.qr_code_scanner, 'Scanner'),
              _buildShortcutIcon(Icons.settings, 'Settings'),
              _buildShortcutIcon(Icons.person_outline, 'Profile'),
              _buildShortcutIcon(Icons.notifications_outlined, 'Notifications'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 122, 79, 223), size: 24),
        ),
      ],
    );
  }

  List<Widget> _buildRecommendItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.list, 'New Listing', () => _navigateToScreen(context,'MobileNewListingPromosScreen')),
      _buildServiceItem(Icons.wallet, 'Simple Earn', () => _navigateToScreen(context,'MobileSimpleEarnScreen')),
      _buildServiceItem(Icons.h_plus_mobiledata_rounded, 'Referral', () => _navigateToScreen(context,'MobileReferralScreen')),
      _buildServiceItem(Icons.event_seat_outlined, 'Alpha Events', () => _navigateToScreen(context,'MobileAlphaEventsScreen')),
      _buildServiceItem(Icons.event_seat_outlined, 'P2P', () => _navigateToScreen(context,'MobileP2PScreen')),
      //_buildServiceItem(Icons.square, 'Square', () => _navigateToScreen(context,'MobileSquareScreen')),
    ];
  }

  List<Widget> _buildCommonFunctionItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.double_arrow_outlined, 'Transfer', () => _navigateToScreen(context,'MobileTransferScreen')),
      _buildServiceItem(Icons.wallet, 'BOCK De-Fi Wallet', () => _navigateToScreen(context,'MobileWalletScreen')),
      _buildServiceItem(Icons.wallet_membership_outlined, 'Buy Crypto', () => _navigateToScreen(context,'MobileBuyScreen')),
      _buildServiceItem(Icons.disabled_by_default_outlined, 'Disable Account', () => _navigateToScreen(context,'MobileDisableScreen')),
      _buildServiceItem(Icons.account_balance_outlined, 'Account Statement', () => _navigateToScreen(context,'MobileAccountstateScreen')),
      _buildServiceItem(Icons.launch_outlined, 'Launchpool', () => _navigateToScreen(context,'MobileLaunchpoolScreen')),
      _buildServiceItem(Icons.person_outline, 'Referral', () => _navigateToScreen(context,'MobileReferralScreen')),
    ];
  }

  List<Widget> _buildGiftCampaignItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.add_circle_outline, 'New Listing\nPromos', () => _navigateToScreen(context,'MobileNewListingPromosScreen')),
      _buildServiceItem(Icons.stadium, 'Spot\nColosseum', () => _navigateToScreen(context,'MobileSpotColosseumScreen')),
      _buildServiceItem(Icons.credit_card_off, '0 Fees via Card', () => _navigateToScreen(context,'Mobile0FeesViaCardScreen')),
      _buildServiceItem(Icons.card_giftcard, 'Refer & Win\nBNB', () => _navigateToScreen(context,'MobileReferWinBNBScreen')),
      _buildServiceItem(Icons.stars, 'Rewards Hub', () => _navigateToScreen(context,'MobileRewardsHubScreen')),
      _buildServiceItem(Icons.trending_up, 'Futures\nMasters', () => _navigateToScreen(context,'MobileFuturesMastersScreen')),
      _buildServiceItem(Icons.school, 'Learn & Earn', () => _navigateToScreen(context,'MobileLearnEarnScreen')),
      _buildServiceItem(Icons.event, 'Alpha Events', () => _navigateToScreen(context,'MobileAlphaEventsScreen')),
    ];
  }

  List<Widget> _buildTradeItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.circle_outlined, 'Spot', () => _navigateToScreen(context,'MobileSpotScreen')),
      _buildServiceItem(Icons.add_circle_outlined, 'Alpha', () => _navigateToScreen(context,'MobileAlphaScreen')),
      //_buildServiceItem(Icons.list, 'Futures', () => _navigateToScreen(context,'MobileFuturesScreen')),
      _buildServiceItem(Icons.copy, 'Copy Trading', () => _navigateToScreen(context,'MobileCopyTradingScreen')),
      _buildServiceItem(Icons.camera, 'OTC', () => _navigateToScreen(context,'MobileOTCScreen')),
      _buildServiceItem(Icons.people, 'P2P', () => _navigateToScreen(context,'MobileP2PScreen')),
      _buildServiceItem(Icons.bar_chart, 'Options', () => _navigateToScreen(context,'MobileOptionsScreen')),
    ];
  }

  List<Widget> _buildEarnItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.monetization_on, 'Earn', () => _navigateToScreen(context,'MobileEarnScreen')),
      _buildServiceItem(Icons.layers, 'SOL Staking', () => _navigateToScreen(context,'MobileSOLStakingScreen')),
      _buildServiceItem(Icons.smart_toy, 'Smart\nArbitrage', () => _navigateToScreen(context,'MobileSmartArbitrageScreen')),
      _buildServiceItem(Icons.account_balance, 'Yield Arena', () => _navigateToScreen(context,'MobileYieldArenaScreen')),
      _buildServiceItem(Icons.discount, 'Discount Buy', () => _navigateToScreen(context,'MobileDiscountBuyScreen')),
      _buildServiceItem(Icons.circle, 'RWUSD', () => _navigateToScreen(context,'MobileRWUSDScreen')),
      //_buildServiceItem(Icons.circle, 'BFUSD', () => _navigateToScreen(context,'MobileBFUSDScreen')),
      _buildServiceItem(Icons.trending_up, 'Soft Staking', () => _navigateToScreen(context,'MobileSoftStakingScreen')),
      _buildServiceItem(Icons.monetization_on, 'Simple Earn', () => _navigateToScreen(context,'MobileSimpleEarnScreen')),
      _buildServiceItem(Icons.account_balance_wallet, 'ETH Staking', () => _navigateToScreen(context,'MobileETHStakingScreen')),
      _buildServiceItem(Icons.insights, 'Dual\nInvestment', () => _navigateToScreen(context,'MobileDualInvestmentScreen')),
    ];
  }

  List<Widget> _buildFinanceItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.handshake, 'Loans', () => _navigateToScreen(context,'MobileLoansScreen')),
      _buildServiceItem(Icons.savings, 'Sharia Earn', () => _navigateToScreen(context,'MobileShariaEarnScreen')),
    ];
  }

  List<Widget> _buildInformationItems(BuildContext context) {
    return [
      //_buildServiceItem(Icons.square_outlined, 'Square', () => _navigateToScreen(context,'MobileSquareScreen')),
      _buildServiceItem(Icons.description, 'Deposit &\nWithdrawal St...', () => _navigateToScreen(context,'MobileDepositWithdrawalScreen')),
    ];
  }

  List<Widget> _buildHelpSupportItems(BuildContext context) {
    return [
      _buildServiceItem(Icons.headset_mic, 'Customer\nService', () => _navigateToScreen(context,'MobileCustomerServiceScreen')),
    ];
  }

  Widget _buildServiceItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    Widget screen;
    
    switch (screenName) {
      case 'MobileTransferScreen':
        screen = MobileTransferScreen();
        break;
      case 'MobileWalletScreen':
        screen = WalletHomeScreen();
        break;
      case 'MobileBuyScreen':
        screen = MobileBuyScreen();
        break;
      case 'MobileDisableScreen':
        screen = MobileDisableScreen();
        break;
      case 'MobileAccountstateScreen':
        screen = MobileAccountStateScreen();
        break;
      case 'MobileLaunchpoolScreen':
        screen = MobileLaunchpoolScreen();
        break;
      case 'MobileReferralScreen':
        screen = MobileReferralScreen();
        break;
      case 'MobileNewListingPromosScreen':
        screen = MobileNewListingScreen();
        break;
      case 'MobileSpotColosseumScreen':
        screen = MobileSpotColoScreen();
        break;
      case 'Mobile0FeesViaCardScreen':
        screen = Mobile0FeeScreen();
        break;
      case 'MobileReferWinBNBScreen':
        screen = MobileReferralScreen();
        break;
      case 'MobileRewardsHubScreen':
        screen = MobileRewardsScreen();
        break;
      case 'MobileFuturesMastersScreen':
        screen = MobileFutureMastersScreen();
        break;
      case 'MobileLearnEarnScreen':
        screen = MobileLearnEarnScreen();
        break;
      case 'MobileAlphaEventsScreen':
        screen = MobileAlphaEventsScreen();
        break;
      case 'MobileSpotScreen':
        screen = MobileSpotScreen();
        break;
      case 'MobileAlphaScreen':
        screen = MobileAlphaScreen();
        break;
      /*case 'MobileFuturesScreen':
        screen = MobileFuturesScreen(walletService: widget.walletService);
        break;*/
      case 'MobileCopyTradingScreen':
        screen = MobileCopyTradingScreen();
        break;
      case 'MobileOTCScreen':
        screen = MobileOtcScreen();
        break;
      case 'MobileP2PScreen':
        screen = MobileP2pScreen();
        break;
      case 'MobileOptionsScreen':
        screen = MobileOptionsScreen();
        break;
      case 'MobileEarnScreen':
        screen = MobileEarnScreen();
        break;
      case 'MobileSOLStakingScreen':
        screen = MobileSolStakingScreen();
        break;
      case 'MobileSmartArbitrageScreen':
        screen = SmartArbitrageScreen();
        break;
      case 'MobileYieldArenaScreen':
        screen = MobileYieldArenaScreen();
        break;
      case 'MobileDiscountBuyScreen':
        screen = MobileDiscountBuyScreen();
        break;
      case 'MobileRWUSDScreen':
        screen = MobileRWUSDScreen();
        break;
      case 'MobileBFUSDScreen':
        screen = MobileRWUSDScreen();
        break;
      case 'MobileSoftStakingScreen':
        screen = MobileSoftStakingScreen();
        break;
      case 'MobileSimpleEarnScreen':
        screen = MobileSimpleEarnScreen();
        break;
      case 'MobileETHStakingScreen':
        screen = MobileEthStakingScreen();
        break;
      case 'MobileDualInvestmentScreen':
        screen = MobileDualInvestScreen();
        break;
      case 'MobileLoansScreen':
        screen = MobileLoanScreen();
        break;
      case 'MobileShariaEarnScreen':
        screen = MobileShariaScreen();
        break;
      case 'MobileSquareScreen':
        screen = MobileSquareScreen();
        break;
      case 'MobileDepositWithdrawalScreen':
        screen = MobileDepWithStatusScreen();
        break;
      case 'MobileCustomerServiceScreen':
        screen = MobileCustomerServiceScreen();
        break;
      default:
        return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
