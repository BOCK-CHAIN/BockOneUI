import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileRWUSDScreen extends StatefulWidget {
  const MobileRWUSDScreen({Key? key}) : super(key: key);

  @override
  State<MobileRWUSDScreen> createState() => _MobileRWUSDScreenState();
}

class _MobileRWUSDScreenState extends State<MobileRWUSDScreen> {
  double currentAPR = 4.2;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAPRUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAPRUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        final random = Random();
        // Slight fluctuation in APR between 3.8% and 4.6%
        currentAPR = 3.8 + (random.nextDouble() * 0.8);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'RWUSD',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.question_mark,
                color: Colors.black,
                size: 16,
              ),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Logo
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Principal-protected, Reliable yield',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      const Text(
                        'supported by US Treasury Bills.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'R',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Reference APR Section
            Row(
              children: [
                const Text(
                  'Reference APR',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    size: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${currentAPR.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Redeem',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SubscribeRWUSDScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Start Earning Section
            const Text(
              'Start Earning in 3 Steps',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            
            // Steps
            _buildStep(
              1,
              'Deposit & Subscribe',
              'Subscribe stablecoins to receive RWUSD on a 1:1 basis.',
            ),
            const SizedBox(height: 25),
            _buildStep(
              2,
              'Earn Rewards',
              'Rewards distributed daily in RWUSD to your Spot Account.',
            ),
            const SizedBox(height: 25),
            _buildStep(
              3,
              'Redemption',
              'Redeem RWUSD back to USDC on a 1:1 basis anytime.',
            ),
            const SizedBox(height: 40),
            
            // What is RWUSD Section
            const Text(
              'What is RWUSD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'RWUSD is the representation of your subscribed assets and any accrued rewards valued in USDC, and is not a stablecoin or right to any RWAs. The value of RWUSD is pegged 1:1 to the stablecoin you subscribe with. Upon redemption, your RWUSD is redeemed to USDC. The APR is determined at BOCK De-Fi\'s discretion and is funded by',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            
            // Learn More Link
            const Text(
              'Learn more about RWUSD',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 122, 79, 223),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            
            // Advantages Section
            const Text(
              'Advantages of holding RWUSD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            
            // Advantage Items
            _buildAdvantage(
              'Supported by Real-World Assets',
              'The yield is supported by income generated from BOCK De-Fi\'s ecosystem and real-world assets such as tokenized US Treasury Bills, enhancing product sustainability.',
            ),
            const SizedBox(height: 25),
            _buildAdvantage(
              'Principal Protection',
              'Your principal investment is protected, providing a safer way to earn yield compared to more volatile assets.',
            ),
            const SizedBox(height: 25),
            _buildAdvantage(
              'Flexible Subscription and Redemption',
              'You can subscribe and redeem RWUSD anytime, offering high liquidity and convenience to manage your assets.',
            ),
            const SizedBox(height: 25),
            _buildAdvantage(
              'Collateral for VIP Loans',
              'RWUSD can be used as collateral for VIP loans on BOCK De-Fi, providing additional financial flexibility and borrowing power while earning yields.',
            ),
            const SizedBox(height: 40),
            
            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Redeem',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SubscribeRWUSDScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvantage(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.diamond,
            color: const Color.fromARGB(255, 122, 79, 223),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Subscribe RWUSD Screen
class SubscribeRWUSDScreen extends StatefulWidget {
  const SubscribeRWUSDScreen({Key? key}) : super(key: key);

  @override
  State<SubscribeRWUSDScreen> createState() => _SubscribeRWUSDScreenState();
}

class _SubscribeRWUSDScreenState extends State<SubscribeRWUSDScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isAmountEmpty = true;
  double currentAPR = 4.2;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {
        _isAmountEmpty = _amountController.text.isEmpty;
      });
    });
    _startAPRUpdates();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAPRUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        final random = Random();
        currentAPR = 3.8 + (random.nextDouble() * 0.8);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Subscribe RWUSD',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.question_mark,
                color: Colors.black,
                size: 16,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Section
            const Text(
              'Amount',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            // Amount Input Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'Min 0.1',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'T',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'USDT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'MAX',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Available Balance
            Row(
              children: [
                const Text(
                  'Avail (2 accounts) 0 USDT',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Top up',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 122, 79, 223),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Daily Available Limit 15,000,000 USDT',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            // Arrow Down
            const Center(
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 20),
            
            // Receive Section
            const Text(
              'Receive',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            // Receive Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    '--',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'R',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'RWUSD',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Conversion Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Conversion Ratio', '1 USDT = 1 RWUSD'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Reference APR', '${currentAPR.toStringAsFixed(1)}%'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Monthly Est. Reward ▼', '-- RWUSD', color: Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Tabs
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 122, 79, 223),
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                const Text(
                  'Product Rules',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Summary Details
            _buildSummaryItem('Subscription Date', '2025-09-26 00:00'),
            const SizedBox(height: 16),
            _buildSummaryItem('Est. Rewards Start Accruing', '2025-09-26 05:30'),
            const SizedBox(height: 16),
            _buildSummaryItem('Rewards Distribution Date', '2025-09-27 15:30'),
            
            const Spacer(),
            
            // Next Button
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isAmountEmpty ? null : () {
                  // Handle next action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAmountEmpty ? Colors.grey.shade300 : const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: _isAmountEmpty ? Colors.grey : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}