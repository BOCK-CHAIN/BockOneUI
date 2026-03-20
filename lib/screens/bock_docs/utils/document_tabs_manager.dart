// document_tabs_manager.dart - Manages open document tabs
import 'package:flutter/material.dart';

class OpenDocument {
  final String? documentId;
  final String title;
  final String content;
  final bool isUnsaved;
  final DateTime lastModified;
  final String? shareToken;

  OpenDocument({
    this.documentId,
    required this.title,
    required this.content,
    this.isUnsaved = false,
    DateTime? lastModified,
    this.shareToken,
  }) : lastModified = lastModified ?? DateTime.now();

  OpenDocument copyWith({
    String? documentId,
    String? title,
    String? content,
    bool? isUnsaved,
    DateTime? lastModified,
    String? shareToken,
  }) {
    return OpenDocument(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      content: content ?? this.content,
      isUnsaved: isUnsaved ?? this.isUnsaved,
      lastModified: lastModified ?? this.lastModified,
      shareToken: shareToken ?? this.shareToken,
    );
  }
}

class DocumentTabsManager extends ChangeNotifier {
  final List<OpenDocument> _openDocuments = [];
  int _activeTabIndex = 0;

  List<OpenDocument> get openDocuments => List.unmodifiable(_openDocuments);
  int get activeTabIndex => _activeTabIndex;
  OpenDocument? get activeDocument => _openDocuments.isNotEmpty && _activeTabIndex < _openDocuments.length
      ? _openDocuments[_activeTabIndex]
      : null;
  int get tabCount => _openDocuments.length;

  void addDocument(OpenDocument document) {
    // Check if document is already open (by ID if it has one, or by title if new)
    int existingIndex = -1;
    
    if (document.documentId != null) {
      // For saved documents, check by ID
      existingIndex = _openDocuments.indexWhere(
        (doc) => doc.documentId == document.documentId,
      );
    } else {
      // For new/unsaved documents, check if there's already an unsaved document with same title
      // Only match if both are unsaved and have same title
      existingIndex = _openDocuments.indexWhere(
        (doc) => doc.documentId == null && 
                  doc.title == document.title &&
                  doc.isUnsaved == document.isUnsaved,
      );
    }

    if (existingIndex != -1) {
      // Switch to existing tab and update it
      _activeTabIndex = existingIndex;
      _openDocuments[existingIndex] = document;
    } else {
      // Add new tab
      _openDocuments.add(document);
      _activeTabIndex = _openDocuments.length - 1;
    }
    notifyListeners();
  }

  void switchToTab(int index) {
    if (index >= 0 && index < _openDocuments.length) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  void closeTab(int index) {
    if (index < 0 || index >= _openDocuments.length) return;

    _openDocuments.removeAt(index);

    // Adjust active tab index
    if (_activeTabIndex >= _openDocuments.length) {
      _activeTabIndex = _openDocuments.length > 0 ? _openDocuments.length - 1 : 0;
    } else if (_activeTabIndex > index) {
      _activeTabIndex--;
    }

    notifyListeners();
  }

  void updateActiveDocument({
    String? title,
    String? content,
    bool? isUnsaved,
    String? documentId,
  }) {
    if (_activeTabIndex >= 0 && _activeTabIndex < _openDocuments.length) {
      final current = _openDocuments[_activeTabIndex];
      _openDocuments[_activeTabIndex] = current.copyWith(
        title: title,
        content: content,
        isUnsaved: isUnsaved,
        documentId: documentId,
      );
      notifyListeners();
    }
  }

  void clearAll() {
    _openDocuments.clear();
    _activeTabIndex = 0;
    notifyListeners();
  }
}

