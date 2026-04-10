import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../models/drive_models.dart';

class FileApiService {
  // Get files and folders in a folder
  static Future<List<DriveItem>> getFiles({String? folderId}) async {
    try {
      final queryParams = folderId != null ? {'folderId': folderId} : null;
      final response = await ApiService.get('/files', queryParams: queryParams);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['files'] as List;

        return items.map((item) {
          if (item['type'] == 'FOLDER') {
            return DriveItem(
              id: item['id'],
              name: item['name'],
              type: DriveItemType.folder,
              size: '',
              lastModified: _formatDate(item['updatedAt']),
              owner: 'me',
              location: folderId ?? 'My Drive',
              isStarred: item['isStarred'] ?? false,
            );
          } else {
            return DriveItem(
              id: item['id'],
              name: item['originalName'] ?? item['name'],
              type: _getFileTypeFromMime(item['mimeType']),
              size: _formatFileSize(int.tryParse(item['size'] ?? '0') ?? 0),
              lastModified: _formatDate(item['updatedAt']),
              owner: 'me',
              location: folderId ?? 'My Drive',
              isStarred: item['isStarred'] ?? false,
            );
          }
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching files: $e');
      return [];
    }
  }

  // Get starred files
  static Future<List<DriveItem>> getStarredFiles() async {
    try {
      final response = await ApiService.get('/files/starred');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['files'] as List;

        return files.map((file) {
          return DriveItem(
            id: file['id'],
            name: file['originalName'] ?? file['name'],
            type: _getFileTypeFromMime(file['mimeType']),
            size: _formatFileSize(int.tryParse(file['size'] ?? '0') ?? 0),
            lastModified: _formatDate(file['updatedAt']),
            owner: 'me',
            location: 'My Drive',
            isStarred: true,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching starred files: $e');
      return [];
    }
  }

  // Get a single file by ID
  static Future<DriveItem?> getFileById(String fileId) async {
    try {
      final response = await ApiService.get('/files/$fileId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final file = data['file'];

        if (file == null) return null;

        return DriveItem(
          id: file['id'],
          name: file['originalName'] ?? file['name'],
          type: _getFileTypeFromMime(file['mimeType']),
          size: _formatFileSize(int.tryParse(file['size'] ?? '0') ?? 0),
          lastModified: _formatDate(file['updatedAt'] ?? file['createdAt']),
          owner: 'me',
          location: 'My Drive',
          isStarred: file['isStarred'] ?? false,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching file by ID: $e');
      return null;
    }
  }

  // Get trashed files
  static Future<List<DriveItem>> getTrashedFiles() async {
    try {
      final response = await ApiService.get('/files/trash');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['files'] as List;

        return files.map((file) {
          return DriveItem(
            id: file['id'],
            name: file['originalName'] ?? file['name'],
            type: _getFileTypeFromMime(file['mimeType']),
            size: _formatFileSize(int.tryParse(file['size'] ?? '0') ?? 0),
            lastModified: _formatDate(file['trashedAt'] ?? file['updatedAt']),
            owner: 'me',
            location: 'Trash',
            isStarred: false,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching trashed files: $e');
      return [];
    }
  }

  // Search files
  static Future<List<DriveItem>> searchFiles(String query) async {
    try {
      final response = await ApiService.get(
        '/files/search',
        queryParams: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['files'] as List;

        return files.map((file) {
          return DriveItem(
            id: file['id'],
            name: file['originalName'] ?? file['name'],
            type: _getFileTypeFromMime(file['mimeType']),
            size: _formatFileSize(int.tryParse(file['size'] ?? '0') ?? 0),
            lastModified: _formatDate(file['updatedAt']),
            owner: 'me',
            location: 'My Drive',
            isStarred: file['isStarred'] ?? false,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error searching files: $e');
      return [];
    }
  }

  // Upload file
  static Future<Map<String, dynamic>> uploadFile(
    PlatformFile file, {
    String? folderId,
  }) async {
    try {
      final token = await ApiService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final uri = Uri.parse('${ApiService.baseUrl}/upload');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (folderId != null) {
        request.fields['folderId'] = folderId;
      }

      if (kIsWeb && file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else if (file.path != null && file.path!.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path!,
            filename: file.name,
          ),
        );
      } else if (!kIsWeb && file.readStream != null) {
        request.files.add(
          http.MultipartFile(
            'file',
            http.ByteStream(file.readStream!),
            file.size,
            filename: file.name,
          ),
        );
      } else if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        return {
          'success': false,
          'message': 'File data not available from picker',
        };
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : <String, dynamic>{};

      if (response.statusCode == 200) {
        return {'success': true, 'file': data['file']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Upload failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Upload error: ${e.toString()}'};
    }
  }

  /// Build an authenticated preview URL for streaming a file inline.
  ///
  /// This uses the `/api/files/proxy/:fileId` endpoint and passes the JWT
  /// via the `token` query parameter so that it works with `Image.network`
  /// and when opening in a browser.
  static Future<String?> getFilePreviewUrl(String fileId) async {
    final token = await ApiService.getToken();
    if (token == null) return null;

    // `baseUrl` already includes `/api`
    final base = ApiService.baseUrl;
    return '$base/files/proxy/$fileId?token=$token';
  }

  /// Build an authenticated download URL for a file.
  ///
  /// This uses the `/api/files/download/:fileId` endpoint and passes the JWT
  /// via the `token` query parameter so that it can be opened in a browser
  /// to trigger a download.
  static Future<String?> getFileDownloadUrl(String fileId) async {
    final token = await ApiService.getToken();
    if (token == null) return null;

    final base = ApiService.baseUrl;
    return '$base/files/download/$fileId?token=$token';
  }

  // Delete file (move to trash)
  static Future<Map<String, dynamic>> deleteFile(String fileId) async {
    try {
      // Hit the trash endpoint so the backend keeps the file in a soft-deleted state
      final response = await ApiService.patch('/files/$fileId/trash');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Delete failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Delete error: ${e.toString()}'};
    }
  }

  // Restore file from trash
  static Future<Map<String, dynamic>> restoreFile(String fileId) async {
    try {
      final response = await ApiService.patch('/files/$fileId/restore');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Restore failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Restore error: ${e.toString()}'};
    }
  }

  // Toggle star
  static Future<Map<String, dynamic>> toggleStar(
    String fileId,
    bool isStarred,
  ) async {
    try {
      final response = await ApiService.patch('/files/$fileId/star');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedStatus = data['starred'] ??
            (data['file'] != null ? data['file']['isStarred'] : null) ??
            !isStarred;
        return {'success': true, 'isStarred': updatedStatus};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Star toggle failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Star toggle error: ${e.toString()}',
      };
    }
  }

  // Helper methods
  static DriveItemType _getFileTypeFromMime(String? mimeType) {
    if (mimeType == null) return DriveItemType.other;

    if (mimeType.startsWith('image/')) return DriveItemType.image;
    if (mimeType.startsWith('video/')) return DriveItemType.video;
    if (mimeType.startsWith('audio/')) return DriveItemType.audio;
    if (mimeType == 'application/pdf') return DriveItemType.pdf;
    if (mimeType.contains('spreadsheet') ||
        mimeType.contains('excel') ||
        mimeType.contains('csv')) {
      return DriveItemType.spreadsheet;
    }
    if (mimeType.contains('document') ||
        mimeType.contains('word') ||
        mimeType.contains('text')) {
      return DriveItemType.document;
    }
    if (mimeType.contains('zip') ||
        mimeType.contains('rar') ||
        mimeType.contains('archive')) {
      return DriveItemType.archive;
    }
    return DriveItemType.other;
  }

  static String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(size % 1 == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  static String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
