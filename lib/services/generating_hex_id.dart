import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateHexId(String email, String password,String firstName,String lastName,String dob,String gender) {
  // Combine email and password
  final input = email + password + firstName + lastName + dob + gender;

  // Convert to bytes and hash using SHA-512
  final bytes = utf8.encode(input);
  final digest = sha512.convert(bytes);

  // Get first 8 bytes (16 hex characters)
  final hexId = digest.toString().substring(0, 16);

  return hexId;
}