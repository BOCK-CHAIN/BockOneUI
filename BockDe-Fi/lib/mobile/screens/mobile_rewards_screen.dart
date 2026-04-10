import 'package:flutter/material.dart';

class MobileRewardsScreen extends StatefulWidget {
  const MobileRewardsScreen({Key? key}) : super(key: key);

  @override
  State<MobileRewardsScreen> createState() => _MobileRewardsScreenState();
}

class _MobileRewardsScreenState extends State<MobileRewardsScreen> {
  int points = 0;
  int vouchers = 0;

  final List<RewardTask> onboardingTasks = [
    RewardTask(
      id: '1',
      title: 'Buy crypto worth at least \$10 and get a \$30 Rebate Voucher',
      description: 'Purchase any cryptocurrency worth at least \$10 to unlock your \$30 trading fee rebate voucher. This offer is valid for new users only.',
      progress: 0,
      target: 10,
      unit: 'USDT',
      reward: '30 USDT Trading Fee Rebate Voucher',
      timeLeft: '06D : 17H : 32M',
      icon: Icons.download_outlined,
      requirements: [
        'Complete KYC verification',
        'Make a purchase of at least \$10',
        'Voucher will be credited within 24 hours',
      ],
    ),
    RewardTask(
      id: '2',
      title: 'Trade crypto worth at least \$10 and get a \$50 Rebate Voucher',
      description: 'Execute trades worth at least \$10 in total volume to receive your \$50 trading fee rebate voucher. Both spot and futures trades count.',
      progress: 0,
      target: 10,
      unit: 'USDT',
      reward: '50 USDT Trading Fee Rebate Voucher',
      timeLeft: '06D : 18H : 32M',
      icon: Icons.sync,
      requirements: [
        'Minimum trade volume: \$10',
        'All trading pairs eligible',
        'Voucher valid for 30 days',
      ],
    ),
    RewardTask(
      id: '3',
      title: 'Complete KYC Verification and earn 100 Points',
      description: 'Verify your identity to unlock full platform features and receive 100 reward points. KYC verification is required for higher trading limits.',
      progress: 0,
      target: 1,
      unit: 'Step',
      reward: '100 Reward Points',
      timeLeft: '10D : 05H : 15M',
      icon: Icons.verified_user_outlined,
      requirements: [
        'Submit valid government ID',
        'Complete facial verification',
        'Process takes 5-10 minutes',
      ],
    ),
    RewardTask(
      id: '4',
      title: 'Deposit \$50 or more and get a \$20 Bonus',
      description: 'Make your first deposit of \$50 or more to receive a \$20 bonus credited to your account. Bonus can be used for trading immediately.',
      progress: 0,
      target: 50,
      unit: 'USDT',
      reward: '20 USDT Bonus',
      timeLeft: '08D : 12H : 45M',
      icon: Icons.account_balance_wallet_outlined,
      requirements: [
        'Minimum deposit: \$50',
        'Bonus credited instantly',
        'Available for withdrawal after 1 trade',
      ],
    ),
    RewardTask(
      id: '5',
      title: 'Refer 3 Friends and earn \$75 in Rewards',
      description: 'Invite your friends to join our platform. When 3 friends sign up and complete their first trade, you\'ll receive \$75 in rewards.',
      progress: 0,
      target: 3,
      unit: 'Referrals',
      reward: '75 USDT Reward',
      timeLeft: '15D : 08H : 20M',
      icon: Icons.people_outline,
      requirements: [
        'Share your unique referral link',
        'Friends must complete KYC',
        'Friends must make at least 1 trade',
      ],
    ),
    RewardTask(
      id: '6',
      title: 'Stake \$100 for 7 days and get 5% APY Bonus',
      description: 'Lock your crypto for 7 days in our staking program to earn an additional 5% APY bonus on top of regular staking rewards.',
      progress: 0,
      target: 100,
      unit: 'USDT',
      reward: '5% APY Bonus Voucher',
      timeLeft: '12D : 22H : 10M',
      icon: Icons.lock_clock_outlined,
      requirements: [
        'Minimum stake: \$100',
        'Lock period: 7 days',
        'Early withdrawal penalty applies',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
        title: const Text(
          'Rewards Hub',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.monetization_on_outlined,
                    iconColor: const Color.fromARGB(255, 122, 79, 223),
                    title: 'Points',
                    value: points.toString(),
                    subtitle: 'Rewards Shop',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.card_giftcard,
                    iconColor: const Color.fromARGB(255, 122, 79, 223),
                    title: 'Vouchers',
                    value: vouchers.toString(),
                    subtitle: 'My Vouchers',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Rewards Illustration
            Center(
              child: Container(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Gift box illustration
                    const Icon(
                      Icons.card_giftcard,
                      size: 60,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                    // Crown/diamond on top
                    Positioned(
                      top: 10,
                      child: Container(
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.diamond,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Get Rewards Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Get Rewards',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'More',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Onboarding Tasks Section
            const Text(
              'Onboarding Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Progress indicator
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Task Cards
            ...onboardingTasks.map((task) => _buildTaskCard(task)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(RewardTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task header with icon and title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  task.icon,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress
          Row(
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Text(
                '${task.progress}/${task.target} ${task.unit}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Reward
          Row(
            children: [
              const Text(
                'Reward',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.card_giftcard,
                size: 16,
                color: Color.fromARGB(255, 122, 79, 223),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  task.reward,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Time left
          Row(
            children: [
              const Text(
                'Time Left to Complete Task',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Text(
                task.timeLeft,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle task action
                    _handleTaskAction(task);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Do Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTaskAction(RewardTask task) {
    // Simulate task completion
    setState(() {
      if (task.progress < task.target) {
        task.progress = (task.progress + 5).clamp(0, task.target);
        
        // Award points when task is completed
        if (task.progress >= task.target) {
          points += 50;
          vouchers += 1;
          
          // Show completion dialog
          _showTaskCompletionDialog(task);
        }
      }
    });
  }

  void _showTaskCompletionDialog(RewardTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task Completed!'),
          content: Text('Congratulations! You\'ve earned: ${task.reward}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Great!'),
            ),
          ],
        );
      },
    );
  }
}

class RewardTask {
  String title;
  int progress;
  int target;
  String unit;
  String reward;
  String timeLeft;
  IconData icon;

  RewardTask({
    required this.title,
    required this.progress,
    required this.target,
    required this.unit,
    required this.reward,
    required this.timeLeft,
    required this.icon, 
    required String id, 
    required String description, 
    required List<String> requirements,
  });
}