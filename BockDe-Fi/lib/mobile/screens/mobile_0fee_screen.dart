import 'package:flutter/material.dart';

class Mobile0FeeScreen extends StatefulWidget {
  const Mobile0FeeScreen({Key? key}) : super(key: key);

  @override
  State<Mobile0FeeScreen> createState() => _Mobile0FeeScreenState();
}

class _Mobile0FeeScreenState extends State<Mobile0FeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),
            
            // Join Free Spot Crypto Section
            _buildJoinFreeSection(),
            
            // Campaign Details
            _buildCampaignDetails(),
            
            // How to Participate
            _buildHowToParticipate(),
            
            // Terms and Conditions
            _buildTermsAndConditions(),
            
            // Bottom Padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zero Fees on Buying, Selling Crypto and EUR Deposits via Card',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'New to BOCK De-FI? Buy crypto for 0% fees and make EUR deposits with 0% fees when using your card.',
            style: TextStyle(
              color: Color(0xFF8A8E95),
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          // Timer Section
          Row(
            children: [
              const Text(
                'Ends in:',
                style: TextStyle(
                  color: Color(0xFF8A8E95),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              _buildTimeBox('11'),
              const Text(' : ', style: TextStyle(color: Colors.white, fontSize: 20)),
              _buildTimeBox('18'),
              const Text(' : ', style: TextStyle(color: Colors.white, fontSize: 20)),
              _buildTimeBox('39'),
              const Text(' : ', style: TextStyle(color: Colors.white, fontSize: 20)),
              _buildTimeBox('57'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              SizedBox(width: 60),
              Text('Days', style: TextStyle(color: Color(0xFF8A8E95), fontSize: 12)),
              SizedBox(width: 16),
              Text('Hrs', style: TextStyle(color: Color(0xFF8A8E95), fontSize: 12)),
              SizedBox(width: 20),
              Text('Min', style: TextStyle(color: Color(0xFF8A8E95), fontSize: 12)),
              SizedBox(width: 18),
              Text('Sec', style: TextStyle(color: Color(0xFF8A8E95), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          
          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Join Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2C2F33)),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildJoinFreeSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JOIN FREE',
                      style: TextStyle(
                        color: Color.fromARGB(255, 122, 79, 223),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'SPOT CRYPTO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Enjoy commission-free spot trading and 0% fees on EUR card deposits. Perfect for new users to start their crypto journey.',
            style: TextStyle(
              color: Color(0xFF8A8E95),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Campaign Period: 2024-01-15 08:00 (UTC) to 2024-12-31 23:59 (UTC)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How To Participate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildParticipationStep(
            '1',
            'Complete Account Verification',
            'Verify your identity to unlock zero-fee trading benefits.',
          ),
          _buildParticipationStep(
            '2',
            'Make Your First Card Deposit',
            'Deposit EUR using your card with 0% fees for new users.',
          ),
          _buildParticipationStep(
            '3',
            'Start Trading',
            'Begin spot trading with zero fees on selected trading pairs.',
          ),
          _buildParticipationStep(
            '4',
            'Enjoy the Benefits',
            'Continue trading with reduced fees and exclusive benefits.',
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF8A8E95),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToParticipate() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eligibility Criteria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('New BOCK De-FI users who register during the campaign period'),
          _buildBulletPoint('Users must complete Level 2 identity verification'),
          _buildBulletPoint('Minimum deposit amount: €10 equivalent'),
          _buildBulletPoint('Valid for EUR card deposits only'),
          const SizedBox(height: 20),
          
          const Text(
            'Benefits',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('0% fees on EUR card deposits'),
          _buildBulletPoint('Zero maker and taker fees on spot trading'),
          _buildBulletPoint('Access to exclusive trading pairs'),
          _buildBulletPoint('Priority customer support'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 122, 79, 223),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF8A8E95),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2C2F33)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promotion Terms & Conditions:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '• This promotion is valid for new BOCK De-FI users only.\n'
            '• Users must complete KYC verification to participate.\n'
            '• Zero fees apply to the first €1000 in card deposits.\n'
            '• Spot trading fees waived for the first 30 days.\n'
            '• BOCK De-FI reserves the right to modify or cancel this promotion.\n'
            '• Standard terms and conditions apply.\n'
            '• Promotion cannot be combined with other offers.',
            style: TextStyle(
              color: Color(0xFF8A8E95),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'For More Information:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: const Text(
              '• Check Terms and Conditions here\n'
              '• Visit our Help Center\n'
              '• Contact Customer Support',
              style: TextStyle(
                color: Color.fromARGB(255, 122, 79, 223),
                fontSize: 13,
                decoration: TextDecoration.underline,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}