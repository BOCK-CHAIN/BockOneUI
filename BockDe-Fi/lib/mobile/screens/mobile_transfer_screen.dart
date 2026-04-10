import 'package:flutter/material.dart';

class MobileTransferScreen extends StatefulWidget {
  const MobileTransferScreen({Key? key}) : super(key: key);

  @override
  State<MobileTransferScreen> createState() => _MobileTransferScreenState();
}

class _MobileTransferScreenState extends State<MobileTransferScreen> {
  String selectedFromWallet = 'Funding';
  String selectedToWallet = 'Spot Wallet';
  String selectedCoin = '';
  String transferAmount = '';
  
  final TextEditingController _amountController = TextEditingController();

  final List<WalletOption> walletOptions = [
    WalletOption(
      name: 'USD⊖-M Futures',
      balance: '0 BNB',
      icon: Icons.analytics_outlined,
    ),
    WalletOption(
      name: 'Cross Margin',
      balance: '0 BNB',
      icon: Icons.compare_arrows,
    ),
    WalletOption(
      name: 'Funding',
      balance: '0 BNB',
      icon: Icons.account_balance_wallet_outlined,
      isSelected: true,
    ),
    WalletOption(
      name: 'COIN-M Futures',
      balance: '0 BNB',
      icon: Icons.analytics_outlined,
    ),
    WalletOption(
      name: 'Isolated Margin',
      balance: '0 BNB',
      icon: Icons.compare_arrows,
    ),
    WalletOption(
      name: 'Earn-Flexible Assets',
      balance: '0 BNB',
      icon: Icons.savings_outlined,
    ),
    WalletOption(
      name: 'Options',
      balance: '',
      icon: Icons.analytics_outlined,
      isInactive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transfer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From/To Section
                  _buildTransferSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Coin Selection
                  _buildCoinSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Amount Section
                  _buildAmountSection(),
                ],
              ),
            ),
          ),
          
          // Confirm Button
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildTransferSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // From Section
          GestureDetector(
            onTap: () => _showWalletSelector(context, 'from'),
            child: Row(
              children: [
                Text(
                  'From',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedFromWallet,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // To Section
          GestureDetector(
            onTap: () => _showWalletSelector(context, 'to'),
            child: Row(
              children: [
                Text(
                  'To',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Text(
                    selectedToWallet,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coin',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // Handle coin selection
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'No amount available to transfer, please select another coin.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const Text(
                'BNB',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  // Handle max button
                  _amountController.text = '0';
                },
                child: const Text(
                  'Max',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Available -- BNB',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          // Handle confirm transfer
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 122, 79, 223),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Confirm Transfer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showWalletSelector(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Select a wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              
              // Wallet options
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: walletOptions.length,
                  itemBuilder: (context, index) {
                    final option = walletOptions[index];
                    return _buildWalletOption(option, type);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWalletOption(WalletOption option, String type) {
    final bool isCurrentlySelected = (type == 'from' && option.name == selectedFromWallet) ||
                                   (type == 'to' && option.name == selectedToWallet);
    
    return GestureDetector(
      onTap: option.isInactive ? null : () {
        setState(() {
          if (type == 'from') {
            selectedFromWallet = option.name;
          } else {
            selectedToWallet = option.name;
          }
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrentlySelected ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrentlySelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey.shade200,
            width: isCurrentlySelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: option.isInactive ? Colors.grey.shade200 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                option.icon,
                color: option.isInactive ? Colors.grey.shade400 : Colors.black87,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Wallet info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: option.isInactive ? Colors.grey.shade400 : Colors.black,
                    ),
                  ),
                  if (option.balance.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      option.balance,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Selected indicator or inactive label
            if (isCurrentlySelected)
              const Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 122, 79, 223),
                size: 20,
              )
            else if (option.isInactive)
              const Text(
                'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WalletOption {
  final String name;
  final String balance;
  final IconData icon;
  final bool isSelected;
  final bool isInactive;

  WalletOption({
    required this.name,
    required this.balance,
    required this.icon,
    this.isSelected = false,
    this.isInactive = false,
  });
}