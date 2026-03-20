import 'package:json_annotation/json_annotation.dart';

part 'api_request_models.g.dart';

@JsonSerializable()
class VoterRegistrationRequest {
  @JsonKey(name: 'VoterID')
  final String voterId;
  @JsonKey(name: 'IPFSDocHash')
  final String ipfsDocHash;

  VoterRegistrationRequest({
    required this.voterId,
    required this.ipfsDocHash,
  });

  Map<String, dynamic> toJson() => _$VoterRegistrationRequestToJson(this);
}

@JsonSerializable()
class CandidateRegistrationRequest {
  @JsonKey(name: 'CandidateID')
  final String candidateId;
  @JsonKey(name: 'ElectionID')
  final String electionId;
  @JsonKey(name: 'IPFSProfileHash')
  final String ipfsProfileHash;

  CandidateRegistrationRequest({
    required this.candidateId,
    required this.electionId,
    required this.ipfsProfileHash,
  });

  Map<String, dynamic> toJson() => _$CandidateRegistrationRequestToJson(this);
}

@JsonSerializable()
class ElectionCreationRequest {
  @JsonKey(name: 'ElectionID')
  final String electionId;
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'StartTime')
  final int startTime;
  @JsonKey(name: 'EndTime')
  final int endTime;

  ElectionCreationRequest({
    required this.electionId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => _$ElectionCreationRequestToJson(this);
}

@JsonSerializable()
class VoteRequest {
  @JsonKey(name: 'ElectionID')
  final String electionId;
  @JsonKey(name: 'CandidateID')
  final String candidateId;

  VoteRequest({
    required this.electionId,
    required this.candidateId,
  });

  Map<String, dynamic> toJson() => _$VoteRequestToJson(this);
}

@JsonSerializable()
class ApproveVoterRequest {
  final String voterId;

  ApproveVoterRequest({required this.voterId});

  Map<String, dynamic> toJson() => _$ApproveVoterRequestToJson(this);
}

@JsonSerializable()
class ApproveCandidateRequest {
  final String electionId;
  final String candidateId;

  ApproveCandidateRequest({required this.electionId, required this.candidateId});

  Map<String, dynamic> toJson() => _$ApproveCandidateRequestToJson(this);
}