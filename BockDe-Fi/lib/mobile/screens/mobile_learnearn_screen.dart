import 'package:flutter/material.dart';

class MobileLearnEarnScreen extends StatefulWidget {
  const MobileLearnEarnScreen({super.key});

  @override
  State<MobileLearnEarnScreen> createState() => _MobileLearnEarnScreenState();
}

class _MobileLearnEarnScreenState extends State<MobileLearnEarnScreen> {
  String selectedFilter = 'All';
  
  final List<Course> courses = [
    Course(
      title: 'Bitcoin Basics',
      description: 'Take your first step into Bitcoin and own a piece of the world\'s first scarce digital asset — for new BOCK De-Fi users only.',
      status: CourseStatus.ongoing,
      isRedeemed: true,
      imageAsset: 'assets/bitcoin_basics.png',
      hasVideo: false,
    ),
    Course(
      title: 'Welcome to Crypto',
      description: 'This guide introduces you to a few critical concepts you need to kick-start your crypto journey on BOCK De-Fi. You may have a chance to earn crypto rewar...',
      status: CourseStatus.ended,
      isRedeemed: false,
      imageAsset: 'assets/welcome_crypto.png',
      hasVideo: true,
    ),
    Course(
      title: 'A Beginner\'s Guide to BOCK De-Fi Trading',
      description: 'Learn the fundamentals of trading on BOCK De-Fi with this comprehensive beginner\'s guide.',
      status: CourseStatus.ended,
      isRedeemed: false,
      imageAsset: 'assets/BOCK De-Fi_trading.png',
      hasVideo: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Earn Crypto By Learning Ab...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  // BOCK De-Fi Academy Logo
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32.0 : 16.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 122, 79, 223),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'BOCK De-Fi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'ACADEMY',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.account_circle, color: Colors.black),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  // Main Content Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF2B3139),
                          Color(0xFF1A1A1A),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Earn free crypto through learning',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 36 : 32,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Build your blockchain knowledge, complete quizzes, and earn free crypto.',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: isTablet ? 18 : 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
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
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.rule, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Activity Rules',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.grey),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.history, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Reward History',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Learning Illustration
                          Center(
                            child: Container(
                              width: isTablet ? 300 : 200,
                              height: isTablet ? 200 : 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                                    const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Book Icon
                                  Icon(
                                    Icons.menu_book,
                                    size: isTablet ? 80 : 60,
                                    color: const Color.fromARGB(255, 122, 79, 223),
                                  ),
                                  // Decorative elements
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 122, 79, 223),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 122, 79, 223),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32.0 : 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: selectedFilter,
                    underline: Container(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ['All', 'Ongoing', 'Ended'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFilter = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Courses List
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32.0 : 16.0,
                  vertical: 8.0,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCard(
                    course: course,
                    isTablet: isTablet,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isTablet;
  
  const CourseCard({
    super.key,
    required this.course,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image/Header
          Container(
            width: double.infinity,
            height: isTablet ? 200 : 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF2B3139),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Status Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: course.status == CourseStatus.ongoing 
                          ? Colors.green 
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          course.status == CourseStatus.ongoing 
                              ? Icons.access_time 
                              : Icons.check_circle,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.status == CourseStatus.ongoing ? 'Ongoing' : 'Ended',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Course Visual Elements
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                
                // Video Play Button
                if (course.hasVideo)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Course Content
          Padding(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action Section
                if (course.isRedeemed)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'All rewards redeemed, stay tuned!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
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
                        'Start Learning',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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

enum CourseStatus { ongoing, ended }

class Course {
  final String title;
  final String description;
  final CourseStatus status;
  final bool isRedeemed;
  final String imageAsset;
  final bool hasVideo;
  
  Course({
    required this.title,
    required this.description,
    required this.status,
    required this.isRedeemed,
    required this.imageAsset,
    required this.hasVideo,
  });
}