import 'package:flutter/material.dart';

class MobileNewListingScreen extends StatelessWidget {
  const MobileNewListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Listings on BOCK De-Fi | AI...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderCard(),
            const SizedBox(height: 32),
            
            // Section Title
            const Text(
              'LATEST NEW LISTING\nPROMOTIONS',
              style: TextStyle(
                color: Color.fromARGB(255, 122, 79, 223),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            
            // Promotion Cards
            _buildPromotionCard(
              title: 'SHARE 20M+ \$HEMI',
              subtitle: 'Spot',
              icon: Icons.star,
              iconColor: const Color.fromARGB(255, 122, 79, 223),
              gradientColors: [
                const Color(0xFF2A2A2A),
                const Color(0xFF1A1A1A),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildPromotionCard(
              title: 'SHARE 2.5M \$BARD',
              subtitle: 'Spot • Futures',
              icon: Icons.trending_up,
              iconColor: const Color(0xFF00D4AA),
              gradientColors: [
                const Color(0xFF2A2A2A),
                const Color(0xFF1A1A1A),
              ],
              description: 'Trade \$BARD on BOCK De-Fi Spot & Futures to Grab a Share of the Prize Pool!',
              promotionPeriod: '2025-09-24 10:00 (UTC) to 2025-10-08 10:00 (UTC)',
            ),
            const SizedBox(height: 16),
            
            _buildPromotionCard(
              title: 'SHARE 5M \$PIXEL',
              subtitle: 'Spot • Margin',
              icon: Icons.games,
              iconColor: const Color(0xFF9C27B0),
              gradientColors: [
                const Color(0xFF2A2A2A),
                const Color(0xFF1A1A1A),
              ],
              description: 'Join the PIXEL gaming revolution and earn rewards!',
              promotionPeriod: '2025-09-25 08:00 (UTC) to 2025-10-09 08:00 (UTC)',
            ),
            const SizedBox(height: 16),
            
            _buildPromotionCard(
              title: 'SHARE 1M \$DEGEN',
              subtitle: 'Spot',
              icon: Icons.rocket_launch,
              iconColor: const Color(0xFFFF5722),
              gradientColors: [
                const Color(0xFF2A2A2A),
                const Color(0xFF1A1A1A),
              ],
              description: 'Get rewarded for trading the hottest meme token!',
              promotionPeriod: '2025-09-26 12:00 (UTC) to 2025-10-10 12:00 (UTC)',
            ),
            const SizedBox(height: 16),
            
            _buildPromotionCard(
              title: 'SHARE 10M \$AITECH',
              subtitle: 'Spot • Futures',
              icon: Icons.psychology,
              iconColor: const Color(0xFF2196F3),
              gradientColors: [
                const Color(0xFF2A2A2A),
                const Color(0xFF1A1A1A),
              ],
              description: 'Trade AI Technology tokens and share massive rewards!',
              promotionPeriod: '2025-09-27 06:00 (UTC) to 2025-10-11 06:00 (UTC)',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A),
            const Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // BOCK De-Fi Card Design
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 122, 79, 223),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 122, 79, 223),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 122, 79, 223),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'NEW LISTINGS,\nNEW REWARDS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 122, 79, 223),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore the latest token listings and promotions, exclusively on BOCK De-Fi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradientColors,
    String? description,
    String? promotionPeriod,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Chart Design
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: iconColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          // Chart line decoration
                          Positioned(
                            right: 8,
                            top: 8,
                            child: CustomPaint(
                              size: const Size(30, 20),
                              painter: ChartLinePainter(iconColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        color: iconColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                // Description and promotion period (if provided)
                if (description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
                
                if (promotionPeriod != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Promotion Period: ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          promotionPeriod,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Join Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle join now action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Join Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartLinePainter extends CustomPainter {
  final Color color;
  
  ChartLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.3, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0, size.height * 0.8), 2, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.6), 2, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 2, pointPaint);
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 2, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}