// download_helper.dart - Platform-specific download helper
import 'dart:typed_data';
// Conditional imports for web vs other platforms
import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart' as download_helper;

/// Downloads a file with the given bytes and filename
/// Works on all platforms: Web, Android, iOS, Desktop
Future<void> downloadFileBytes(Uint8List bytes, String fileName, String mimeType) async {
  await download_helper.downloadFileBytes(bytes, fileName, mimeType);
}

/// Downloads a text file (legacy method for backward compatibility)
Future<void> downloadFile(String content, String fileName) async {
  await download_helper.downloadFile(content, fileName);
}

