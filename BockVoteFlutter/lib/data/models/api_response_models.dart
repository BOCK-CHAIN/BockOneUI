import 'package:json_annotation/json_annotation.dart';

part 'api_response_models.g.dart';

@JsonSerializable()
class VoterResponse {
  final String id;
  final String publicKey;
  final String ipfsDocHash;
  final String status;
  final int timestamp;

  VoterResponse({
    required this.id,
    required this.publicKey,
    required this.ipfsDocHash,
    required this.status,
    required this.timestamp,
  });

  factory VoterResponse.fromJson(Map<String, dynamic> json) =>
      _$VoterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoterResponseToJson(this);
}

@JsonSerializable()
class CandidateResponse {
  final String id;
  @JsonKey(name: 'electionId')
  final String electionId;
  final String publicKey;
  final String ipfsProfileHash;
  final String status;
  final int voteCount;
  final int timestamp;

  CandidateResponse({
    required this.id,
    required this.electionId,
    required this.publicKey,
    required this.ipfsProfileHash,
    required this.status,
    required this.voteCount,
    required this.timestamp,
  });

  factory CandidateResponse.fromJson(Map<String, dynamic> json) =>
      _$CandidateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ElectionResponse {
  final String id;
  final String title;
  final String description;
  final int startTime;
  final int endTime;
  final String adminKey;
  final String status;
  final int timestamp;
  @JsonKey(defaultValue: [])
  final List<CandidateResponse> candidates;
  @JsonKey(defaultValue: {})
  final Map<String, int> voteCounts;

  ElectionResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.adminKey,
    required this.status,
    required this.timestamp,
    required this.candidates,
    required this.voteCounts,
  });

  factory ElectionResponse.fromJson(Map<String, dynamic> json) =>
      _$ElectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ElectionResponseToJson(this);
}

@JsonSerializable()
class TransactionResponse {
  final String status;
  final String txHash;

  TransactionResponse({required this.status, required this.txHash});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}

@JsonSerializable()
class ElectionResultsResponse {
  final String id;
  final String title;
  final String status;
  final Map<String, int> voteCounts;

  ElectionResultsResponse({
    required this.id,
    required this.title,
    required this.status,
    required this.voteCounts,
  });

  factory ElectionResultsResponse.fromJson(Map<String, dynamic> json) =>
      _$ElectionResultsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ElectionResultsResponseToJson(this);
}