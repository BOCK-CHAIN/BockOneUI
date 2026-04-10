import 'package:flutter/material.dart';

class MobileYieldArenaScreen extends StatefulWidget {
  const MobileYieldArenaScreen({Key? key}) : super(key: key);

  @override
  State<MobileYieldArenaScreen> createState() => _MobileYieldArenaScreenState();
}

class _MobileYieldArenaScreenState extends State<MobileYieldArenaScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BOCK De-Fi Earn Yield Arena',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with arena illustration
            _buildHeaderSection(screenWidth, screenHeight),
            
            const SizedBox(height: 24),
            
            // Disclaimer
            _buildDisclaimer(),
            
            const SizedBox(height: 32),
            
            // Token Giveaway Campaigns Title
            const Text(
              'Token Giveaway Campaigns',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Campaign Cards
            _buildUSDCCampaign(screenWidth),
            const SizedBox(height: 16),
            _buildBNBAICampaign(screenWidth),
            const SizedBox(height: 16),
            _buildSOLCampaign(screenWidth),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double screenWidth, double screenHeight) {
    return Column(
      children: [
        // Arena illustration
        Container(
          width: screenWidth * 0.6,
          height: screenHeight * 0.15,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Arena base
              Container(
                width: screenWidth * 0.5,
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              // Arena entrance
              Positioned(
                bottom: 0,
                child: Container(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.04,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Floating icons
              Positioned(
                top: screenHeight * 0.02,
                left: screenWidth * 0.1,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, color: Colors.black, size: 20),
                ),
              ),
              Positioned(
                top: screenHeight * 0.01,
                right: screenWidth * 0.15,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.diamond, color: Colors.black, size: 18),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.06,
                left: screenWidth * 0.05,
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title and description
        const Text(
          'BOCK De-Fi Earn - Yield Arena',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.white),
            children: [
              TextSpan(text: 'Your One-Stop Earn Campaign Center.\n'),
              TextSpan(
                text: 'Over \$1,000,000 in Rewards Up For Grabs!',
                style: TextStyle(color: Color.fromARGB(255, 122, 79, 223), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Discover all opportunities for your idle assets—start maximizing your returns today!',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'This is a general announcement and marketing communication. Products and services referred to here may not be available in your region.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[400],
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildUSDCCampaign(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 122, 79, 223), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon section
          Container(
            width: 80,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.attach_money, color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.attach_money, color: Colors.white, size: 20),
                  ),
                ),
                const Positioned(
                  left: 15,
                  bottom: 0,
                  child: Icon(Icons.trending_up, color: Color.fromARGB(255, 122, 79, 223), size: 24),
                ),
                const Positioned(
                  right: 15,
                  bottom: 0,
                  child: Icon(Icons.trending_up, color: Color.fromARGB(255, 122, 79, 223), size: 24),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Hold USDc to enjoy 12% APR Rewards',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'From 2025-09-22 00:00 (UTC) to 2025-10-21 23:59 (UTC), eligible users who hold a minimum of 0.01 USDc in their BOCK De-Fi account(s) for at least 24 hours can enjoy 12% APR rewards.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Explore Now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBNBAICampaign(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parachute icon
          Container(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Parachute canopy
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 122, 79, 223)!,
                        const Color.fromARGB(255, 47, 22, 105)!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                // Parachute lines
                for (int i = 0; i < 4; i++)
                  Positioned(
                    top: 35,
                    left: 15 + (i * 12.0),
                    child: Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                // Package
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Subscribe to BNB & AI Earn Products to Share \$300,000 in AI Rewards, with BNB Loyalty Bonus',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'Promotion Period: 2025-09-18 00:00 (UTC) to 2025-10-01 23:59 (UTC)\nTop 800 users will be ranked by their Total Campaign Scores on the leaderboard for a chance to share 2,691,696 AI tokens in tiered Rewards.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Register Now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSOLCampaign(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SOL orbital system
          Container(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer orbit
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 122, 79, 223)!, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
                // Middle orbit
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 138, 91, 247)!, width: 1.5),
                    shape: BoxShape.circle,
                  ),
                ),
                // Inner orbit
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 156, 116, 248)!, width: 1),
                    shape: BoxShape.circle,
                  ),
                ),
                // Center SOL logo
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple[400]!,
                        Colors.blue[400]!,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Orbital elements
                Positioned(
                  top: 10,
                  right: 30,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Ongoing badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Ongoing',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'SOL Flexible Product: Share 25 Billion PEPE Rewards',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'All eligible users who make new subscriptions with at least 3 SOL to SOL Flexible Products will have a chance to Share 25 Billion PEPE rewards!\nPromotion Period: 2025-09-18 00:00 (UTC) to 2025-10-02 23:59 (UTC)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Explore Now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}