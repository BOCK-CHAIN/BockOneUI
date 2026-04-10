import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MobileSquareScreen extends StatefulWidget {
  const MobileSquareScreen({Key? key}) : super(key: key);

  @override
  State<MobileSquareScreen> createState() => _MobileSquareScreenState();
}

class _MobileSquareScreenState extends State<MobileSquareScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _selectedIndex == 0 ? const HomeScreen() : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF8B5CF6),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
      ),
        ),
      ),
    );
  }
}

// Discover Tab
class DiscoverTab extends StatelessWidget {
  const DiscoverTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _buildPostCard(context),
        const SizedBox(height: 12),
        _buildNewsCard(context),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Marcus Corvinus',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.verified, size: 18, color: Colors.blue[700]),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('18h', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Bullish',
                              style: TextStyle(color: Colors.green[700], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '\$PEPE just pumped from 0.000000923 ➜ 0.000000968 with strong momentum. Buyers are defending above 0.000000960, showing bulls still in control. If this zone holds, another breakout attempt looks possible....',
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '0.00000964',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+5.01%',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: CustomPaint(
                    painter: LineChartPainter(),
                    size: const Size(double.infinity, 120),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'My 30 Days\' PNL',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+\$2,739.22',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+15731.74%',
                        style: TextStyle(color: Colors.green[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.chat_bubble_outline, '2', context),
                _buildActionButton(Icons.thumb_up_outlined, '38', context),
                _buildActionButton(Icons.repeat, '2', context),
                _buildActionButton(Icons.share_outlined, '0', context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mariana is coming wrght',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const Text('34m', style: TextStyle(color: Colors.grey, fontSize: 13)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🚨 BREAKING NEWS: The probability of a Fed rate cut in October has skyrocketed to 96.7% 😱🔥',
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count, BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count interactions')),
        );
      },
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
        ],
      ),
    );
  }
}

// Following Tab
class FollowingTab extends StatefulWidget {
  const FollowingTab({Key? key}) : super(key: key);

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab> {
  final List<Map<String, dynamic>> creators = [
    {'name': 'Yi He', 'selected': true},
    {'name': 'Richard Teng', 'selected': true},
    {'name': 'CZ', 'selected': true},
    {'name': 'Faruk Abubakar', 'selected': true},
    {'name': 'Meat Memed', 'selected': true},
    {'name': 'Chumba Money', 'selected': true},
    {'name': 'CeM BNB', 'selected': true},
    {'name': 'CryptoGhost', 'selected': true},
    {'name': 'NFTgators', 'selected': true},
    {'name': 'BitcoinKE', 'selected': true},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCount = creators.where((c) => c['selected'] == true).length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Don\'t Miss',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Follow your favorite creators and read their posts on this page.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: creators.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        creators[index]['selected'] = !creators[index]['selected'];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.grey[800]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[700],
                            child: const Icon(Icons.person, color: Colors.grey, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              creators[index]['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            creators[index]['selected'] ? Icons.check_circle : Icons.circle_outlined,
                            color: creators[index]['selected'] ? Colors.white : Colors.grey,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: selectedCount > 0
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Following $selectedCount creators')),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                disabledBackgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Follow ($selectedCount)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// News Tab with Real API
class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<Map<String, String>> newsItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      // Using NewsAPI - Replace with your API key
      final response = await http.get(
        Uri.parse('https://newsapi.org/v2/everything?q=cryptocurrency&sortBy=publishedAt&apiKey=YOUR_API_KEY'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        
        setState(() {
          newsItems = articles.take(10).map<Map<String, String>>((article) {
            final DateTime publishedAt = DateTime.parse(article['publishedAt']);
            final String time = '${publishedAt.hour.toString().padLeft(2, '0')}:${publishedAt.minute.toString().padLeft(2, '0')}';
            
            return {
              'time': time,
              'title': article['title'] ?? 'No title',
            };
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to static news if API fails
      setState(() {
        newsItems = [
          {'time': '11:13', 'title': 'OpenAI Surpasses SpaceX as World\'s Most Valuable Startup'},
          {'time': '08:33', 'title': 'U.S. Senate Delays Vote on Government Funding Bill Amid Stalemate'},
          {'time': '08:23', 'title': 'Trump Urges Republicans to Address Government Waste Amid Shutdown'},
          {'time': '08:13', 'title': 'Polymarket Set to Reopen for U.S. Users After Regulatory Ban'},
          {'time': '08:10', 'title': 'Sui Group Holdings to Launch Synthetic Dollar Token'},
          {'time': '08:10', 'title': 'Avalanche Treasury Co. Announces Major Business Merger'},
        ];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: newsItems.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.white, size: 8),
                SizedBox(width: 8),
                Text(
                  'Oct 2 2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final item = newsItems[index - 1];
        return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(item['title']!)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (index < newsItems.length)
                      Container(
                        width: 2,
                        height: 70,
                        color: Colors.grey[800],
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['time']!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Academy Tab
class AcademyTab extends StatelessWidget {
  const AcademyTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategory(context, Icons.grid_view_rounded, 'Blockchain'),
              _buildCategory(context, Icons.image_outlined, 'NFT'),
              _buildCategory(context, Icons.account_balance, 'DeFi'),
              _buildCategory(context, Icons.security, 'Security'),
              _buildCategory(context, Icons.trending_up, 'Trading'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Top Picks',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTopPickCard(context, 'A Beginner\'s Guide to Cryptocurrency Trading'),
        const SizedBox(height: 32),
        const Text(
          'Trending Articles',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTrendingItem(context, 'What Is Injective (INJ)?'),
        _buildTrendingItem(context, 'What Is OpenEden (EDEN)?'),
        _buildTrendingItem(context, 'What Is Falcon Finance (FF)?'),
      ],
    );
  }

  Widget _buildCategory(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $label category')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPickCard(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(title)),
        );
      },
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingItem(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(title)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text('Altcoin', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Moments Tab
class MomentsTab extends StatelessWidget {
  const MomentsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLiveCard(context, '3,946', 'well come 🤝 and enjoy 😜😃', 'Zain_Global', '3h', '1.9K'),
        const SizedBox(height: 16),
        _buildLiveCard(context, '539', 'Sharing Crypto Knowledge', 'Malik Shabi ul Hassan', '1h', '196'),
      ],
    );
  }

  Widget _buildLiveCard(BuildContext context, String viewers, String message, String author, String time, String comments) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Join $author\'s live stream')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.mic, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 80,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(viewers, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎙️ $message', style: const TextStyle(fontSize: 15, height: 1.4)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          author,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(width: 12),
                      const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(comments, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Darcey Sulin QvOJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@Square-Creator-4991cd7acd0ba',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0 Following',
                      style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      '0 Followers',
                      style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildFeature(context, Icons.article_outlined, 'Content'),
                    _buildFeature(context, Icons.school_outlined, 'Creator\nAcademy'),
                    _buildFeature(context, Icons.show_chart, 'Data center'),
                    _buildFeature(context, Icons.edit_outlined, 'Write to\nearn'),
                    _buildFeature(context, Icons.bookmark_outline, 'Bookmarked\nand Liked'),
                    _buildFeature(context, Icons.calendar_today_outlined, 'Task Center'),
                    _buildFeature(context, Icons.visibility_outlined, 'Browse\nHistory'),
                    _buildFeature(context, Icons.create_outlined, 'CreatorPad', isNew: true),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'What\'s Happening?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Trends For You',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B5CF6),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create new content')),
          );
        },
        child: const Icon(Icons.edit, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, IconData icon, String label, {bool isNew = false}) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $label')),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 26, color: Colors.white),
              ),
              if (isNew)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Line Chart Painter
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final data = [0.2, 0.25, 0.22, 0.3, 0.28, 0.35, 0.45, 0.55, 0.52, 0.48, 0.42];
    final path = Path();
    final fillPath = Path();
    
    final stepX = size.width / (data.length - 1);
    
    fillPath.moveTo(0, size.height);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}