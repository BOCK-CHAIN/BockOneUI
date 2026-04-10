import 'package:flutter/material.dart';

class MobileSpotColoScreen extends StatefulWidget {
  const MobileSpotColoScreen({Key? key}) : super(key: key);

  @override
  State<MobileSpotColoScreen> createState() => _MobileSpotColoScreenState();
}

class _MobileSpotColoScreenState extends State<MobileSpotColoScreen> {
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
        title: const Text(
          'BOCK De-Fi Spot Colosseum',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Ongoing Campaigns Section
            _buildSectionTitle('ONGOING CAMPAIGNS'),
            const SizedBox(height: 8),
            _buildSectionSubtitle('Explore our campaigns and earn rewards by trading your favourite crypto assets.'),
            const SizedBox(height: 16),
            
            // Ongoing Campaign Cards
            ..._buildOngoingCampaigns(),
            
            const SizedBox(height: 32),
            
            // Past Campaigns Section
            _buildSectionTitle('PAST CAMPAIGNS'),
            const SizedBox(height: 8),
            _buildSectionSubtitle('See the exciting rewards you may have missed from previous campaigns.'),
            const SizedBox(height: 16),
            
            // Past Campaign Cards
            ..._buildPastCampaigns(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 122, 79, 223), width: 1),
      ),
      child: Column(
        children: [
          // Colosseum Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance,
              color: Color.fromARGB(255, 122, 79, 223),
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'BOCK De-Fi SPOT COLOSSEUM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your ultimate hub for Spot trading campaigns on BOCK De-Fi. Dive in, trade crypto, and win a share of the prize pools.',
            textAlign: TextAlign.center,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(
        color: Color(0xFF8A8E95),
        fontSize: 14,
        height: 1.4,
      ),
    );
  }

  List<Widget> _buildOngoingCampaigns() {
    final campaigns = [
      {
        'title': 'JOIN HEM NEW LISTING CAMPAIGN',
        'icon': Icons.monetization_on,
        'iconColor': Color.fromARGB(255, 122, 79, 223),
        'backgroundColor': Color(0xFF2B1B0C),
        'prizePool': '50,000 HEM (≈274,000)',
        'endDate': 'Ends at 2024-10-09 11:59 UTC',
        'status': 'ONGOING',
      },
      {
        'title': 'JOIN BARD NEW LISTING CAMPAIGN',
        'icon': Icons.token,
        'iconColor': Color(0xFF00D4AA),
        'backgroundColor': Color(0xFF0C2B20),
        'prizePool': '2,000,000 BARD Prize Pool',
        'endDate': 'Ends at 2024-10-10 23:59 UTC',
        'status': 'ONGOING',
      },
      {
        'title': 'JOIN ZKC NEW LISTING CAMPAIGN',
        'icon': Icons.currency_bitcoin,
        'iconColor': Color(0xFF8B7355),
        'backgroundColor': Color(0xFF2B241C),
        'prizePool': '1,500,000 ZKC Prize Pool',
        'endDate': 'Ends at 2024-10-11 23:59 UTC',
        'status': 'ONGOING',
      },
      {
        'title': 'JOIN HOLO NEW LISTING CAMPAIGN',
        'icon': Icons.blur_circular,
        'iconColor': Color(0xFF00C7E6),
        'backgroundColor': Color(0xFF0C1F2B),
        'prizePool': '7,500,000 HOLO Token Vouchers',
        'endDate': 'Ends at 2024-10-12 11:59 UTC',
        'status': 'ONGOING',
      },
      {
        'title': 'JOIN AVAT CAMPAIGN',
        'icon': Icons.trending_up,
        'iconColor': Color(0xFF7B68EE),
        'backgroundColor': Color(0xFF1C1A2B),
        'prizePool': '5,000,000 AVAT Prize Pool',
        'endDate': 'Ends at 2024-10-13 23:59 UTC',
        'status': 'ONGOING',
      },
      {
        'title': 'JOIN PUMP NEW LISTING CAMPAIGN',
        'icon': Icons.waterfall_chart,
        'iconColor': Color(0xFF32CD32),
        'backgroundColor': Color(0xFF0F2B0F),
        'prizePool': '900,000 UNI in PUMP Token Vouchers',
        'endDate': 'Ends at 2024-10-14 11:59 UTC',
        'status': 'ONGOING',
      },
    ];

    return campaigns.map((campaign) => 
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildCampaignCard(campaign),
      )
    ).toList();
  }

  List<Widget> _buildPastCampaigns() {
    final campaigns = [
      {
        'title': 'JOIN LINEA NEW LISTING CAMPAIGN',
        'icon': Icons.linear_scale,
        'iconColor': Color(0xFF40E0D0),
        'backgroundColor': Color(0xFF0C2B2A),
        'prizePool': '70,000 BNB LINEA Token Vouchers',
        'endDate': 'Ended at 2024-09-31 23:59 UTC',
        'status': 'ENDED',
      },
    ];

    return campaigns.map((campaign) => 
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildCampaignCard(campaign),
      )
    ).toList();
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    final isOngoing = campaign['status'] == 'ONGOING';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOngoing ? const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3) : const Color(0xFF2C2F33),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Campaign Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Campaign Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: campaign['backgroundColor'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    campaign['icon'],
                    color: campaign['iconColor'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Campaign Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'BOCK De-Fi',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'SPOT CAMPAIGNS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Share Button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Color(0xFF8A8E95),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Prize Pool Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF161A1E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: const Color(0xFF8A8E95),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Grab a Share of the ${campaign['prizePool']}',
                  style: const TextStyle(
                    color: Color(0xFF8A8E95),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // End Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0F1114),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: const Color(0xFF8A8E95),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  campaign['endDate'],
                  style: const TextStyle(
                    color: Color(0xFF8A8E95),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOngoing ? const Color(0xFF00C851).withOpacity(0.2) : const Color(0xFF8A8E95).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    campaign['status'],
                    style: TextStyle(
                      color: isOngoing ? const Color(0xFF00C851) : const Color(0xFF8A8E95),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}