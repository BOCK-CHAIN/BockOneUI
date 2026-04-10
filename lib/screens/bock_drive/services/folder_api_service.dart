import 'dart:convert';
import 'api_service.dart';

class FolderApiService {
  // Create folder
  static Future<Map<String, dynamic>> createFolder({
    required String name,
    String? parentId,
  }) async {
    try {
      final response = await ApiService.post('/folders', body: {
        'name': name,
        if (parentId != null) 'parentId': parentId,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'folder': data['folder'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create folder',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Create folder error: ${e.toString()}',
      };
    }
  }

  // Get folders
  static Future<List<Map<String, dynamic>>> getFolders({String? parentId}) async {
    try {
      final queryParams = parentId != null ? {'parentId': parentId} : null;
      final response = await ApiService.get('/folders', queryParams: queryParams);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['folders'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error fetching folders: $e');
      return [];
    }
  }

  // Get folder by ID
  static Future<Map<String, dynamic>?> getFolder(String folderId) async {
    try {
      final response = await ApiService.get('/folders/$folderId');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['folder'];
      }
      return null;
    } catch (e) {
      print('Error fetching folder: $e');
      return null;
    }
  }

  // Update folder (rename)
  static Future<Map<String, dynamic>> updateFolder({
    required String folderId,
    required String name,
  }) async {
    try {
      final response = await ApiService.patch('/folders/$folderId', body: {
        'name': name,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'folder': data['folder'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update folder',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Update folder error: ${e.toString()}',
      };
    }
  }

  // Delete folder
  static Future<Map<String, dynamic>> deleteFolder(String folderId) async {
    try {
      final response = await ApiService.delete('/folders/$folderId');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Folder deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete folder',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Delete folder error: ${e.toString()}',
      };
    }
  }

  // Get folder path (breadcrumb)
  static Future<List<Map<String, dynamic>>> getFolderPath(String folderId) async {
    try {
      final response = await ApiService.get('/folders/$folderId/path');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['path'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error fetching folder path: $e');
      return [];
    }
  }
}



