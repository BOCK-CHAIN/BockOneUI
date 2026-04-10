import 'package:json_annotation/json_annotation.dart';

part 'search_models.g.dart';

@JsonSerializable()
class SearchResult {
  final String title;
  final String url;
  final String content;
  final String? engine;
  final String? template;
  final List<String>? engines;
  final double? score;
  final String? thumbnail;
  final String? img_src;
  final String? publishedDate;
  final String? author;
  final String? priority;
  final String? category;
  final List<dynamic>? parsed_url;
  final List<dynamic>? positions;
  
  SearchResult({
    required this.title,
    required this.url,
    required this.content,
    this.engine,
    this.template,
    this.engines,
    this.score,
    this.thumbnail,
    this.img_src,
    this.publishedDate,
    this.author,
    this.priority,
    this.category,
    this.parsed_url,
    this.positions,
  });

  static String? _stringFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();

    if (value is List) {
      for (final item in value) {
        final candidate = _stringFromDynamic(item);
        if (candidate != null && candidate.isNotEmpty) return candidate;
      }
      return null;
    }

    if (value is Map) {
      for (final key in const ['url', 'src', 'href', 'thumbnail', 'img_src']) {
        final candidate = _stringFromDynamic(value[key]);
        if (candidate != null && candidate.isNotEmpty) return candidate;
      }
      return null;
    }

    return null;
  }

  static List<String>? _stringListFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is String) return [value];
    if (value is List) {
      final strings = value
          .map(_stringFromDynamic)
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
      return strings.isEmpty ? null : strings;
    }
    return null;
  }

  static double? _doubleFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// SearXNG can return some fields as either a String or a List depending on
  /// the engine/category. Parse defensively to avoid runtime type-cast errors.
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: _stringFromDynamic(json['title']) ?? '',
      url: _stringFromDynamic(json['url']) ?? '',
      content: _stringFromDynamic(json['content']) ?? '',
      engine: _stringFromDynamic(json['engine']),
      template: _stringFromDynamic(json['template']),
      engines: _stringListFromDynamic(json['engines']),
      score: _doubleFromDynamic(json['score']),
      thumbnail: _stringFromDynamic(json['thumbnail']) ??
          _stringFromDynamic(json['thumbnail_src']),
      img_src: _stringFromDynamic(json['img_src']),
      publishedDate: _stringFromDynamic(json['publishedDate']) ??
          _stringFromDynamic(json['published_date']),
      author: _stringFromDynamic(json['author']),
      priority: _stringFromDynamic(json['priority']),
      category: _stringFromDynamic(json['category']),
      parsed_url: json['parsed_url'] is List
          ? json['parsed_url'] as List<dynamic>
          : null,
      positions:
          json['positions'] is List ? json['positions'] as List<dynamic> : null,
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'url': url,
        'content': content,
        'engine': engine,
        'template': template,
        'engines': engines,
        'score': score,
        'thumbnail': thumbnail,
        'img_src': img_src,
        'publishedDate': publishedDate,
        'author': author,
        'priority': priority,
        'category': category,
        'parsed_url': parsed_url,
        'positions': positions,
      };
}

@JsonSerializable()
class SearchResponse {
  final String query;
  final int number_of_results;
  final List<SearchResult> results;
  final List<String>? corrections;
  final List<dynamic>? infoboxes;  // Changed from List<String> to List<dynamic>
  final List<String>? suggestions;
  final List<String>? answers;
  final List<String>? unresponsive_engines;  // Changed from String to List<String>
  
  SearchResponse({
    required this.query,
    required this.number_of_results,
    required this.results,
    this.corrections,
    this.infoboxes,
    this.suggestions,
    this.answers,
    this.unresponsive_engines,
  });

  static String? _stringFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();

    if (value is List) {
      final parts = value
          .map(_stringFromDynamic)
          .whereType<String>()
          .where((part) => part.isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(': ');
    }

    if (value is Map) {
      for (final key in const ['answer', 'text', 'title', 'name', 'content']) {
        final candidate = _stringFromDynamic(value[key]);
        if (candidate != null && candidate.isNotEmpty) return candidate;
      }
      final parts = value.values
          .map(_stringFromDynamic)
          .whereType<String>()
          .where((part) => part.isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(': ');
    }

    return value.toString();
  }

  static List<String>? _stringListFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is! List) {
      final single = _stringFromDynamic(value);
      return single == null || single.isEmpty ? null : [single];
    }

    final values = value
        .map(_stringFromDynamic)
        .whereType<String>()
        .where((entry) => entry.isNotEmpty)
        .toList();
    return values.isEmpty ? null : values;
  }

  static int _intFromDynamic(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    final results = rawResults is List
        ? rawResults
            .whereType<Map>()
            .map(
              (entry) =>
                  SearchResult.fromJson(Map<String, dynamic>.from(entry)),
            )
            .toList()
        : const <SearchResult>[];

    return SearchResponse(
      query: _stringFromDynamic(json['query']) ?? '',
      number_of_results: _intFromDynamic(json['number_of_results']),
      results: results,
      corrections: _stringListFromDynamic(json['corrections']),
      infoboxes:
          json['infoboxes'] is List ? json['infoboxes'] as List<dynamic> : null,
      suggestions: _stringListFromDynamic(json['suggestions']),
      answers: _stringListFromDynamic(json['answers']),
      unresponsive_engines: _stringListFromDynamic(json['unresponsive_engines']),
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        'query': query,
        'number_of_results': number_of_results,
        'results': results.map((result) => result.toJson()).toList(),
        'corrections': corrections,
        'infoboxes': infoboxes,
        'suggestions': suggestions,
        'answers': answers,
        'unresponsive_engines': unresponsive_engines,
      };
}

@JsonSerializable()
class EngineInfo {
  final String name;
  final String? displayname;
  final String? description;
  final List<String>? categories;
  
  EngineInfo({
    required this.name,
    this.displayname,
    this.description,
    this.categories,
  });

  factory EngineInfo.fromJson(Map<String, dynamic> json) {
    return EngineInfo(
      name: SearchResponse._stringFromDynamic(json['name']) ?? '',
      displayname: SearchResponse._stringFromDynamic(json['displayname']),
      description: SearchResponse._stringFromDynamic(json['description']),
      categories: SearchResponse._stringListFromDynamic(json['categories']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'displayname': displayname,
        'description': description,
        'categories': categories,
      };
}
