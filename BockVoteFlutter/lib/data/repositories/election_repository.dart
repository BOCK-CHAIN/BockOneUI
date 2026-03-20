import 'package:dio/dio.dart';

import '../../core/network/api_service.dart';
import '../../core/network/network_exceptions.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/election_model.dart';
import '../models/candidate_model.dart';

/// Election repository for handling election-related API calls
class ElectionRepository {
  final ApiService _apiService;

  ElectionRepository(this._apiService);

  /// Get all elections
  Future<List<Election>> getElections({
    int? page,
    int? limit,
    ElectionStatus? status,
    ElectionType? type,
  }) async {
    try {
      final response = await _apiService.get(
        '/voting/elections',
        queryParameters: {
          'includeCandidates': 'true',
        },
      );

      final List<dynamic> electionsJson = response.data['elections'] ?? response.data;
      var elections = electionsJson
          .map((json) => Election.fromJson(json as Map<String, dynamic>))
          .toList();

      if (status != null) {
        elections = elections.where((election) => election.status == status).toList();
      }
      if (type != null) {
        elections = elections.where((election) => election.type == type).toList();
      }

      return elections;
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to fetch elections: ${e.toString()}');
    }
  }

  /// Get election by ID
  Future<Election> getElectionById(String electionId) async {
    try {
      final response = await _apiService.get(
        '/voting/election/$electionId',
        queryParameters: {'includeCandidates': 'true'},
      );
      return Election.fromJson(response.data);
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to fetch election: ${e.toString()}');
    }
  }

  /// Create new election
  Future<Election> createElection(ElectionCreateRequest request) async {
    try {
      final electionId = 'election-${DateTime.now().millisecondsSinceEpoch}';
      final response = await _apiService.post<Map<String, dynamic>>(
        '/voting/election/create',
        data: {
          'electionId': electionId,
          'title': request.title,
          'description': request.description,
          'startTime': request.startDate.millisecondsSinceEpoch ~/ 1000,
          'endTime': request.endDate.millisecondsSinceEpoch ~/ 1000,
        },
        options: Options(
          headers: {
            'X-Private-Key': request.settings?['adminKey'] ?? 'bockvote-admin',
          },
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 400) {
        throw NetworkExceptions(message: 'Failed to create election');
      }

      return getElectionById(electionId);
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to create election: ${e.toString()}');
    }
  }

  /// Update election
  Future<Election> updateElection(String electionId, ElectionUpdateRequest request) async {
    try {
      final endpoint = ApiEndpoints.replacePathParams(
        ApiEndpoints.updateElection,
        {'id': electionId},
      );

      final response = await _apiService.put(
        endpoint,
        data: request.toJson(),
      );

      return Election.fromJson(response.data);
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to update election: ${e.toString()}');
    }
  }

  /// Delete election
  Future<void> deleteElection(String electionId) async {
    try {
      throw NetworkExceptions(
        message: 'Delete election is not supported by the current BockVote backend.',
      );
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to delete election: ${e.toString()}');
    }
  }

  /// Get candidates for an election
  Future<List<Candidate>> getElectionCandidates(String electionId) async {
    try {
      final response = await _apiService.get(
        '/voting/election/$electionId',
        queryParameters: {'includeCandidates': 'true'},
      );
      final List<dynamic> candidatesJson = response.data['candidates'] ?? [];
      
      return candidatesJson
          .map((json) => Candidate.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to fetch election candidates: ${e.toString()}');
    }
  }

  /// Add candidate to election
  Future<void> addCandidateToElection(String electionId, String candidateId) async {
    try {
      await _apiService.post(
        '/voting/register/candidate',
        data: {
          'candidateId': candidateId,
          'electionId': electionId,
          'ipfsProfileHash': 'candidate-$candidateId',
        },
        options: Options(
          headers: {
            'X-Private-Key': 'bockvote-candidate',
          },
        ),
      );
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to add candidate to election: ${e.toString()}');
    }
  }

  /// Remove candidate from election
  Future<void> removeCandidateFromElection(String electionId, String candidateId) async {
    try {
      throw NetworkExceptions(
        message: 'Remove candidate is not supported by the current BockVote backend.',
      );
    } catch (e) {
      if (e is NetworkExceptions) {
        rethrow;
      }
      throw NetworkExceptions(message: 'Failed to remove candidate from election: ${e.toString()}');
    }
  }

  /// Get active elections
  Future<List<Election>> getActiveElections() async {
    return getElections(status: ElectionStatus.active);
  }

  /// Get upcoming elections
  Future<List<Election>> getUpcomingElections() async {
    return getElections(status: ElectionStatus.scheduled);
  }

  /// Get completed elections
  Future<List<Election>> getCompletedElections() async {
    return getElections(status: ElectionStatus.completed);
  }

  /// Search elections
  Future<List<Election>> searchElections(String query) async {
    final elections = await getElections();
    final normalizedQuery = query.toLowerCase();
    return elections.where((election) {
      return election.title.toLowerCase().contains(normalizedQuery) ||
          election.description.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  /// Start election
  Future<Election> startElection(String electionId) async {
    return getElectionById(electionId);
  }

  /// End election
  Future<Election> endElection(String electionId) async {
    return getElectionById(electionId);
  }

  /// Cancel election
  Future<Election> cancelElection(String electionId) async {
    return getElectionById(electionId);
  }
}
