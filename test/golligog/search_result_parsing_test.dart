import 'package:flutter_test/flutter_test.dart';

import 'package:trial/screens/golligog/models/search_models.dart';

void main() {
  test('SearchResult.fromJson accepts list-valued image fields', () {
    final result = SearchResult.fromJson({
      'title': 'Example',
      'url': 'https://example.com',
      'content': 'Hello',
      'thumbnail': ['https://thumb.example/1.jpg', 'https://thumb.example/2.jpg'],
      'img_src': ['https://img.example/1.jpg'],
    });

    expect(result.thumbnail, 'https://thumb.example/1.jpg');
    expect(result.img_src, 'https://img.example/1.jpg');
  });

  test('SearchResult.fromJson falls back to thumbnail_src', () {
    final result = SearchResult.fromJson({
      'title': 'Example',
      'url': 'https://example.com',
      'content': 'Hello',
      'thumbnail_src': ['https://thumb.example/fallback.jpg'],
    });

    expect(result.thumbnail, 'https://thumb.example/fallback.jpg');
  });

  test('SearchResponse.fromJson accepts nested response metadata', () {
    final response = SearchResponse.fromJson({
      'query': 'cricket',
      'number_of_results': 1,
      'results': [
        {
          'title': 'Example',
          'url': 'https://example.com',
          'content': 'Hello',
        },
      ],
      'answers': [
        {'answer': 'Featured answer'},
      ],
      'unresponsive_engines': [
        ['bing images', 'timeout'],
      ],
    });

    expect(response.answers, ['Featured answer']);
    expect(response.unresponsive_engines, ['bing images: timeout']);
  });

  test('SearchResult metadata round-trips through toJson', () {
    final result = SearchResult.fromJson({
      'title': ['Example'],
      'url': ['https://example.com'],
      'content': ['Hello'],
      'engine': ['duckduckgo'],
      'template': ['default.html'],
      'author': ['Reporter'],
      'category': ['news'],
      'published_date': ['2026-03-31'],
    });

    expect(result.engine, 'duckduckgo');
    expect(result.category, 'news');
    expect(result.publishedDate, '2026-03-31');

    final reparsed = SearchResult.fromJson(result.toJson());
    expect(reparsed.engine, 'duckduckgo');
    expect(reparsed.category, 'news');
    expect(reparsed.publishedDate, '2026-03-31');
  });

  test('EngineInfo.fromJson accepts list-valued metadata', () {
    final engine = EngineInfo.fromJson({
      'name': ['duckduckgo'],
      'displayname': ['DuckDuckGo'],
      'description': ['Privacy focused', 'search'],
      'categories': [
        'general',
        ['news'],
      ],
    });

    expect(engine.name, 'duckduckgo');
    expect(engine.displayname, 'DuckDuckGo');
    expect(engine.description, 'Privacy focused: search');
    expect(engine.categories, ['general', 'news']);
  });
}
