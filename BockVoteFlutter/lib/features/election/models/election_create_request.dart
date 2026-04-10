import '../../../features/admin/models/election_type.dart';

/// Request model for creating an election
class ElectionCreateRequest {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final ElectionType type;
  final List<String>? candidates;
  final Map<String, dynamic>? settings;

  const ElectionCreateRequest({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.candidates,
    this.settings,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.name,
      'candidates': candidates,
      'settings': settings,
    };
  }

  /// Create from JSON
  factory ElectionCreateRequest.fromJson(Map<String, dynamic> json) {
    return ElectionCreateRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      type: ElectionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ElectionType.general,
      ),
      candidates: json['candidates'] != null 
          ? List<String>.from(json['candidates'] as List)
          : null,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  /// Create a copy with updated fields
  ElectionCreateRequest copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    ElectionType? type,
    List<String>? candidates,
    Map<String, dynamic>? settings,
  }) {
    return ElectionCreateRequest(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      candidates: candidates ?? this.candidates,
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() {
    return 'ElectionCreateRequest(title: $title, description: $description, '
           'startDate: $startDate, endDate: $endDate, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ElectionCreateRequest &&
        other.title == title &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.type == type;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        type.hashCode;
  }
}