import 'package:flutter/material.dart';

// Main On-Chain Yields Screen
class OnChainYieldsScreen extends StatelessWidget {
  const OnChainYieldsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'On-chain Yields',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Unlock the potential of on-chain rewards\nand stay ahead with earning opportunities.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  );
                },
                child: const Text(
                  'What is On-Chain Yields',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Yield Cards
              YieldCard(
                icon: Icons.attach_money,
                iconColor: Colors.teal,
                title: 'USDT',
                subtitle: 'Aave-Plasma',
                yieldRange: '2.8%~4.5%',
                status: 'Locked',
                onSubscribe: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscribeScreen(
                        token: 'USDT',
                        platform: 'Aave-Plasma',
                        apr: '3.50',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              YieldCard(
                icon: Icons.currency_bitcoin,
                iconColor: Colors.orange,
                title: 'BTC',
                subtitle: 'Solv',
                yieldRange: '0.7%~1.6%',
                status: 'Locked',
                onSubscribe: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscribeScreen(
                        token: 'BTC',
                        platform: 'Solv',
                        apr: '1.20',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              YieldCard(
                icon: Icons.currency_exchange,
                iconColor: Colors.yellow.shade700,
                title: 'WBETH',
                subtitle: 'EigenLayer',
                yieldRange: '0.2%~0.35%',
                status: 'Locked',
                onSubscribe: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscribeScreen(
                        token: 'WBETH',
                        platform: 'EigenLayer',
                        apr: '0.30',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              YieldCard(
                icon: Icons.currency_exchange,
                iconColor: Colors.amber,
                title: 'BNB',
                subtitle: 'Lista',
                yieldRange: '0.2%~0.4%',
                status: 'Locked',
                onSubscribe: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscribeScreen(
                        token: 'BNB',
                        platform: 'Lista',
                        apr: '0.35',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'No more data',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Yield Card Widget
class YieldCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String yieldRange;
  final String status;
  final VoidCallback onSubscribe;

  const YieldCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.yieldRange,
    required this.status,
    required this.onSubscribe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock, size: 16, color: const Color.fromARGB(255, 122, 79, 223)),
                    const SizedBox(width: 4),
                    Text(
                      yieldRange,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  status,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onSubscribe,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}

// FAQ Screen
class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'On-chain Yields',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FAQItem(
            question: '1. What is BOCK De-Fi On-chain Yields?',
            answer: 'BOCK De-Fi On-chain Yields is a feature that allows users to earn rewards by participating in various DeFi protocols directly through BOCK De-Fi. Your assets are deployed to secure, audited smart contracts on different blockchain networks, generating yields from lending, staking, and liquidity provision.',
          ),
          FAQItem(
            question: '2. What types of rewards are available with BOCK De-Fi On-chain Yields?',
            answer: 'Rewards vary depending on the protocol and asset. Common types include lending interest from protocols like Aave, staking rewards from proof-of-stake networks, liquidity mining rewards, and protocol-specific incentives. Rewards are typically paid in the same token you deposit or in the protocol\'s native token.',
          ),
          FAQItem(
            question: '3. Are BOCK De-Fi On-chain Yields returns guaranteed?',
            answer: 'No, returns are not guaranteed. APY rates are estimates based on current market conditions and can fluctuate daily. Actual returns depend on protocol performance, market demand, and network conditions. Past performance does not indicate future results.',
          ),
          FAQItem(
            question: '4. What are the risks of BOCK De-Fi On-chain Yields?',
            answer: 'Risks include smart contract vulnerabilities, market volatility affecting returns, impermanent loss for liquidity provision, protocol-specific risks, blockchain network risks, and the possibility of losing part or all of your principal. Always invest only what you can afford to lose.',
          ),
          FAQItem(
            question: '5. How to participate in BOCK De-Fi On-chain Yields?',
            answer: 'To participate: 1) Navigate to the On-chain Yields section, 2) Select a yield product that suits your needs, 3) Choose your lock-up period (if applicable), 4) Enter the amount you wish to subscribe, 5) Review terms and conditions, 6) Confirm your subscription. Assets will be transferred from your Spot Wallet to the on-chain protocol.',
          ),
          FAQItem(
            question: '6. How are rewards calculated in BOCK De-Fi On-chain Yields?',
            answer: 'Rewards are typically calculated based on APR (Annual Percentage Rate) or APY (Annual Percentage Yield). The calculation depends on your subscribed amount, duration, and the protocol\'s performance. Rewards usually accrue daily and are distributed according to the protocol\'s schedule, which may be daily, weekly, or at maturity.',
          ),
          FAQItem(
            question: '7. When do rewards start to accrue?',
            answer: 'Rewards typically start accruing from the next distribution cycle after your subscription is confirmed and assets are deployed to the on-chain protocol. The first reward distribution date is shown in your subscription details. This usually occurs within 24-48 hours of subscribing.',
          ),
          FAQItem(
            question: '8. Can I redeem assets after subscribing to On-chain Yields product?',
            answer: 'For locked products, you cannot redeem before the interest end date. For flexible products, you can redeem at any time, but there may be a waiting period of 1-7 days for on-chain settlement. Early redemption may result in reduced or no rewards for the redemption period.',
          ),
          FAQItem(
            question: '9. If I redeem assets, will I still receive the rewards during the redemption waiting time?',
            answer: 'This depends on the product type. For flexible products, you typically continue to earn rewards during the redemption waiting period until assets are returned to your wallet. For locked products with early redemption (if available), rewards may be forfeited or reduced. Check specific product terms for details.',
          ),
          FAQItem(
            question: '10. Once I start a redemption, can I stop it?',
            answer: 'Generally, once a redemption request is submitted and confirmed, it cannot be cancelled due to the on-chain nature of the transactions. The redemption process involves smart contract interactions that are irreversible. Make sure you want to proceed before confirming any redemption.',
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: const Text(
          'Not what you\'re looking for?',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// FAQ Item Widget
class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Subscribe Screen
class SubscribeScreen extends StatefulWidget {
  final String token;
  final String platform;
  final String apr;

  const SubscribeScreen({
    Key? key,
    required this.token,
    required this.platform,
    required this.apr,
  }) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  int selectedPeriod = 0;
  bool autoSubscribe = false;
  bool agreedToTerms = false;
  final TextEditingController amountController = TextEditingController();

  final List<Map<String, dynamic>> periods = [
    {'days': '60D', 'apr': '3.50%'},
    {'days': '15D', 'apr': '2.80%'},
    {'days': '30D', 'apr': '3.20%'},
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
        title: Text(
          '${widget.token} Subscribe',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple.shade100,
                    child: Icon(Icons.account_balance, color: const Color.fromARGB(255, 122, 79, 223)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.platform,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Period Selection
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: periods.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedPeriod == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedPeriod = index),
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.purple.shade50 : Colors.white,
                          border: Border.all(
                            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              periods[index]['days'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              periods[index]['apr'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Subscribe Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subscribe Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: autoSubscribe,
                        onChanged: (value) => setState(() => autoSubscribe = value!),
                        activeColor: const Color.fromARGB(255, 122, 79, 223),
                      ),
                      const Text('Auto-Subscribe'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Min 100',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      widget.token,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'MAX',
                        style: TextStyle(color: Color.fromARGB(255, 122, 79, 223), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Avail (2 accounts) 0 ${widget.token}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 164, 125, 255),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle, size: 14, color: Color.fromARGB(255, 122, 79, 223)),
                            SizedBox(width: 4),
                            Text(
                              'Top up',
                              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 122, 79, 223)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Personal Remaining Quota  1,000,000 ${widget.token}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Summary Section
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                      tabs: const [
                        Tab(text: 'Summary'),
                        Tab(text: 'Product Rules'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Locked Est. Rewards',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'APR ${periods[selectedPeriod]['apr']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '0 ${widget.token}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildTimelineItem(
                            'First Rewards Distribution',
                            '2025-10-27 05:30',
                            isFirst: true,
                          ),
                          _buildTimelineItem(
                            'Interest End Date',
                            '2025-12-25 05:30',
                          ),
                          _buildTimelineItem(
                            'Redeem to',
                            '2025-12-26 15:30',
                            isLast: true,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Simple Earn Flexible'),
                                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Disclaimers
              Text(
                '* The APR for the subscribed On-chain Yields Product is subject to daily changes. APR does not mean the actual or predicted returns in fiat currency.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                '* Early redemption will return your assets to your Spot Wallet within 3',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Terms Agreement
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: agreedToTerms,
                    onChanged: (value) => setState(() => agreedToTerms = value!),
                    activeColor: const Color.fromARGB(255, 122, 79, 223),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('I have read and agreed to'),
                        Text(
                          'On-chain Yields Service Terms and Conditions',
                          style: TextStyle(color: Color.fromARGB(255, 122, 79, 223), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: agreedToTerms ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Subscription submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, {bool isFirst = false, bool isLast = false}) {
    return Row(
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: Colors.grey.shade400,
              ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 20,
                color: Colors.grey.shade400,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}