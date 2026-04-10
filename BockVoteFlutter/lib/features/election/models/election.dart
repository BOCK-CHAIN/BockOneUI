import '../../../features/admin/models/election_type.dart';

/// Election model representing an election in the system
class Election {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final ElectionType type;
  final ElectionStatus status;
  final List<Candidate> candidates;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final int totalVotes;
  final bool isActive;

  const Election({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    required this.candidates,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.totalVotes = 0,
    this.isActive = false,
  });

  /// Create from JSON
  factory Election.fromJson(Map<String, dynamic> json) {
    return Election(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      type: ElectionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ElectionType.general,
      ),
      status: ElectionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ElectionStatus.draft,
      ),
      candidates: json['candidates'] != null
          ? (json['candidates'] as List)
              .map((c) => Candidate.fromJson(c as Map<String, dynamic>))
              .toList()
          : [],
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      totalVotes: json['totalVotes'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.name,
      'status': status.name,
      'candidates': candidates.map((c) => c.toJson()).toList(),
      'settings': settings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'totalVotes': totalVotes,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  Election copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    ElectionType? type,
    ElectionStatus? status,
    List<Candidate>? candidates,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    int? totalVotes,
    bool? isActive,
  }) {
    return Election(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      status: status ?? this.status,
      candidates: candidates ?? this.candidates,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      totalVotes: totalVotes ?? this.totalVotes,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Check if election is currently active
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && status == ElectionStatus.active;
  }

  /// Check if election is upcoming
  bool get isUpcoming {
    final now = DateTime.now();
    return now.isBefore(startDate);
  }

  /// Check if election has ended
  bool get hasEnded {
    final now = DateTime.now();
    return now.isAfter(endDate);
  }

  /// Get election duration in days
  int get durationInDays {
    return endDate.difference(startDate).inDays;
  }

  @override
  String toString() {
    return 'Election(id: $id, title: $title, status: $status, '
           'startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Election && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Election status enumeration
enum ElectionStatus {
  draft,
  scheduled,
  active,
  paused,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case ElectionStatus.draft:
        return 'Draft';
      case ElectionStatus.scheduled:
        return 'Scheduled';
      case ElectionStatus.active:
        return 'Active';
      case ElectionStatus.paused:
        return 'Paused';
      case ElectionStatus.completed:
        return 'Completed';
      case ElectionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Candidate model for elections
class Candidate {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? party;
  final Map<String, dynamic> metadata;
  final int voteCount;

  const Candidate({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.party,
    this.metadata = const {},
    this.voteCount = 0,
  });

  /// Create from JSON
  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      party: json['party'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      voteCount: json['voteCount'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'party': party,
      'metadata': metadata,
      'voteCount': voteCount,
    };
  }

  /// Create a copy with updated fields
  Candidate copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? party,
    Map<String, dynamic>? metadata,
    int? voteCount,
  }) {
    return Candidate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      party: party ?? this.party,
      metadata: metadata ?? this.metadata,
      voteCount: voteCount ?? this.voteCount,
    );
  }

  @override
  String toString() {
    return 'Candidate(id: $id, name: $name, party: $party, voteCount: $voteCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Candidate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}