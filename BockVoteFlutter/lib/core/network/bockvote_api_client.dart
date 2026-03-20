import 'package:dio/dio.dart';
import '../../data/models/api_request_models.dart';
import '../../data/models/api_response_models.dart';

class BockVoteApiClient {
  final Dio _dio;

  // The backend API runs on port 9000 according to the docs.
  BockVoteApiClient({String baseUrl = 'http://127.0.0.1:9000'})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  /// Sets the private key for the current user in the request header.
  /// The backend will use this to sign transactions.
  void setPrivateKey(String privateKey) {
    _dio.options.headers['X-Private-Key'] = privateKey;
  }

  /// Clears the private key from the request header.
  void clearPrivateKey() {
    _dio.options.headers.remove('X-Private-Key');
  }

  // --- Voting API Endpoints ---

  /// Register a new voter.
  Future<TransactionResponse> registerVoter(VoterRegistrationRequest request) async {
    final response = await _dio.post('/voting/register/voter', data: request.toJson());
    return TransactionResponse.fromJson(response.data);
  }

  /// Register a new candidate for an election.
  Future<TransactionResponse> registerCandidate(CandidateRegistrationRequest request) async {
    final response = await _dio.post('/voting/register/candidate', data: request.toJson());
    return TransactionResponse.fromJson(response.data);
  }

  /// Create a new election.
  Future<TransactionResponse> createElection(ElectionCreationRequest request) async {
    final response = await _dio.post('/voting/election/create', data: request.toJson());
    return TransactionResponse.fromJson(response.data);
  }

  /// Cast a vote in an election.
  Future<TransactionResponse> castVote(VoteRequest request) async {
    final response = await _dio.post('/voting/vote', data: request.toJson());
    return TransactionResponse.fromJson(response.data);
  }

  /// Get details for a specific election.
  Future<ElectionResponse> getElection(String electionId) async {
    final response = await _dio.get('/voting/election/$electionId');
    return ElectionResponse.fromJson(response.data);
  }

  /// Get the results for a specific election.
  Future<ElectionResultsResponse> getElectionResults(String electionId) async {
    final response = await _dio.get('/voting/election/$electionId/results');
    return ElectionResultsResponse.fromJson(response.data);
  }

  /// Get details for a specific voter.
  Future<VoterResponse> getVoter(String voterId) async {
    final response = await _dio.get('/voting/voter/$voterId');
    return VoterResponse.fromJson(response.data);
  }

  /// Get details for a specific candidate in an election.
  Future<CandidateResponse> getCandidate(String electionId, String candidateId) async {
    final response = await _dio.get('/voting/candidate/$electionId/$candidateId');
    return CandidateResponse.fromJson(response.data);
  }

  /// Approve a voter registration. This requires an admin private key to be set.
  Future<Response> approveVoter(ApproveVoterRequest request) async {
    // The backend doc is unclear on the response, so we return the raw Dio Response.
    return await _dio.post('/voting/approve/voter', data: request.toJson());
  }

  /// Approve a candidate registration. This requires the election admin's private key to be set.
  Future<Response> approveCandidate(ApproveCandidateRequest request) async {
    // The backend doc is unclear on the response, so we return the raw Dio Response.
    return await _dio.post('/voting/approve/candidate', data: request.toJson());
  }

  // --- Core Blockchain Endpoints ---

  Future<Response> getBlock(String hashorid) async {
    return await _dio.get('/block/$hashorid');
  }

  Future<Response> getTx(String hash) async {
    return await _dio.get('/tx/$hash');
  }
}