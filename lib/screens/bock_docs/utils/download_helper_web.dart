// download_helper_web.dart - Web-specific download implementation
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<void> downloadFileBytes(Uint8List bytes, String fileName, String mimeType) async {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url);
  anchor.setAttribute('download', fileName);
  anchor.click();
  html.Url.revokeObjectUrl(url);
}

Future<void> downloadFile(String content, String fileName) async {
  final bytes = utf8.encode(content);
  await downloadFileBytes(Uint8List.fromList(bytes), fileName, 'text/plain');
}

