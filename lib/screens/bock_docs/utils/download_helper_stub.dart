// download_helper_stub.dart - Stub for non-web platforms
// This file should never be used directly, only through conditional imports
import 'dart:typed_data';

Future<void> downloadFileBytes(Uint8List bytes, String fileName, String mimeType) {
  // This should never be called on non-web platforms
  // The actual implementation uses path_provider in main.dart
  throw UnimplementedError('downloadFileBytes should not be called directly on non-web platforms');
}

Future<void> downloadFile(String content, String fileName) {
  // This should never be called on non-web platforms
  // The actual implementation uses path_provider in main.dart
  throw UnimplementedError('downloadFile should not be called directly on non-web platforms');
}

