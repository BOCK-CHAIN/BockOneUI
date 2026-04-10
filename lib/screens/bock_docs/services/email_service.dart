// services/email_service.dart
// EmailJS service for sending emails directly from the browser

import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  // EmailJS configuration
  // Set these up at https://www.emailjs.com/
  static const String serviceId = 'YOUR_SERVICE_ID'; // Replace with your EmailJS service ID
  static const String templateId = 'YOUR_TEMPLATE_ID'; // Replace with your EmailJS template ID
  static const String publicKey = 'YOUR_PUBLIC_KEY'; // Replace with your EmailJS public key
  
  // EmailJS API endpoint
  static const String emailjsApiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Send password reset email using EmailJS REST API
  static Future<bool> sendPasswordResetEmail({
    required String toEmail,
    required String resetToken,
    required String resetLink,
  }) async {
    try {
      // Check if EmailJS is configured
      if (serviceId == 'YOUR_SERVICE_ID' || 
          templateId == 'YOUR_TEMPLATE_ID' || 
          publicKey == 'YOUR_PUBLIC_KEY') {
        print('⚠️ EmailJS not configured. Please set up EmailJS first.');
        print('   See EMAILJS_SETUP.md for instructions');
        return false;
      }

      // Prepare email parameters
      final emailParams = {
        'to_email': toEmail,
        'reset_link': resetLink,
        'reset_token': resetToken,
        'subject': 'Reset Your BockDocs Password',
      };

      // Prepare request body
      final requestBody = {
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': emailParams,
      };

      // Send email via EmailJS REST API
      final response = await http.post(
        Uri.parse(emailjsApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost:5000', // Adjust if needed
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('✅ Password reset email sent successfully to: $toEmail');
        return true;
      } else {
        print('❌ Failed to send email. Status: ${response.statusCode}');
        print('   Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending email via EmailJS: $e');
      return false;
    }
  }
}

