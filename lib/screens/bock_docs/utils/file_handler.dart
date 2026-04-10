// file_handler.dart - Handles file operations for opening documents
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:archive/archive.dart';
import 'dart:convert';

class FileHandler {
  /// Pick and read a file from device
  static Future<FileResult?> pickAndReadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'docx', 'doc', 'rtf', 'md'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        
        if (kIsWeb) {
          // Web platform - use bytes directly
          if (file.bytes != null) {
            return FileResult(
              name: file.name,
              content: await _readFileBytes(file.bytes!),
              extension: file.extension ?? 'txt',
            );
          }
        } else {
          // Mobile/Desktop platforms - read from file path
          if (file.path != null) {
            final fileObj = File(file.path!);
            final bytes = await fileObj.readAsBytes();
            return FileResult(
              name: file.name,
              content: await _readFileBytes(bytes),
              extension: file.extension ?? 'txt',
            );
          }
        }
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  /// Read file bytes and extract text content
  static Future<String> _readFileBytes(Uint8List bytes) async {
    // Try to detect file type by first bytes
    if (bytes.length < 4) {
      return utf8.decode(bytes, allowMalformed: true);
    }

    // Check for DOCX (ZIP signature: PK\x03\x04)
    if (bytes[0] == 0x50 && bytes[1] == 0x4B && 
        (bytes[2] == 0x03 || bytes[2] == 0x05 || bytes[2] == 0x07) && 
        bytes[3] == 0x04) {
      return _extractTextFromDocx(bytes);
    }

    // Try UTF-8 first
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      // Fallback to latin1
      return latin1.decode(bytes, allowInvalid: true);
    }
  }

  /// Extract text from DOCX file
  static String _extractTextFromDocx(Uint8List bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // DOCX files contain text in word/document.xml
      final documentXml = archive.findFile('word/document.xml');
      if (documentXml != null) {
        final xmlContent = utf8.decode(documentXml.content as List<int>);
        // Simple XML text extraction (remove tags)
        String text = xmlContent
            .replaceAll(RegExp(r'<[^>]+>'), ' ') // Remove XML tags
            .replaceAll(RegExp(r'&lt;'), '<')
            .replaceAll(RegExp(r'&gt;'), '>')
            .replaceAll(RegExp(r'&amp;'), '&')
            .replaceAll(RegExp(r'&quot;'), '"')
            .replaceAll(RegExp(r'&apos;'), "'")
            .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
            .trim();
        return text;
      }
    } catch (e) {
      print('Error extracting DOCX: $e');
    }
    
    // Fallback: return empty or try to decode as text
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return '';
    }
  }
}

class FileResult {
  final String name;
  final String content;
  final String extension;

  FileResult({
    required this.name,
    required this.content,
    required this.extension,
  });

  String get title {
    // Remove extension from name
    if (name.contains('.')) {
      return name.substring(0, name.lastIndexOf('.'));
    }
    return name;
  }
}

