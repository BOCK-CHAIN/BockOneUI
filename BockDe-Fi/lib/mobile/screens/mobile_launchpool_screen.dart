import 'package:flutter/material.dart';

// Data Models
class LaunchpoolProject {
  final String id;
  final String name;
  final String token;
  final String logo;
  final Color logoColor;
  final String type; // 'HODLer Airdrops'
  final String status; // 'In Calculation', 'Distributed'
  final double totalAmount;
  final String unit;
  final double averageAirdropPerBNB;
  final String? convertedValue;
  final DateTime? airdropTime;
  final DateTime? officialListTime;
  final String? snapshotTimeRange;
  final String? mySnapshotStatus;
  final String? airdropReceivedStatus;

  LaunchpoolProject({
    required this.id,
    required this.name,
    required this.token,
    required this.logo,
    required this.logoColor,
    required this.type,
    required this.status,
    required this.totalAmount,
    required this.unit,
    required this.averageAirdropPerBNB,
    this.convertedValue,
    this.airdropTime,
    this.officialListTime,
    this.snapshotTimeRange,
    this.mySnapshotStatus,
    this.airdropReceivedStatus,
  });
}

class MobileLaunchpoolScreen extends StatefulWidget {
  const MobileLaunchpoolScreen({Key? key}) : super(key: key);

  @override
  State<MobileLaunchpoolScreen> createState() => _MobileLaunchpoolScreenState();
}

class _MobileLaunchpoolScreenState extends State<MobileLaunchpoolScreen> {
  bool notificationsEnabled = false;
  
  // Sample data - replace with your actual data
  final List<LaunchpoolProject> inCalculationProjects = [
    LaunchpoolProject(
      id: '1',
      name: 'XPL',
      token: 'XPL',
      logo: '',
      logoColor: Colors.black,
      type: 'HODLer Airdrops',
      status: 'In Calculation',
      totalAmount: 75000000,
      unit: 'XPL',
      averageAirdropPerBNB: 4.5063,
      airdropTime: DateTime(2025, 9, 25, 17, 30),
      officialListTime: DateTime(2025, 9, 25, 18, 30),
      snapshotTimeRange: '2025-09-10 05:30 - 2025-09-14 05:29',
      mySnapshotStatus: 'In Calculation',
      airdropReceivedStatus: 'In Calculation',
    ),
  ];

  final List<LaunchpoolProject> completedProjects = [
    LaunchpoolProject(
      id: '2',
      name: 'HEMI',
      token: 'HEMI',
      logo: 'H',
      logoColor: Colors.orange,
      type: 'HODLer Airdrops',
      status: 'Distributed',
      totalAmount: 100000000,
      unit: 'HEMI',
      averageAirdropPerBNB: 5.9772,
      convertedValue: '≈91.51 INR',
    ),
    LaunchpoolProject(
      id: '3',
      name: 'OG',
      token: 'OG',
      logo: 'OG',
      logoColor: Colors.purple,
      type: 'HODLer Airdrops',
      status: 'Distributed',
      totalAmount: 3000000,
      unit: 'OG',
      averageAirdropPerBNB: 2.1234,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Launchpool',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Receive token airdrops at no extra cost.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // In Calculation Section
            if (inCalculationProjects.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'In Calculation',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              ...inCalculationProjects.map((project) => _buildProjectCard(project)),
            ],
            
            const SizedBox(height: 32),
            
            // Notifications Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Turn on Notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Receive push notifications for new\nLaunchpool projects.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                    activeColor: Colors.grey[700],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Completed Projects Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completed Projects',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ...completedProjects.map((project) => _buildCompletedProjectCard(project)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(LaunchpoolProject project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToProjectDetail(project),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: project.logoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: project.logoColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: project.logo.isEmpty 
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: project.logoColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )
                      : Text(
                          project.logo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: project.logoColor,
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
                        project.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        project.type,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '${_formatNumber(project.totalAmount)} ${project.unit}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Average Airdrop
            Text(
              'Average Airdrop',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'B',
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
                  'Per BNB',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${project.averageAirdropPerBNB.toStringAsFixed(4)} ${project.token}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedProjectCard(LaunchpoolProject project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToProjectDetail(project),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project.status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: project.logoColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      project.logo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                        project.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        project.type,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '${_formatNumber(project.totalAmount)} ${project.unit}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Average Airdrop
            Text(
              'Average Airdrop',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'B',
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
                  'Per BNB',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${project.averageAirdropPerBNB.toStringAsFixed(4)} ${project.token}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (project.convertedValue != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        project.convertedValue!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(0)},000,000';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)},000';
    }
    return number.toStringAsFixed(0);
  }

  void _navigateToProjectDetail(LaunchpoolProject project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaunchpoolProjectDetailScreen(project: project),
      ),
    );
  }
}

// Project Detail Screen
class LaunchpoolProjectDetailScreen extends StatelessWidget {
  final LaunchpoolProject project;

  const LaunchpoolProjectDetailScreen({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: project.logoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: project.logoColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: project.logo.isEmpty 
                      ? Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: project.logoColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        )
                      : Text(
                          project.logo,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: project.logoColor,
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
                        project.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          project.status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Timeline
            if (project.airdropTime != null) ...[
              _buildTimelineItem(
                'Airdrop', 
                _formatDateTime(project.airdropTime!),
                true,
              ),
              _buildTimelineItem(
                'Official List', 
                _formatDateTime(project.officialListTime!),
                false,
              ),
              
              const SizedBox(height: 32),
            ],
            
            // My Participation
            const Text(
              'My Participation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (project.snapshotTimeRange != null) ...[
                    _buildParticipationRow('Snapshot Time', project.snapshotTimeRange!),
                    const SizedBox(height: 16),
                  ],
                  if (project.mySnapshotStatus != null) ...[
                    _buildParticipationRow('My Snapshot', project.mySnapshotStatus!),
                    const SizedBox(height: 16),
                  ],
                  if (project.airdropReceivedStatus != null) ...[
                    _buildParticipationRow('Airdrop Received', project.airdropReceivedStatus!),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Project Summary
            const Text(
              'Project Summary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'View more details in the announcement',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      //TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String label, String time, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              if (!isFirst) ...[
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}