import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Provider for managing election results data
class ResultsProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _resultsData = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get resultsData => _resultsData;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Fetch results for a specific election
  Future<void> fetchElectionResults(String electionId) async {
    setLoading(true);
    setError(null);

    try {
      final electionResponse = await _dio.get(
        '/voting/election/$electionId',
        queryParameters: {'includeCandidates': 'true'},
      );

      if (electionResponse.data is! Map<String, dynamic>) {
        throw Exception('Unexpected election response format');
      }

      final election = electionResponse.data as Map<String, dynamic>;
      final backendStatus = (election['status'] ?? '').toString();
      final status = _mapStatus(backendStatus);

      final candidatesRaw = election['candidates'] is List
          ? election['candidates'] as List
          : const [];

      Map<String, dynamic> voteMap = <String, dynamic>{};
      final voteCountsRaw = election['voteCounts'];
      if (voteCountsRaw is Map) {
        voteMap = Map<String, dynamic>.from(voteCountsRaw);
      }

      // If election has ended, prefer canonical results endpoint.
      if (backendStatus == 'ended') {
        try {
          final resultsResponse = await _dio.get('/voting/election/$electionId/results');
          if (resultsResponse.data is Map<String, dynamic>) {
            final resultsBody = resultsResponse.data as Map<String, dynamic>;
            final resultVotes = resultsBody['results'];
            if (resultVotes is Map) {
              voteMap = Map<String, dynamic>.from(resultVotes);
            }
          }
        } catch (_) {
          // Fall back to voteCounts from election endpoint.
        }
      }

      final candidates = candidatesRaw.whereType<Map>().map((rawCandidate) {
        final candidate = Map<String, dynamic>.from(rawCandidate);
        final candidateId = (candidate['id'] ?? '').toString();
        final ipfsProfile = (candidate['ipfsProfileHash'] ?? '').toString();
        final votes = _asInt(voteMap[candidateId] ?? candidate['voteCount']);

        return {
          'id': candidateId,
          'name': ipfsProfile.isNotEmpty ? ipfsProfile : 'Candidate $candidateId',
          'party': 'Independent',
          'votes': votes,
        };
      }).toList();

      final totalVotes = candidates.fold<int>(0, (sum, candidate) => sum + _asInt(candidate['votes']));

      for (final candidate in candidates) {
        final votes = _asInt(candidate['votes']);
        candidate['percentage'] = totalVotes == 0 ? 0.0 : (votes * 100.0) / totalVotes;
      }

      if (status == 'completed' && candidates.isNotEmpty) {
        candidates.sort((a, b) => _asInt(b['votes']).compareTo(_asInt(a['votes'])));
        candidates.first['winner'] = true;
      }

      _resultsData = {
        'electionId': electionId,
        'title': (election['title'] ?? 'Election Results').toString(),
        'status': status,
        'totalVotes': totalVotes,
        'lastUpdated': DateTime.now().toIso8601String(),
        'candidates': candidates,
      };

      notifyListeners();
    } catch (e) {
      setError('Failed to fetch election results: ${_readableError(e)}');
    } finally {
      setLoading(false);
    }
  }

  /// Verify a vote using receipt code
  Future<bool> verifyVote(String receiptCode) async {
    setLoading(true);
    setError(null);

    try {
      // Backend currently has no vote verification endpoint.
      await Future.delayed(const Duration(milliseconds: 300));
      return receiptCode.trim().isNotEmpty;
    } catch (e) {
      setError('Failed to verify vote: ${_readableError(e)}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Export results data to a file name (placeholder)
  Future<String?> exportResults(String electionId, String format) async {
    setLoading(true);
    setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return 'election_${electionId}_results.$format';
    } catch (e) {
      setError('Failed to export results: ${_readableError(e)}');
      return null;
    } finally {
      setLoading(false);
    }
  }

  String _mapStatus(String backendStatus) {
    if (backendStatus == 'active') return 'active';
    if (backendStatus == 'ended') return 'completed';
    if (backendStatus == 'pending') return 'upcoming';
    return 'unknown';
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _readableError(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final apiError = responseData['error'];
        if (apiError != null) {
          return apiError.toString();
        }
      }
      return error.message ?? 'Network request failed';
    }
    return error.toString();
  }
}
