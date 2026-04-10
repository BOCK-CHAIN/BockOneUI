// models/document_model.dart
class DocumentModel {
  final String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime lastModified;
  String ownerId;
  List<String> sharedWith;
  bool isStarred;
  String? folderId;

  DocumentModel({
    required this.id,
    required this.title,
    this.content = '',
    required this.createdAt,
    required this.lastModified,
    required this.ownerId,
    this.sharedWith = const [],
    this.isStarred = false,
    this.folderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'isStarred': isStarred,
      'folderId': folderId,
    };
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      title: json['title'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
      ownerId: json['ownerId'],
      sharedWith: List<String>.from(json['sharedWith'] ?? []),
      isStarred: json['isStarred'] ?? false,
      folderId: json['folderId'],
    );
  }

  DocumentModel copyWith({
    String? title,
    String? content,
    DateTime? lastModified,
    bool? isStarred,
    String? folderId,
  }) {
    return DocumentModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      lastModified: lastModified ?? this.lastModified,
      ownerId: ownerId,
      sharedWith: sharedWith,
      isStarred: isStarred ?? this.isStarred,
      folderId: folderId ?? this.folderId,
    );
  }
}

// models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get initials {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

// models/folder_model.dart
class FolderModel {
  final String id;
  String name;
  final DateTime createdAt;
  DateTime lastModified;
  final String ownerId;
  List<String> sharedWith;
  String? parentFolderId;

  FolderModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastModified,
    required this.ownerId,
    this.sharedWith = const [],
    this.parentFolderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'parentFolderId': parentFolderId,
    };
  }

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
      ownerId: json['ownerId'],
      sharedWith: List<String>.from(json['sharedWith'] ?? []),
      parentFolderId: json['parentFolderId'],
    );
  }
}

// services/document_service.dart
class DocumentService {
  // Singleton pattern
  static final DocumentService _instance = DocumentService._internal();
  factory DocumentService() => _instance;
  DocumentService._internal();

  final List<DocumentModel> _documents = [];
  
  // Get all documents for a user
  List<DocumentModel> getDocuments(String userId) {
    return _documents.where((doc) => 
      doc.ownerId == userId || doc.sharedWith.contains(userId)
    ).toList()..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  // Get recent documents (last 10)
  List<DocumentModel> getRecentDocuments(String userId) {
    List<DocumentModel> docs = getDocuments(userId);
    return docs.take(10).toList();
  }

  // Get starred documents
  List<DocumentModel> getStarredDocuments(String userId) {
    return _documents.where((doc) => 
      (doc.ownerId == userId || doc.sharedWith.contains(userId)) && doc.isStarred
    ).toList()..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  // Create new document
  DocumentModel createDocument(String userId, {String title = 'Untitled document'}) {
    final doc = DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      ownerId: userId,
    );
    _documents.add(doc);
    return doc;
  }

  // Update document
  void updateDocument(DocumentModel document) {
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index != -1) {
      _documents[index] = document.copyWith(lastModified: DateTime.now());
    }
  }

  // Delete document
  void deleteDocument(String documentId) {
    _documents.removeWhere((doc) => doc.id == documentId);
  }

  // Toggle star
  void toggleStar(String documentId) {
    final index = _documents.indexWhere((doc) => doc.id == documentId);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(
        isStarred: !_documents[index].isStarred
      );
    }
  }

  // Share document
  void shareDocument(String documentId, String userId) {
    final index = _documents.indexWhere((doc) => doc.id == documentId);
    if (index != -1) {
      if (!_documents[index].sharedWith.contains(userId)) {
        _documents[index].sharedWith.add(userId);
      }
    }
  }

  // Get document by ID
  DocumentModel? getDocumentById(String documentId) {
    try {
      return _documents.firstWhere((doc) => doc.id == documentId);
    } catch (e) {
      return null;
    }
  }

  // Search documents
  List<DocumentModel> searchDocuments(String userId, String query) {
    query = query.toLowerCase();
    return _documents.where((doc) => 
      (doc.ownerId == userId || doc.sharedWith.contains(userId)) &&
      (doc.title.toLowerCase().contains(query) || 
       doc.content.toLowerCase().contains(query))
    ).toList();
  }
}

// services/user_service.dart
class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  UserModel? _currentUser;
  final List<UserModel> _users = [];

  // Get current user
  UserModel? get currentUser => _currentUser;

  // Login
  bool login(String email, String password) {
    // In a real app, this would validate against a backend
    // For now, create a demo user
    _currentUser = UserModel(
      id: '1',
      name: 'Demo User',
      email: email,
      createdAt: DateTime.now(),
    );
    return true;
  }

  // Sign up
  bool signUp(String name, String email, String password) {
    // In a real app, this would create a user in the backend
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    _users.add(_currentUser!);
    return true;
  }

  // Logout
  void logout() {
    _currentUser = null;
  }

  // Update user profile
  void updateProfile(String name, String? photoUrl) {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: name,
        email: _currentUser!.email,
        photoUrl: photoUrl,
        createdAt: _currentUser!.createdAt,
      );
    }
  }

  // Get user by ID
  UserModel? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
}

// services/folder_service.dart
class FolderService {
  // Singleton pattern
  static final FolderService _instance = FolderService._internal();
  factory FolderService() => _instance;
  FolderService._internal();

  final List<FolderModel> _folders = [];

  // Get all folders for a user
  List<FolderModel> getFolders(String userId) {
    return _folders.where((folder) => 
      folder.ownerId == userId || folder.sharedWith.contains(userId)
    ).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  // Create new folder
  FolderModel createFolder(String userId, String name, {String? parentFolderId}) {
    final folder = FolderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      ownerId: userId,
      parentFolderId: parentFolderId,
    );
    _folders.add(folder);
    return folder;
  }

  // Update folder
  void updateFolder(FolderModel folder) {
    final index = _folders.indexWhere((f) => f.id == folder.id);
    if (index != -1) {
      _folders[index] = folder;
    }
  }

  // Delete folder
  void deleteFolder(String folderId) {
    _folders.removeWhere((folder) => folder.id == folderId);
  }

  // Get folder by ID
  FolderModel? getFolderById(String folderId) {
    try {
      return _folders.firstWhere((folder) => folder.id == folderId);
    } catch (e) {
      return null;
    }
  }

  // Get subfolders
  List<FolderModel> getSubfolders(String userId, String? parentFolderId) {
    return _folders.where((folder) => 
      (folder.ownerId == userId || folder.sharedWith.contains(userId)) &&
      folder.parentFolderId == parentFolderId
    ).toList();
  }
}

// utils/date_utils.dart
class DateHelper {
  static String getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    
    if (diff.inDays > 365) {
      int years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (diff.inDays > 30) {
      int months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (date == yesterday) {
      return 'Yesterday ${_formatTime(dateTime)}';
    } else if (now.difference(dateTime).inDays < 7) {
      return '${_getWeekday(dateTime)} ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  static String _getWeekday(DateTime dateTime) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[dateTime.weekday - 1];
  }
}

// utils/text_formatter.dart
class TextFormatter {
  static String getTruncatedText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String getWordCount(String text) {
    if (text.isEmpty) return '0 words';
    List<String> words = text.trim().split(RegExp(r'\s+'));
    int count = words.where((word) => word.isNotEmpty).length;
    return '$count word${count != 1 ? 's' : ''}';
  }

  static String getCharacterCount(String text) {
    return '${text.length} character${text.length != 1 ? 's' : ''}';
  }

  static int getPageCount(String text) {
    // Rough estimation: 250 words per page
    if (text.isEmpty) return 0;
    List<String> words = text.trim().split(RegExp(r'\s+'));
    int wordCount = words.where((word) => word.isNotEmpty).length;
    return (wordCount / 250).ceil();
  }
}

// constants/app_constants.dart
class AppConstants {
  // Colors
  static const primaryColor = 0xFF9333EA;
  static const secondaryColor = 0xFF6B46C1;
  static const backgroundColor = 0xFFF9FAFB;
  static const surfaceColor = 0xFFFFFFFF;
  static const textPrimaryColor = 0xFF1F2937;
  static const textSecondaryColor = 0xFF6B7280;

  // Sizes
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double documentWidth = 816.0;
  
  // Font families
  static const List<String> fontFamilies = [
    'Arial',
    'Calibri',
    'Comic Sans MS',
    'Courier New',
    'Georgia',
    'Times New Roman',
    'Trebuchet MS',
    'Verdana',
  ];

  // Font sizes
  static const List<int> fontSizes = [
    6, 7, 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72
  ];

  // Document templates
  static const Map<String, String> templates = {
    'blank': '',
    'resume': '''[Your Name]
[Your Address]
[City, State ZIP Code]
[Phone Number]
[Email Address]

OBJECTIVE
[Write your career objective here]

EDUCATION
[Degree] - [University Name]
[Graduation Date]

EXPERIENCE
[Job Title] - [Company Name]
[Employment Dates]
• [Responsibility/Achievement]
• [Responsibility/Achievement]

SKILLS
• [Skill 1]
• [Skill 2]
• [Skill 3]
''',
    'letter': '''[Your Name]
[Your Address]
[City, State ZIP Code]
[Date]

[Recipient Name]
[Company Name]
[Company Address]
[City, State ZIP Code]

Dear [Recipient Name],

[Opening paragraph]

[Body paragraph]

[Closing paragraph]

Sincerely,
[Your Name]
''',
    'report': '''[Report Title]
[Date]
[Author Name]

Executive Summary
[Provide a brief overview of the report]

Introduction
[Introduce the topic and purpose]

Findings
[Present your findings and analysis]

Conclusion
[Summarize key points]

Recommendations
[Provide recommendations based on findings]
''',
  };
}

// validators/form_validators.dart
class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}