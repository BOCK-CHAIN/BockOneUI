import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../models/candidate_model.dart';
import '../models/election_model.dart';
import '../models/vote_model.dart';

/// Provider for managing elections and voting
class ElectionProvider extends ChangeNotifier {
  static const String _privateKeySeedStorageKey = 'bockvote_private_key_seed';

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

  List<ElectionModel> _elections = [];
  List<CandidateModel> _candidates = [];
  final List<VoteModel> _votes = [];
  bool _isLoading = false;
  String? _error;

  List<ElectionModel> get elections => _elections;
  List<CandidateModel> get candidates => _candidates;
  List<VoteModel> get votes => _votes;
  bool get isLoading => _isLoading;
  bool get isCandidatesLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Fetch all elections from BockVote backend.
  Future<void> fetchElections() async {
    setLoading(true);
    setError(null);

    try {
      final response = await _dio.get(
        '/voting/elections',
        queryParameters: {'includeCandidates': 'true'},
      );

      final electionsJson = _extractList(response.data);
      final mappedElections = <ElectionModel>[];
      final mappedCandidates = <CandidateModel>[];

      for (final item in electionsJson) {
        if (item is! Map) continue;
        final electionJson = Map<String, dynamic>.from(item);

        final election = _mapElection(electionJson);
        mappedElections.add(election);

        final candidates = _mapCandidates(electionJson, election);
        mappedCandidates.addAll(candidates);
      }

      _elections = mappedElections;
      _candidates = mappedCandidates;

      notifyListeners();
    } catch (e) {
      setError('Failed to fetch elections: ${_readableError(e)}');
    } finally {
      setLoading(false);
    }
  }

  /// Fetch candidates for a specific election.
  Future<void> fetchCandidates(String electionId) async {
    setLoading(true);
    setError(null);

    try {
      final response = await _dio.get(
        '/voting/election/$electionId',
        queryParameters: {'includeCandidates': 'true'},
      );

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Unexpected candidate response format');
      }

      final electionJson = response.data as Map<String, dynamic>;
      final election = _mapElection(electionJson);
      final candidates = _mapCandidates(electionJson, election);

      _candidates.removeWhere((candidate) => election.candidateIds.contains(candidate.id));
      _candidates.addAll(candidates);

      final index = _elections.indexWhere((e) => e.id == election.id);
      if (index >= 0) {
        _elections[index] = election;
      } else {
        _elections.add(election);
      }

      notifyListeners();
    } catch (e) {
      setError('Failed to fetch candidates: ${_readableError(e)}');
    } finally {
      setLoading(false);
    }
  }

  /// Cast a vote in an election.
  Future<bool> castVote(String userId, String electionId, String candidateId) async {
    setLoading(true);
    setError(null);

    try {
      final privateKeySeed = await _getOrCreatePrivateKeySeed(userId);

      final response = await _dio.post(
        '/voting/vote',
        data: {
          'electionId': electionId,
          'candidateId': candidateId,
        },
        options: Options(
          headers: {
            'X-Private-Key': privateKeySeed,
          },
        ),
      );

      final responseMap = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final txHash = (responseMap['txHash'] ?? '').toString();

      _votes.removeWhere((vote) => vote.userId == userId && vote.electionId == electionId);
      _votes.add(
        VoteModel(
          id: txHash.isNotEmpty ? txHash : DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          electionId: electionId,
          candidateId: candidateId,
          timestamp: DateTime.now(),
          receiptCode: txHash.isNotEmpty
              ? txHash.substring(0, txHash.length > 12 ? 12 : txHash.length)
              : null,
          isVerified: txHash.isNotEmpty,
        ),
      );

      await fetchElections();
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to cast vote: ${_readableError(e)}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Get user's votes.
  List<VoteModel> getUserVotes(String userId) {
    return _votes.where((vote) => vote.userId == userId).toList();
  }

  /// Get election by ID.
  ElectionModel? getElectionById(String id) {
    try {
      return _elections.firstWhere((election) => election.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get candidate by ID.
  CandidateModel? getCandidateById(String id) {
    try {
      return _candidates.firstWhere((candidate) => candidate.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get candidates for a specific election.
  List<CandidateModel> getCandidatesForElection(String electionId) {
    final election = getElectionById(electionId);
    if (election == null) return [];

    return _candidates.where((candidate) => election.candidateIds.contains(candidate.id)).toList();
  }

  /// Get user's vote for a specific election.
  VoteModel? getUserVoteForElection(String userId, String electionId) {
    try {
      return _votes.firstWhere(
        (vote) => vote.userId == userId && vote.electionId == electionId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Fetch candidates for a specific election (async version).
  Future<void> fetchCandidatesForElection(String electionId) async {
    await fetchCandidates(electionId);
  }

  Future<String> _getOrCreatePrivateKeySeed(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final existingSeed = prefs.getString(_privateKeySeedStorageKey);
    if (existingSeed != null && existingSeed.isNotEmpty) {
      return existingSeed;
    }

    final fallbackUser = userId.isEmpty ? 'local-user' : userId;
    final generatedSeed = '$fallbackUser-${DateTime.now().microsecondsSinceEpoch}';
    await prefs.setString(_privateKeySeedStorageKey, generatedSeed);
    return generatedSeed;
  }

  ElectionModel _mapElection(Map<String, dynamic> json) {
    final startDate = _fromUnixSeconds(json['startTime']);
    final endDate = _fromUnixSeconds(json['endTime']);

    final candidateList = json['candidates'] is List ? json['candidates'] as List : const [];
    final candidateIds = candidateList
        .whereType<Map>()
        .map((candidate) => Map<String, dynamic>.from(candidate))
        .map((candidate) => (candidate['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toList();

    final status = _mapStatus(
      backendStatus: (json['status'] ?? '').toString(),
      startDate: startDate,
      endDate: endDate,
    );

    return ElectionModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      startDate: startDate,
      endDate: endDate,
      status: status,
      candidateIds: candidateIds,
      results: {
        'voteCounts': json['voteCounts'] ?? <String, dynamic>{},
      },
    );
  }

  List<CandidateModel> _mapCandidates(Map<String, dynamic> electionJson, ElectionModel election) {
    final candidates = electionJson['candidates'] is List
        ? electionJson['candidates'] as List
        : const [];
    final voteCounts = electionJson['voteCounts'] is Map<String, dynamic>
        ? electionJson['voteCounts'] as Map<String, dynamic>
        : <String, dynamic>{};

    return candidates.whereType<Map>().map((candidateJson) {
      final mappedCandidate = Map<String, dynamic>.from(candidateJson);
      final candidateId = (mappedCandidate['id'] ?? '').toString();
      final profileHash = (mappedCandidate['ipfsProfileHash'] ?? '').toString();

      return CandidateModel(
        id: candidateId,
        name: profileHash.isNotEmpty ? profileHash : 'Candidate $candidateId',
        party: 'Independent',
        position: election.title,
        biography: profileHash.isNotEmpty ? 'IPFS: $profileHash' : null,
        voteCount: _asInt(voteCounts[candidateId] ?? mappedCandidate['voteCount']),
      );
    }).toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic> && data['elections'] is List) {
      return data['elections'] as List;
    }
    return const [];
  }

  String _mapStatus({
    required String backendStatus,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final now = DateTime.now();

    if (backendStatus == 'active') return 'active';
    if (backendStatus == 'ended') return 'completed';

    if (now.isBefore(startDate)) return 'upcoming';
    if (now.isAfter(endDate)) return 'completed';
    return 'active';
  }

  DateTime _fromUnixSeconds(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
    }

    final parsedInt = int.tryParse(value?.toString() ?? '');
    if (parsedInt != null) {
      return DateTime.fromMillisecondsSinceEpoch(parsedInt * 1000);
    }

    return DateTime.now();
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
