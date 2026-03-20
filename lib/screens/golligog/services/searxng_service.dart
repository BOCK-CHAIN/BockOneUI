import 'dart:convert';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:http/http.dart' as http;
import '../models/search_models.dart';
import '../config/app_config.dart';

class SearXNGService {
  // SearXNG instance URL - loaded from environment variables
  static String get _baseUrl => AppConfig.searxngBaseUrl;
  static const String _searchEndpoint = '/search';
  
  final http.Client _client = http.Client();

  Uri? _buildLocalhostFallbackUri(Uri uri) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    final host = uri.host.toLowerCase();
    if (host == 'localhost' || host == '127.0.0.1') {
      return uri.replace(host: '10.0.2.2');
    }
    return null;
  }

  Future<http.Response> _get(Uri uri) {
    return _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        // Keep headers CORS-simple for Flutter web to avoid preflight failures.
        'Accept-Language': 'en-US,en;q=0.9',
      },
    ).timeout(const Duration(seconds: 30));
  }
  
  /// Search using SearXNG API directly
  Future<SearchResponse> search({
    required String query,
    String category = 'general',
    String format = 'json',
    String language = 'en',
    int page = 1,
    String? engines,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'category': category,
        'format': format,
        'language': language,  // Changed from 'lang' to 'language'
        'pageno': page.toString(),
        if (engines != null) 'engines': engines,
      };
      
      final finalUri = Uri.parse('$_baseUrl$_searchEndpoint').replace(queryParameters: queryParams);
      final primaryUri = _buildLocalhostFallbackUri(finalUri) ?? finalUri;
      print('DEBUG: Making request to: $primaryUri');
      print('DEBUG: Headers: ${{'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'}}');
      
      late final http.Response response;
      try {
        response = await _get(primaryUri);
      } catch (primaryError) {
        final fallbackUri = primaryUri == finalUri
            ? _buildLocalhostFallbackUri(finalUri)
            : null;
        if (fallbackUri == null) {
          rethrow;
        }
        print('DEBUG: Primary URL failed: $primaryError');
        print('DEBUG: Retrying with fallback URL: $fallbackUri');
        response = await _get(fallbackUri);
      }
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response headers: ${response.headers}');
      print('DEBUG: Response body length: ${response.body.length}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Manual parsing to debug the issue
        print('DEBUG: Attempting manual parsing...');
        try {
          final results = <SearchResult>[];
          final resultsList = jsonData['results'] as List;
          
          for (int i = 0; i < resultsList.length; i++) {
            try {
              final resultJson = resultsList[i] as Map<String, dynamic>;
              print('DEBUG: Parsing result $i: ${resultJson.keys.toList()}');
              
              // Check for problematic fields before parsing
              for (String key in resultJson.keys) {
                final value = resultJson[key];
                if (value is List && !['engines', 'positions', 'parsed_url'].contains(key)) {
                  print('DEBUG: WARNING - Result $i field "$key" is unexpected List: $value');
                }
                if (value is Map && !['parsed_url'].contains(key)) {
                  print('DEBUG: WARNING - Result $i field "$key" is unexpected Map: $value');
                }
              }
              
              final searchResult = SearchResult.fromJson(resultJson);
              results.add(searchResult);
              print('DEBUG: Successfully parsed result $i');
            } catch (e) {
              print('DEBUG: Error parsing result $i: $e');
              print('DEBUG: Problematic result: ${resultsList[i]}');
              
              // Let's see which specific field is the issue
              final resultJson = resultsList[i] as Map<String, dynamic>;
              for (String field in ['title', 'url', 'content', 'engine', 'template', 'thumbnail', 'img_src', 'publishedDate', 'author', 'priority', 'category']) {
                try {
                  final value = resultJson[field] as String?;
                  print('DEBUG: Field "$field" OK: $value');
                } catch (fieldError) {
                  print('DEBUG: Field "$field" ERROR: $fieldError (type: ${resultJson[field].runtimeType}, value: ${resultJson[field]})');
                }
              }
              rethrow;
            }
          }
          
          // Manual SearchResponse creation
          final searchResponse = SearchResponse(
            query: jsonData['query'] as String,
            number_of_results: jsonData['number_of_results'] as int,
            results: results,
            corrections: (jsonData['corrections'] as List?)?.map((e) => e as String).toList(),
            infoboxes: jsonData['infoboxes'] as List?,
            suggestions: (jsonData['suggestions'] as List?)?.map((e) => e as String).toList(),
            answers: (jsonData['answers'] as List?)?.map((e) => e as String).toList(),
            unresponsive_engines: (jsonData['unresponsive_engines'] as List?)?.map((e) => e as String).toList(),
          );
          
          print('DEBUG: Manual parsing successful, returning ${results.length} results');
          return searchResponse;
        } catch (e) {
          print('DEBUG: Manual parsing failed: $e');
          rethrow;
        }
      } else {
        print('DEBUG: Non-200 response body: ${response.body}');
        throw SearXNGException('Search failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SearXNGException) rethrow;
      throw SearXNGException('Network error: $e');
    }
  }

  /// Get available search engines
  Future<List<EngineInfo>> getEngines() async {
    try {
      final uri = Uri.parse('$_baseUrl/engines');
      final primaryUri = _buildLocalhostFallbackUri(uri) ?? uri;
      late final http.Response response;
      try {
        response = await _client
            .get(
              primaryUri,
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'Golligog-Flutter-App/1.0',
              },
            )
            .timeout(const Duration(seconds: 5));
      } catch (_) {
        final fallbackUri = primaryUri == uri ? _buildLocalhostFallbackUri(uri) : null;
        if (fallbackUri == null) rethrow;
        response = await _client
            .get(
              fallbackUri,
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'Golligog-Flutter-App/1.0',
              },
            )
            .timeout(const Duration(seconds: 5));
      }
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => EngineInfo.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Search for images specifically
  Future<SearchResponse> searchImages({
    required String query,
    String language = 'en',
    int page = 1,
  }) async {
    return await search(
      query: query,
      category: 'images',
      language: language,
      page: page,
    );
  }
  
  /// Search for videos specifically
  Future<SearchResponse> searchVideos({
    required String query,
    String language = 'en',
    int page = 1,
  }) async {
    return await search(
      query: query,
      category: 'videos',
      language: language,
      page: page,
    );
  }
  
  /// Search for news specifically
  Future<SearchResponse> searchNews({
    required String query,
    String language = 'en',
    int page = 1,
  }) async {
    return await search(
      query: query,
      category: 'news',
      language: language,
      page: page,
    );
  }

  /// Check if SearXNG instance is available
  Future<bool> checkInstanceHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/healthz');
      final primaryUri = _buildLocalhostFallbackUri(uri) ?? uri;
      late final http.Response response;
      try {
        response = await _client.get(primaryUri).timeout(const Duration(seconds: 3));
      } catch (_) {
        final fallbackUri = primaryUri == uri ? _buildLocalhostFallbackUri(uri) : null;
        if (fallbackUri == null) return false;
        response =
            await _client.get(fallbackUri).timeout(const Duration(seconds: 3));
      }
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Dispose of the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Custom exception for SearXNG-related errors
class SearXNGException implements Exception {
  final String message;
  
  SearXNGException(this.message);
  
  @override
  String toString() => 'SearXNGException: $message';
}
