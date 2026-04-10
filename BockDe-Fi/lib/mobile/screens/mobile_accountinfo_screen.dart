import 'package:bockchain/mobile/screens/mobile_benefit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileAccountInfoScreen extends StatelessWidget {
  const MobileAccountInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Account Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User Profile Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                '😎',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'User-4991c',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Regular',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildInfoRow('BOCK De-FI ID (UID)', '', hasIcon: true),
                    SizedBox(height: 12),
                    _buildInfoRow('Reg.Info', '18@gmail.com', hasIcon: true),
                    SizedBox(height: 20),
                    // VIP Upgrade Section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Upgrade to VIP1',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MobileBenefitScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Benefits',
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 122, 79, 223),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: const Color.fromARGB(255, 122, 79, 223),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Trade more to reach the next level',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: 0.1,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 122, 79, 223)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Verifications
              _buildMenuItem(
                icon: Icons.verified_user_outlined,
                title: 'Verifications',
                trailing: 'Verified',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerificationCenterScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              // Security
              _buildMenuItem(
                icon: Icons.security_outlined,
                title: 'Security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecurityScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              // Twitter
              _buildMenuItem(
                icon: Icons.cancel_outlined,
                title: 'Twitter',
                trailing: 'Unlinked',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool hasIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (hasIcon) ...[
              SizedBox(width: 8),
              Icon(
                Icons.remove_red_eye_outlined,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// Verification Center Screen
class VerificationCenterScreen extends StatelessWidget {
  const VerificationCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verification Center',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // User Avatar with Flag
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade800,
                    child: Text(
                      '😎',
                      style: TextStyle(fontSize: 80),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Text(
                          '🇮🇳',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'User-4991c',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'ID:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Verified',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Account Limits
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Limits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildLimitRow('Fiat Deposit & Withdrawal Limits', '50K USD Daily'),
              _buildLimitRow('Crypto Deposit Limit', 'Unlimited'),
              _buildLimitRow('Crypto Withdrawal Limit', '8M USDT Daily'),
              _buildLimitRow('P2P Transaction Limits', 'Unlimited'),
              SizedBox(height: 30),
              // Personal Information
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow('Country of Residence', 'India (भारत)', hasChange: true),
              _buildInfoRow('Legal Name', 'RUPA SHREE S'),
              _buildInfoRow('Date of Birth', ''),
              _buildInfoRow('Identification Documents', 'Aadhaar card, GQ**********1R'),
              _buildInfoRow('Address', '--, India (भारत)'),
              _buildInfoRow('Email Address', 'ru***@gmail.com'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLimitRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool hasChange = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasChange)
                  Text(
                    'Change  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 122, 79, 223),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
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

// Security Screen
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Two-Factor Authentication (2FA)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'To protect your account, it is recommended to enable at least two forms of 2FA.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 20),
              _buildSecurityItem(
                context,
                icon: Icons.fingerprint,
                title: 'Passkeys (Biometrics)',
                badge: 'Recommended',
                isEnabled: true,
              ),
              SizedBox(height: 12),
              _buildSecurityItem(
                context,
                icon: Icons.qr_code_scanner,
                title: 'Authenticator App',
                isWarning: true,
              ),
              SizedBox(height: 12),
              _buildSecurityItem(
                context,
                icon: Icons.email_outlined,
                title: 'Email',
                isEnabled: true,
              ),
              SizedBox(height: 12),
              _buildSecurityItem(
                context,
                icon: Icons.lock_outline,
                title: 'Password',
              ),
              SizedBox(height: 12),
              _buildSecurityItem(
                context,
                icon: Icons.pin_outlined,
                title: 'Pay PIN',
              ),
              SizedBox(height: 12),
              _buildSecurityItem(
                context,
                icon: Icons.phone_outlined,
                title: 'Phone Number',
              ),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 10),
              _buildMenuItem(context, 'Emergency Contact'),
              _buildMenuItem(context, 'Anti-Phishing Code'),
              _buildMenuItem(context, 'Account Activities'),
              _buildMenuItem(
                context,
                'Auto-Lock',
                trailing: 'Never',
              ),
              _buildMenuItem(context, 'App Authorization'),
              _buildMenuItem(context, 'Account Connections'),
              _buildMenuItem(context, '2FA Verification Strategy'),
              _buildMenuItem(context, 'Devices'),
              _buildMenuItem(context, 'Manage Account'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? badge,
    bool isEnabled = false,
    bool isWarning = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (badge != null) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color.fromARGB(255, 122, 79, 223),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isWarning)
            Icon(Icons.warning_amber_rounded, color: Colors.grey, size: 24)
          else if (isEnabled)
            Icon(Icons.check_circle, color: Colors.green, size: 24)
          else
            Container(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
