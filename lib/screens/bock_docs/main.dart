// main.dart - COMPLETE BOCKDOCS APPLICATION
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'config/api_config.dart';
import 'dart:async'; // adjust path to your ApiConfig
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils/download_helper.dart';
import 'utils/document_formats.dart';
import 'utils/document_tabs_manager.dart';
import 'utils/file_handler.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load saved API base URL if available
  await ApiConfig.loadSavedBaseUrl();
  // Set system UI overlay style for mobile
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
  runApp(const BockDocsApp());
}

class BockDocsApp extends StatelessWidget {
  const BockDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DocumentTabsManager()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'BockDocs',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            initialRoute: _getInitialRoute(),
            onGenerateRoute: (settings) {
              if (settings.name == '/editor') {
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (context) => EditorPage(
                    documentId: args?['documentId'] as String?,
                    shareToken: args?['shareToken'] as String?,
                  ),
                );
              }
              if (settings.name == '/shared') {
                return MaterialPageRoute(
                  builder: (context) => _buildSharedRoute(context, settings),
                );
              }
              return null;
            },
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/forgot-password': (context) => const ForgotPasswordPage(),
              '/reset-password': (context) => const ResetPasswordPage(),
              '/home': (context) => const HomePage(),
              '/editor': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                return EditorPage(
                  documentId: args?['documentId'] as String?,
                  shareToken: args?['shareToken'] as String?,
                );
              },
              '/settings': (context) => const SettingsPage(),
              '/shared': (context) {
                final route = ModalRoute.of(context);
                return _buildSharedRoute(context, route?.settings);
              },
            },
          );
        },
      ),
    );
  }

  String _getInitialRoute() {
    if (kIsWeb) {
      final uri = Uri.base;
      // Check if we're on a shared document route
      if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'shared') {
        return '/shared';
      }
      if (uri.queryParameters.containsKey('token')) {
        return '/shared';
      }
    }
    return '/login';
  }

  Widget _buildSharedRoute(BuildContext context, RouteSettings? settings) {
    String? token;
    
    // Try to get token from route arguments
    final args = settings?.arguments as Map<String, dynamic>?;
    token = args?['token'] as String?;
    
    // For web, try to get from URL query parameters or path
    if (token == null && kIsWeb) {
      final uri = Uri.base;
      token = uri.queryParameters['token'];
      print('Extracted token from URL query: ${token != null ? token.substring(0, 8) + "..." : "null"}');
      
      // Also check if token is in the path (e.g., /shared/abc123)
      if (token == null && uri.pathSegments.length > 1 && uri.pathSegments[0] == 'shared') {
        token = uri.pathSegments[1];
        print('Extracted token from URL path: ${token.substring(0, 8)}...');
      }
    }
    
    if (token == null || token.isEmpty) {
      print('No token found in shared route');
      // No token found, show error but don't require login
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Invalid share link', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Open shared document without requiring auth
    print('Creating EditorPage with token: ${token.substring(0, 8)}...');
    return EditorPage(shareToken: token);
  }
}

// ==================== PAGE MODEL ====================
class DocumentPage {
  final String id;
  final TextEditingController controller;
  final FocusNode focusNode;
  
  DocumentPage({String? id}) 
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      controller = TextEditingController(),
      focusNode = FocusNode();
  
  String get content => controller.text;
  set content(String value) => controller.text = value;
  
  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
  
  Map<String, dynamic> toJson() => {'id': id, 'content': content};
  factory DocumentPage.fromJson(Map<String, dynamic> json) {
    final page = DocumentPage(id: json['id']?.toString());
    page.content = json['content'] ?? '';
    return page;
  }
}

// ==================== EDITOR PAGE ====================
class EditorPage extends StatefulWidget {
  final String? documentId;
  final String? shareToken;
  const EditorPage({super.key, this.documentId, this.shareToken});
  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  String? _currentDocId;
  String? _shareToken; // Store share token in state
  Timer? _autoSaveTimer;
  bool _isSaving = false;
  bool _isLoading = false;
  final _titleController = TextEditingController(text: 'Untitled document');
  List<DocumentPage> _pages = [DocumentPage()];
  final _scrollController = ScrollController();
  String _selectedFont = 'Arial';
  double _fontSize = 16;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  TextAlign _textAlign = TextAlign.left;
  bool _showOutline = true;
  OverlayEntry? _currentOverlay;
  List<DocumentSection> _documentSections = [];
  int _currentPageIndex = 0;
  
  // Undo/Redo history
  List<Map<String, dynamic>> _undoHistory = [];
  List<Map<String, dynamic>> _redoHistory = [];
  bool _isUndoRedoOperation = false;
  Timer? _historySaveTimer;
  
  // User profile
  String? _userName;
  String? _userEmail;
  
  // Page dimensions
  static const double _maxPageWidth = 816;
  static const double _minPageWidth = 300;
  static const double _pageHeight = 1056; // A4 height at 72 DPI

  @override
  void initState() {
    super.initState();
    // Store share token from widget immediately in initState
    _shareToken = widget.shareToken;
    if (_shareToken != null) {
      print('EditorPage initialized with shareToken: ${_shareToken!.substring(0, 8)}...');
    } else {
      print('EditorPage initialized without shareToken');
    }
    _pages[0].controller.addListener(_updateDocumentOutline);
    _pages[0].controller.addListener(_checkPageBreak);
    _pages[0].controller.addListener(_onContentChanged);
    _titleController.addListener(_updateTabsManager);
    _titleController.addListener(_onContentChanged);
    _updateDocumentOutline();
    _loadDocument();
    _loadUserProfile();

    // Auto-save every 5 seconds (increased from 3 to reduce API calls)
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_isSaving && (_currentDocId != null || (_titleController.text.isNotEmpty || _getAllContent().isNotEmpty))) {
        _saveDocument();
      }
    });
  }
  
  // Track content changes for undo/redo
  void _onContentChanged() {
    if (_isUndoRedoOperation) return;
    
    // Debounce history saves to avoid saving on every keystroke
    _historySaveTimer?.cancel();
    _historySaveTimer = Timer(const Duration(milliseconds: 500), () {
      _saveStateToHistory();
    });
  }
  
  String _getAllContent() {
    return _pages.map((p) => p.content).join('\n\n');
  }
  
  // Save current state to history
  void _saveStateToHistory() {
    if (_isUndoRedoOperation) return;
    
    final state = {
      'pages': _pages.map((p) => {'id': p.id, 'content': p.content}).toList(),
      'currentPageIndex': _currentPageIndex,
      'title': _titleController.text,
    };
    
    _undoHistory.add(state);
    // Limit history size to prevent memory issues
    if (_undoHistory.length > 50) {
      _undoHistory.removeAt(0);
    }
    // Clear redo history when new action is performed
    _redoHistory.clear();
  }
  
  // Restore state from history
  void _restoreStateFromHistory(Map<String, dynamic> state) {
    _isUndoRedoOperation = true;
    
    try {
      // Update title
      _titleController.text = state['title'] ?? 'Untitled document';
      
      // Rebuild pages from state
      final pagesData = state['pages'] as List<dynamic>;
      final newPages = <DocumentPage>[];
      
      for (var pageData in pagesData) {
        final page = DocumentPage(id: pageData['id']?.toString());
        page.content = pageData['content'] ?? '';
        page.controller.addListener(_updateDocumentOutline);
        page.controller.addListener(_checkPageBreak);
        newPages.add(page);
      }
      
      // Dispose old pages
      for (var page in _pages) {
        page.controller.removeListener(_updateDocumentOutline);
        page.controller.removeListener(_checkPageBreak);
        page.dispose();
      }
      
      setState(() {
        _pages = newPages;
        _currentPageIndex = state['currentPageIndex'] ?? 0;
        if (_currentPageIndex >= _pages.length) {
          _currentPageIndex = _pages.length - 1;
        }
      });
      
      // Update outline after state restoration
      _updateDocumentOutline();
    } finally {
      _isUndoRedoOperation = false;
    }
  }
  
  // Undo operation
  void _undo() {
    if (_undoHistory.isEmpty) return;
    
    // Save current state to redo history
    final currentState = {
      'pages': _pages.map((p) => {'id': p.id, 'content': p.content}).toList(),
      'currentPageIndex': _currentPageIndex,
      'title': _titleController.text,
    };
    _redoHistory.add(currentState);
    
    // Restore previous state
    final previousState = _undoHistory.removeLast();
    _restoreStateFromHistory(previousState);
  }
  
  // Redo operation
  void _redo() {
    if (_redoHistory.isEmpty) return;
    
    // Save current state to undo history
    final currentState = {
      'pages': _pages.map((p) => {'id': p.id, 'content': p.content}).toList(),
      'currentPageIndex': _currentPageIndex,
      'title': _titleController.text,
    };
    _undoHistory.add(currentState);
    
    // Restore next state
    final nextState = _redoHistory.removeLast();
    _restoreStateFromHistory(nextState);
  }
  
  // Check if undo is available
  bool _canUndo() => _undoHistory.isNotEmpty;
  
  // Check if redo is available
  bool _canRedo() => _redoHistory.isNotEmpty;
  
  void _checkPageBreak() {
    if (_pages.isEmpty) return;
    final currentPage = _pages[_currentPageIndex];
    final text = currentPage.content;
    
    // Calculate approximate lines based on font size and page height
    final lineHeight = _fontSize * 1.5;
    final availableHeight = _pageHeight - 192; // Subtract padding
    final maxLines = (availableHeight / lineHeight).floor();
    
    // Count lines in current page
    final lines = text.split('\n');
    int totalLines = 0;
    for (var line in lines) {
      if (line.isEmpty) {
        totalLines++;
      } else {
        // Estimate wrapped lines (assuming ~80 chars per line for average)
        final estimatedWrappedLines = (line.length / 80).ceil();
        totalLines += estimatedWrappedLines;
      }
    }
    
    // If content exceeds page, create new page
    if (totalLines > maxLines && _currentPageIndex == _pages.length - 1) {
      _addPage();
    }
  }
  
  void _addPage({int? insertIndex}) {
    _saveStateToHistory(); // Save state before adding page
    setState(() {
      final newPage = DocumentPage();
      newPage.controller.addListener(_updateDocumentOutline);
      newPage.controller.addListener(_checkPageBreak);
      newPage.controller.addListener(_onContentChanged);
      if (insertIndex != null) {
        _pages.insert(insertIndex, newPage);
        _currentPageIndex = insertIndex;
      } else {
        _pages.add(newPage);
        _currentPageIndex = _pages.length - 1;
      }
      // Focus on new page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        newPage.focusNode.requestFocus();
      });
    });
  }

  void _updateTabsManager() {
    if (!mounted) return;
    final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
    final allContent = _getAllContent();
    
    // Only update if we have an active document in tabs, otherwise add it
    if (tabsManager.activeDocument != null) {
      tabsManager.updateActiveDocument(
        title: _titleController.text,
        content: allContent,
        documentId: _currentDocId,
        isUnsaved: _currentDocId == null,
      );
    } else {
      // Add new document to tabs if not already there
      tabsManager.addDocument(OpenDocument(
        documentId: _currentDocId,
        title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
        content: allContent,
        isUnsaved: _currentDocId == null,
      ));
    }
  }

  Future<void> _loadDocument() async {
    if (widget.shareToken != null || _shareToken != null) {
      // Load shared document
      // Ensure shareToken is set (use widget.shareToken as fallback)
      if (_shareToken == null && widget.shareToken != null) {
        _shareToken = widget.shareToken;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final tokenToUse = _shareToken ?? widget.shareToken;
        if (tokenToUse == null) return;
        final data = await ApiConfig.getSharedDocument(tokenToUse);
        if (data != null && mounted) {
          _currentDocId = data['document']['id'].toString();
          _titleController.text = data['document']['title'] ?? 'Untitled';
          _loadPagesFromContent(data['document']['content'] ?? '');
          _updateDocumentOutline();
          // Add to tabs manager
          final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
          tabsManager.addDocument(OpenDocument(
            documentId: _currentDocId,
            title: _titleController.text,
            content: _getAllContent(),
            shareToken: _shareToken ?? widget.shareToken,
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load shared document: ${e.toString().replaceFirst('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (widget.documentId != null) {
      // Load existing document
      setState(() => _isLoading = true);
      try {
        final doc = await ApiConfig.getDocument(widget.documentId!);
        if (mounted) {
          _currentDocId = doc['id'].toString();
          _titleController.text = doc['title'] ?? 'Untitled';
          _loadPagesFromContent(doc['content'] ?? '');
          _updateDocumentOutline();
          // Add to tabs manager
          final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
          tabsManager.addDocument(OpenDocument(
            documentId: _currentDocId,
            title: _titleController.text,
            content: _getAllContent(),
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load document: ${e.toString().replaceFirst('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      // New document - add to tabs after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
          // Only add if not already in tabs
          final exists = tabsManager.openDocuments.any(
            (doc) => doc.documentId == null && doc.title == _titleController.text,
          );
          if (!exists) {
            tabsManager.addDocument(OpenDocument(
              documentId: null,
              title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
              content: _getAllContent(),
              isUnsaved: true,
            ));
          }
        }
      });
    }
  }
  
  Future<void> _loadUserProfile() async {
    if (!ApiConfig.isAuthenticated) {
      return;
    }

    try {
      final profile = await ApiConfig.currentUser();
      if (!mounted) return;

      setState(() {
        _userName = profile['name'];
        _userEmail = profile['email'];
      });
    } catch (e) {
      // Silently fail - user profile is not critical for document editing
      if (mounted && e.toString().toLowerCase().contains('unauthorized')) {
        // If unauthorized, redirect to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
  
  String get _userInitial {
    if ((_userName ?? '').isNotEmpty) {
      return _userName!.trim()[0].toUpperCase();
    }
    if ((_userEmail ?? '').isNotEmpty) {
      return _userEmail!.trim()[0].toUpperCase();
    }
    return 'U';
  }
  
  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    if (diff.inHours > 0) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return 'Just now';
  }

  void _loadPagesFromContent(String content) {
    // Dispose existing pages
    for (var page in _pages) {
      page.controller.removeListener(_updateDocumentOutline);
      page.controller.removeListener(_checkPageBreak);
      page.controller.removeListener(_onContentChanged);
      page.dispose();
    }
    
    // Clear history when loading new document
    _undoHistory.clear();
    _redoHistory.clear();
    
    // Try to load as JSON (new format with pages)
    try {
      final json = jsonDecode(content);
      if (json is Map && json.containsKey('pages') && json['pages'] is List) {
        _pages = (json['pages'] as List)
            .map((p) => DocumentPage.fromJson(p as Map<String, dynamic>))
            .toList();
        if (_pages.isEmpty) {
          _pages = [DocumentPage()];
        }
      } else {
        // Legacy format - single content string
        _pages = [DocumentPage()];
        _pages[0].content = content;
      }
    } catch (e) {
      // Not JSON, treat as plain text (legacy format)
      _pages = [DocumentPage()];
      _pages[0].content = content;
    }
    
    // Add listeners to all pages
    for (var page in _pages) {
      page.controller.addListener(_updateDocumentOutline);
      page.controller.addListener(_checkPageBreak);
      page.controller.addListener(_onContentChanged);
    }
    
    _currentPageIndex = 0;
    
    // Save initial state after loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _saveStateToHistory();
      }
    });
  }

  Future<void> _saveDocument() async {
    if (_isSaving) return; // Prevent multiple saves at once

    setState(() => _isSaving = true);

    try {
      // Serialize pages to JSON
      final pagesJson = jsonEncode({
        'pages': _pages.map((p) => p.toJson()).toList(),
        'version': 1, // Version for future compatibility
      });
      
      if (_currentDocId == null) {
        // Create new document
        final result = await ApiConfig.createDocument(
          _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
          pagesJson,
        );
        if (mounted) {
          setState(() => _currentDocId = result['id'].toString());
          // Update tabs manager
          final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
          tabsManager.updateActiveDocument(documentId: _currentDocId);
        }
      } else {
        // Update existing document
        // Use shareToken from state or widget
        final shareTokenToUse = _shareToken ?? widget.shareToken;
        print('Saving document ${_currentDocId} with shareToken: $shareTokenToUse'); // Debug
        await ApiConfig.saveDocument(
          _currentDocId!,
          _titleController.text,
          pagesJson,
          shareToken: shareTokenToUse, // Pass share token if available
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _updateDocumentOutline() {
    final allText = _getAllContent();
    final lines = allText.split('\n');
    List<DocumentSection> sections = [];
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty &&
          (line.endsWith(':') ||
              (line.length < 50 && line.length > 3 && !line.contains('.')))) {
        sections.add(DocumentSection(title: line, lineNumber: i + 1));
      }
    }
    setState(() => _documentSections = sections);
  }

  Future<void> _handleSignOut() async {
    await ApiConfig.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showDownloadFormatDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor ?? colorScheme.surface,
        title: Text(
          'Download Document',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose a format:',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildFormatOption(
              context,
              Icons.description,
              'Plain Text',
              '.txt',
              DocumentFormat.txt,
            ),
            const SizedBox(height: 12),
            _buildFormatOption(
              context,
              Icons.picture_as_pdf,
              'PDF Document',
              '.pdf',
              DocumentFormat.pdf,
            ),
            const SizedBox(height: 12),
            _buildFormatOption(
              context,
              Icons.description_outlined,
              'Microsoft Word',
              '.docx',
              DocumentFormat.docx,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(
    BuildContext context,
    IconData icon,
    String label,
    String extension,
    DocumentFormat format,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _downloadDocument(format);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    extension,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadDocument(DocumentFormat format) async {
    try {
      Map<String, dynamic> doc;
      String title;
      String content;
      
      if (_currentDocId != null) {
        doc = await ApiConfig.getDocument(_currentDocId!);
        title = doc['title'] ?? 'Untitled';
        final rawContent = doc['content'] ?? '';
        // Try to parse as JSON (pages format), otherwise use as-is
        try {
          final json = jsonDecode(rawContent);
          if (json is Map && json.containsKey('pages') && json['pages'] is List) {
            content = (json['pages'] as List)
                .map((p) => (p as Map<String, dynamic>)['content'] ?? '')
                .join('\n\n');
          } else {
            content = rawContent;
          }
        } catch (e) {
          content = rawContent;
        }
      } else {
        // Use current content if no document ID
        title = _titleController.text.isEmpty ? 'Untitled' : _titleController.text;
        content = _getAllContent();
      }

      final sanitizedTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '_').replaceAll(' ', '_');
      String fileName;
      String mimeType;
      Uint8List fileBytes;

      // Generate file based on format
      switch (format) {
        case DocumentFormat.txt:
          fileName = '$sanitizedTitle.txt';
          mimeType = 'text/plain';
          final text = '$title\n\n$content';
          fileBytes = Uint8List.fromList(text.codeUnits);
          break;
        case DocumentFormat.pdf:
          fileName = '$sanitizedTitle.pdf';
          mimeType = 'application/pdf';
          fileBytes = await generatePDF(title, content);
          break;
        case DocumentFormat.docx:
          fileName = '$sanitizedTitle.docx';
          mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          fileBytes = await generateDOCX(title, content);
          break;
      }
      
      if (kIsWeb) {
        // Web download - trigger actual file download
        try {
          await downloadFileBytes(fileBytes, fileName, mimeType);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Document downloaded: $fileName'),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to download: ${e.toString()}'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      } else {
        // Mobile (Android/iOS) and Desktop download using file_picker
        try {
          // Use file_picker to let user choose where to save
          String? outputFile = await FilePicker.platform.saveFile(
            dialogTitle: 'Save Document',
            fileName: fileName,
            type: format == DocumentFormat.pdf 
                ? FileType.custom 
                : format == DocumentFormat.docx 
                    ? FileType.custom 
                    : FileType.any,
            allowedExtensions: format == DocumentFormat.pdf 
                ? ['pdf'] 
                : format == DocumentFormat.docx 
                    ? ['docx'] 
                    : null,
          );
          
          if (outputFile != null) {
            final file = File(outputFile);
            await file.writeAsBytes(fileBytes);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Document saved: ${file.path.split('/').last}'),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          } else {
            // User cancelled
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download cancelled'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        } catch (e) {
          // Fallback: try to save to downloads directory
          try {
            Directory? directory;
            String savePath;
            
            try {
              directory = await getDownloadsDirectory();
              if (directory == null) {
                directory = await getExternalStorageDirectory();
                if (directory == null) {
                  directory = await getApplicationDocumentsDirectory();
                }
              }
              savePath = '${directory.path}/$fileName';
            } catch (e2) {
              directory = await getApplicationDocumentsDirectory();
              savePath = '${directory.path}/$fileName';
            }
            
            final file = File(savePath);
            await file.writeAsBytes(fileBytes);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Document saved to: ${file.path}'),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          } catch (e2) {
            // Final fallback to clipboard if file save fails (only for text)
            if (format == DocumentFormat.txt) {
              try {
                final text = '$title\n\n$content';
                await Clipboard.setData(ClipboardData(text: text));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to save file. Content copied to clipboard.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (clipboardError) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to download: ${e2.toString()}'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to download: ${e2.toString()}'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _showOpenDocumentDialog() async {
    // Show dialog to choose between BockDocs account or device
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Open Document', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context, 'bockdocs'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.cloud_rounded, color: Color(0xFF7C3AED), size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BockDocs Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Open from your saved documents', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.pop(context, 'device'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.folder_rounded, color: Color(0xFF10B981), size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Device Files', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Open from your device (Desktop, Mac, Android, iOS)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
        ],
      ),
    );

    if (choice == null) return;

    if (choice == 'bockdocs') {
      // Open from BockDocs account - navigate to home page or show document picker
      _showBockDocsDocumentPicker();
    } else if (choice == 'device') {
      // Open from device
      await _openDocumentFromDevice();
    }
  }

  Future<void> _showBockDocsDocumentPicker() async {
    try {
      setState(() => _isLoading = true);
      final docs = await ApiConfig.getUserDocuments();
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No documents found in your account'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show document picker dialog
      final selectedDoc = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: const Color(0xFF1E293B),
          child: Container(
            width: 600,
            height: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Document',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return InkWell(
                        onTap: () => Navigator.pop(context, doc),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.description_rounded, color: Color(0xFF7C3AED), size: 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc['title'] ?? 'Untitled',
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Modified ${_formatTimeAgo(DateTime.tryParse(doc['lastModified'] ?? doc['updatedAt'] ?? doc['createdAt']) ?? DateTime.now())}',
                                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (selectedDoc != null && mounted) {
        // Open the selected document
        final docId = selectedDoc['id'].toString();
        Navigator.pushNamed(
          context,
          '/editor',
          arguments: {'documentId': docId},
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load documents: ${e.toString().replaceFirst('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _openDocumentFromDevice() async {
    try {
      setState(() => _isLoading = true);
      
      final fileResult = await FileHandler.pickAndReadFile();
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (fileResult == null) {
        // User cancelled file picker
        return;
      }

      // Load the file content into the editor
      setState(() {
        _currentDocId = null; // New document from file
        _titleController.text = fileResult.title;
        _loadPagesFromContent(fileResult.content);
        _updateDocumentOutline();
      });

      // Add to tabs manager
      final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
      tabsManager.addDocument(OpenDocument(
        documentId: null,
        title: fileResult.title,
        content: fileResult.content,
        isUnsaved: true,
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opened: ${fileResult.name}'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open file: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showRenameDialogInEditor() {
    final controller = TextEditingController(text: _titleController.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Rename Document', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8)))),
          ElevatedButton(
            onPressed: () async {
              if (_currentDocId != null && controller.text.trim().isNotEmpty) {
                try {
                  // Serialize pages to JSON
                  final pagesJson = jsonEncode({
                    'pages': _pages.map((p) => p.toJson()).toList(),
                    'version': 1,
                  });
                  await ApiConfig.saveDocument(_currentDocId!, controller.text.trim(), pagesJson);
                  if (mounted) {
                    setState(() => _titleController.text = controller.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Document renamed'),
                        backgroundColor: Color(0xFF10B981),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to rename: ${e.toString().replaceFirst('Exception: ', '')}'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
            child: const Text('Rename', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  double _getPageWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final sidebarWidth = (_showOutline && !isMobile) ? 280 : 0;
    final padding = isMobile ? 16 : 64;
    final availableWidth = screenWidth - sidebarWidth - padding;
    // Responsive width: scale between min and max based on available space
    if (availableWidth < _minPageWidth) {
      return availableWidth > 0 ? availableWidth : _minPageWidth;
    } else if (availableWidth > _maxPageWidth) {
      return _maxPageWidth;
    } else {
      return availableWidth;
    }
  }
  
  Widget _buildPagesView() {
    final pageWidth = _getPageWidth(context);
    
    return Column(
      children: [
        for (int i = 0; i < _pages.length; i++) ...[
          _buildPageWidget(_pages[i], i, pageWidth),
          if (i < _pages.length - 1) // Add page break between pages
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: pageWidth,
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
            ),
        ],
        // Add page button at the end
        Container(
          margin: const EdgeInsets.only(top: 24),
          child: ElevatedButton.icon(
            onPressed: () => _addPage(),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Add Page'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPageWidget(DocumentPage page, int index, double width) {
    return Container(
      width: width,
      height: _pageHeight,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Page header with page number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${index + 1}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_pages.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                    onPressed: () {
                      if (_pages.length > 1) {
                        setState(() {
                          final removedPage = _pages[index];
                          removedPage.controller.removeListener(_updateDocumentOutline);
                          removedPage.controller.removeListener(_checkPageBreak);
                          removedPage.dispose();
                          _pages.removeAt(index);
                          if (_currentPageIndex >= _pages.length) {
                            _currentPageIndex = _pages.length - 1;
                          }
                        });
                      }
                    },
                    tooltip: 'Delete page',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          // Page content
          Expanded(
            child: TextField(
              controller: page.controller,
              focusNode: page.focusNode,
              maxLines: null,
              onTap: () => setState(() => _currentPageIndex = index),
              style: TextStyle(
                color: Colors.black,
                fontSize: _fontSize,
                fontWeight: _isBold
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontStyle: _isItalic
                    ? FontStyle.italic
                    : FontStyle.normal,
                decoration: _isUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: _isUnderline ? Colors.black : null,
                decorationThickness: _isUnderline ? 1.0 : null,
                height: 1.5,
                fontFamily: _selectedFont,
              ),
              textAlign: _textAlign,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(96),
                border: InputBorder.none,
                hintText: index == 0 ? 'Start typing...' : '',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(111),
        child: SafeArea(
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor ?? colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(
              children: [
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
                        onPressed: () {
                          // Navigate back to home page
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          style: TextStyle(
                            color: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      if (_isSaving)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                      else
                        IconButton(
                          icon: Icon(
                            _currentDocId != null ? Icons.save : Icons.save_outlined,
                            color: _currentDocId != null ? const Color(0xFF10B981) : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface).withOpacity(0.6),
                          ),
                          onPressed: _currentDocId != null ? () async {
                            await _saveDocument();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Document saved'),
                                  backgroundColor: Color(0xFF10B981),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          } : null,
                          tooltip: _currentDocId != null ? 'Save document' : 'Save after creating document',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (_currentDocId != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: IconButton(
                            onPressed: () => _showShareDialog(
                              context,
                              _currentDocId!,
                            ),
                            icon: const Icon(Icons.share, size: 20),
                            tooltip: 'Share',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      // Theme toggle button
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) => IconButton(
                          icon: Icon(
                            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
                            size: 20,
                          ),
                          tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                          onPressed: () => themeProvider.toggleTheme(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      PopupMenuButton(
                        icon: CircleAvatar(
                          radius: 16,
                          backgroundColor: colorScheme.primary,
                          child: Text(
                            _userInitial,
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.settings_rounded,
                                  color: Color(0xFF94A3B8),
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text('Settings'),
                              ],
                            ),
                            onTap: () => Future.delayed(
                              Duration.zero,
                              () => Navigator.pushNamed(context, '/settings'),
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.red, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            onTap: () => Future.delayed(
                              Duration.zero,
                              () => _handleSignOut(),
                            ),
                          ),
                        ],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMenuButton('File', _showFileMenu),
                        _buildMenuButton('Edit', _showEditMenu),
                        _buildMenuButton('View', _showViewMenu),
                        _buildMenuButton('Insert', _showInsertMenu),
                        _buildMenuButton('Format', _showFormatMenu),
                        _buildMenuButton('Tools', _showToolsMenu),
                        _buildMenuButton('Help', _showHelpMenu),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
        children: [
          _buildDocumentTabsBar(),
          _buildToolbar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: theme.scaffoldBackgroundColor,
                        child: Center(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 16 : 32,
                              horizontal: isMobile ? 8 : 0,
                            ),
                            child: _buildPagesView(),
                          ),
                        ),
                      ),
                    ),
                    if (_showOutline && !isMobile) _buildOutlineSidebar(),
                  ],
                );
              },
            ),
          ),
        ],
        ),
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          if (isMobile) {
            // On mobile, show FAB to toggle outline drawer
            return FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1E293B),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildOutlineSidebar(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF7C3AED),
              child: const Icon(Icons.list_alt, color: Colors.white),
            );
          } else {
            if (!_showOutline) {
              return FloatingActionButton(
                onPressed: () => setState(() => _showOutline = true),
                backgroundColor: const Color(0xFF7C3AED),
                child: const Icon(Icons.list_alt, color: Colors.white),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

  Widget _buildDocumentTabsBar() {
    return Consumer<DocumentTabsManager>(
      builder: (context, tabsManager, _) {
        // Show tabs bar if there are any open documents
        if (tabsManager.tabCount == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 40,
          color: const Color(0xFF1E293B),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabsManager.tabCount,
            itemBuilder: (context, index) {
              final doc = tabsManager.openDocuments[index];
              final isActive = index == tabsManager.activeTabIndex;
              
              return GestureDetector(
                onTap: () {
                  tabsManager.switchToTab(index);
                  final activeDoc = tabsManager.activeDocument;
                  if (activeDoc != null) {
                    _loadDocumentFromTab(activeDoc);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF0F172A) : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: isActive ? const Color(0xFF7C3AED) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        doc.title.isEmpty ? 'Untitled' : doc.title,
                        style: TextStyle(
                          color: isActive ? Colors.white : const Color(0xFF94A3B8),
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (doc.isUnsaved) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C3AED),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (tabsManager.tabCount > 1) {
                            tabsManager.closeTab(index);
                            // If we closed the active tab, switch to the new active one
                            if (index == tabsManager.activeTabIndex && tabsManager.tabCount > 0) {
                              final activeDoc = tabsManager.activeDocument;
                              if (activeDoc != null) {
                                // Load the active document
                                _loadDocumentFromTab(activeDoc);
                              }
                            }
                          }
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: isActive ? Colors.white70 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _loadDocumentFromTab(OpenDocument doc) {
    setState(() {
      _currentDocId = doc.documentId;
      _titleController.text = doc.title;
      _loadPagesFromContent(doc.content);
    });
    _updateDocumentOutline();
    
    // If document has an ID, load it from server to get latest version
    if (doc.documentId != null) {
      _loadDocumentById(doc.documentId!);
    }
  }

  Future<void> _loadDocumentById(String docId) async {
    try {
      final doc = await ApiConfig.getDocument(docId);
      if (mounted) {
        setState(() {
          _currentDocId = doc['id'].toString();
          _titleController.text = doc['title'] ?? 'Untitled';
          _loadPagesFromContent(doc['content'] ?? '');
        });
        _updateDocumentOutline();
      }
    } catch (e) {
      // If loading fails, keep the tab content
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load document: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildOutlineSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(left: BorderSide(color: Color(0xFF334155))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                const Icon(Icons.list_alt, color: Color(0xFF7C3AED), size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Document outline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _showOutline = false),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _documentSections.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.article_outlined,
                            color: Color(0xFF64748B),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No tabs yet',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add tabs',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _documentSections.length,
                    itemBuilder: (context, index) {
                      final section = _documentSections[index];
                      return InkWell(
                        onTap: () {
                          if (_pages.isNotEmpty && _currentPageIndex < _pages.length) {
                            _pages[_currentPageIndex].focusNode.requestFocus();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  section.title,
                                  style: const TextStyle(
                                    color: Color(0xFFE2E8F0),
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, String docId) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        // Use StatefulBuilder for state updates
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.share, color: Color(0xFF7C3AED)),
              const SizedBox(width: 12),
              const Text(
                'Share Document',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share with people',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter email address',
                          hintStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(
                            Icons.person_add,
                            color: Color(0xFF7C3AED),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF7C3AED),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isNotEmpty) {
                          // Call backend to share with email
                          final success =
                              await ApiConfig.shareDocumentWithEmail(
                                docId,
                                emailController.text,
                                'view',
                              ); // You can use selectedPermission here

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Shared with ${emailController.text}'
                                      : 'Failed to share with ${emailController.text}',
                                ),
                                backgroundColor: success
                                    ? const Color(0xFF10B981)
                                    : Colors.red,
                              ),
                            );
                          }
                          emailController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'General access',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Anyone with the link can view',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Only people with access can open',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String? link;
                String? errorMessage;
                try {
                  link = await ApiConfig.createShareLink(
                    docId,
                    'view',
                    3600,
                  ); // 1 hour expiry
                  // The backend returns a frontend URL, ensure it uses current origin for web
                  if (link != null) {
                    final uri = Uri.parse(link);
                    // Extract token from query or path
                    final token = uri.queryParameters['token'] ?? uri.pathSegments.last;
                    link = '${Uri.base.origin}/shared?token=$token';
                  }
                } catch (e) {
                  errorMessage = e.toString().replaceFirst('Exception: ', '');
                }

                if (!context.mounted) return;

                Navigator.pop(context);

                if (link != null) {
                  await Clipboard.setData(ClipboardData(text: link));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Link copied to clipboard'),
                        ],
                      ),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage ?? 'Failed to generate share link'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Copy Link',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback? onPressed) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _showFileMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.insert_drive_file,
            text: 'New',
            shortcut: 'Ctrl+N',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/editor');
            },
          ),
          _MenuItem(
            icon: Icons.folder_open,
            text: 'Open',
            shortcut: 'Ctrl+O',
            onTap: () => _showOpenDocumentDialog(),
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.save,
            text: 'Save',
            shortcut: 'Ctrl+S',
            onTap: () async {
              if (_currentDocId != null) {
                await _saveDocument();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document saved'),
                      backgroundColor: Color(0xFF10B981),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
          ),
          _MenuItem(
            icon: Icons.share,
            text: 'Share',
            onTap: () {
              if (_currentDocId != null) {
                _showShareDialog(context, _currentDocId!);
              }
            },
          ),
          _MenuItem(
            icon: Icons.download,
            text: 'Download',
            onTap: () => _showDownloadFormatDialog(),
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.drive_file_rename_outline,
            text: 'Rename',
            onTap: () {
              if (_currentDocId != null) {
                _showRenameDialogInEditor();
              }
            },
          ),
          _MenuItem(
            icon: Icons.delete,
            text: 'Move to trash',
            onTap: () async {
              if (_currentDocId != null) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1E293B),
                    title: const Text('Delete Document', style: TextStyle(color: Colors.white)),
                    content: const Text('Are you sure you want to delete this document?', style: TextStyle(color: Colors.white)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  try {
                    await ApiConfig.deleteDocument(_currentDocId!);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete: ${e.toString().replaceFirst('Exception: ', '')}'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                }
              }
            },
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.print, text: 'Print', shortcut: 'Ctrl+P'),
        ],
      ),
    ],
  );

  void _showEditMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.undo, 
            text: 'Undo', 
            shortcut: 'Ctrl+Z',
            onTap: _canUndo() ? _undo : null,
          ),
          _MenuItem(
            icon: Icons.redo, 
            text: 'Redo', 
            shortcut: 'Ctrl+Y',
            onTap: _canRedo() ? _redo : null,
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.content_cut, text: 'Cut', shortcut: 'Ctrl+X'),
          _MenuItem(icon: Icons.content_copy, text: 'Copy', shortcut: 'Ctrl+C'),
          _MenuItem(
            icon: Icons.content_paste,
            text: 'Paste',
            shortcut: 'Ctrl+V',
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.select_all,
            text: 'Select all',
            shortcut: 'Ctrl+A',
          ),
        ],
      ),
    ],
  );

  void _showViewMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.print, text: 'Print layout', isChecked: true),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.list_alt,
            text: 'Show document outline',
            isChecked: _showOutline,
            onTap: () => setState(() => _showOutline = !_showOutline),
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.fullscreen,
            text: 'Full screen',
            shortcut: 'F11',
          ),
        ],
      ),
    ],
  );

  void _showInsertMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.image, text: 'Image'),
          _MenuItem(icon: Icons.table_chart, text: 'Table'),
          _MenuItem(icon: Icons.insert_chart, text: 'Chart'),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.horizontal_rule, text: 'Horizontal line'),
          _MenuItem(icon: Icons.emoji_emotions, text: 'Emoji'),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.link, text: 'Link', shortcut: 'Ctrl+K'),
          _MenuItem(icon: Icons.bookmark, text: 'Bookmark'),
        ],
      ),
    ],
  );

  void _showFormatMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.format_bold, text: 'Bold', shortcut: 'Ctrl+B'),
          _MenuItem(
            icon: Icons.format_italic,
            text: 'Italic',
            shortcut: 'Ctrl+I',
          ),
          _MenuItem(
            icon: Icons.format_underlined,
            text: 'Underline',
            shortcut: 'Ctrl+U',
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.format_size,
            text: 'Font size',
            hasSubmenu: true,
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.format_align_left,
            text: 'Align & indent',
            hasSubmenu: true,
          ),
          _MenuItem(
            icon: Icons.format_line_spacing,
            text: 'Line spacing',
            hasSubmenu: true,
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.format_clear,
            text: 'Clear formatting',
            shortcut: 'Ctrl+\\',
          ),
        ],
      ),
    ],
  );

  void _showToolsMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.spellcheck, text: 'Spelling and grammar'),
          _MenuItem(icon: Icons.text_fields, text: 'Word count'),
        ],
      ),
      _MenuSection(
        items: [_MenuItem(icon: Icons.translate, text: 'Translate document')],
      ),
      _MenuSection(
        items: [_MenuItem(icon: Icons.book, text: 'Dictionary')],
      ),
    ],
  );

  void _showHelpMenu() => _showDropdownMenu(
    context,
    items: [
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.search,
            text: 'Search the menus',
            shortcut: 'Alt+/',
          ),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(icon: Icons.help, text: 'BockDocs Help'),
          _MenuItem(icon: Icons.school, text: 'Training'),
        ],
      ),
      _MenuSection(
        items: [
          _MenuItem(
            icon: Icons.keyboard,
            text: 'Keyboard shortcuts',
            shortcut: 'Ctrl+/',
          ),
        ],
      ),
    ],
  );

  void _showDropdownMenu(
    BuildContext context, {
    required List<_MenuSection> items,
  }) {
    _currentOverlay?.remove();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    _currentOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _currentOverlay?.remove();
              _currentOverlay = null;
            },
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: position.left + 10,
            top: position.top + 10,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1E293B),
              child: Container(
                width: 280,
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: items
                        .map(
                          (section) => Column(
                            children: [
                              ...section.items.map(
                                (item) => _buildMenuItem(item),
                              ),
                              if (section != items.last)
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFF334155),
                                ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_currentOverlay!);
  }

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      onTap: () {
        _currentOverlay?.remove();
        _currentOverlay = null;
        item.onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (item.isChecked)
              const Icon(Icons.check, size: 18, color: Color(0xFF7C3AED))
            else
              const SizedBox(width: 18),
            const SizedBox(width: 12),
            Icon(item.icon, size: 18, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            if (item.shortcut != null)
              Text(
                item.shortcut!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            if (item.hasSubmenu)
              const Icon(Icons.arrow_right, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.undo, size: 20),
              color: _canUndo() 
                  ? (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface)
                  : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface).withOpacity(0.4),
              onPressed: _canUndo() ? _undo : null,
              tooltip: 'Undo',
            ),
            IconButton(
              icon: const Icon(Icons.redo, size: 20),
              color: _canRedo()
                  ? (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface)
                  : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface).withOpacity(0.4),
              onPressed: _canRedo() ? _redo : null,
              tooltip: 'Redo',
            ),
            IconButton(
              icon: const Icon(Icons.print, size: 20),
              color: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
              onPressed: () {},
              tooltip: 'Print',
            ),
            VerticalDivider(
              width: 20,
              thickness: 1,
              color: theme.dividerColor,
            ),
            IconButton(
              icon: const Icon(Icons.insert_page_break, size: 20),
              color: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
              onPressed: () => _addPage(insertIndex: _currentPageIndex + 1),
              tooltip: 'Insert Page',
            ),
            VerticalDivider(
              width: 20,
              thickness: 1,
              color: theme.dividerColor,
            ),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedFont,
                underline: const SizedBox(),
                dropdownColor: theme.dialogBackgroundColor ?? colorScheme.surface,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 13),
                items: ['Arial', 'Calibri', 'Times New Roman', 'Verdana']
                    .map(
                      (font) =>
                          DropdownMenuItem(value: font, child: Text(font)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedFont = value!),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 36,
              width: 70,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<double>(
                value: _fontSize,
                underline: const SizedBox(),
                dropdownColor: theme.dialogBackgroundColor ?? colorScheme.surface,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 13),
                items: [10, 12, 14, 16, 18, 20, 24, 28, 36]
                    .map(
                      (size) => DropdownMenuItem(
                        value: size.toDouble(),
                        child: Text(size.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _fontSize = value!),
              ),
            ),
            VerticalDivider(
              width: 20,
              thickness: 1,
              color: theme.dividerColor,
            ),
            IconButton(
              icon: const Icon(Icons.format_bold, size: 20),
              color: _isBold ? colorScheme.primary : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
              onPressed: () => setState(() => _isBold = !_isBold),
              tooltip: 'Bold',
            ),
            IconButton(
              icon: const Icon(Icons.format_italic, size: 20),
              color: _isItalic ? colorScheme.primary : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
              onPressed: () => setState(() => _isItalic = !_isItalic),
              tooltip: 'Italic',
            ),
            IconButton(
              icon: const Icon(Icons.format_underlined, size: 20),
              color: _isUnderline ? colorScheme.primary : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
              onPressed: () => setState(() => _isUnderline = !_isUnderline),
              tooltip: 'Underline',
            ),
            VerticalDivider(
              width: 20,
              thickness: 1,
              color: theme.dividerColor,
            ),
            IconButton(
              icon: const Icon(Icons.format_align_left, size: 20),
              color: _textAlign == TextAlign.left
                  ? colorScheme.primary
                  : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
              onPressed: () => setState(() => _textAlign = TextAlign.left),
            ),
            IconButton(
              icon: const Icon(Icons.format_align_center, size: 20),
              color: _textAlign == TextAlign.center
                  ? colorScheme.primary
                  : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
              onPressed: () => setState(() => _textAlign = TextAlign.center),
            ),
            IconButton(
              icon: const Icon(Icons.format_align_right, size: 20),
              color: _textAlign == TextAlign.right
                  ? colorScheme.primary
                  : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
              onPressed: () => setState(() => _textAlign = TextAlign.right),
            ),
            const VerticalDivider(
              width: 20,
              thickness: 1,
              color: Color(0xFF334155),
            ),
            IconButton(
              icon: const Icon(Icons.format_clear, size: 20),
              color: Colors.white,
              onPressed: () => setState(() {
                _isBold = false;
                _isItalic = false;
                _isUnderline = false;
                _fontSize = 16;
                _textAlign = TextAlign.left;
              }),
              tooltip: 'Clear formatting',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _historySaveTimer?.cancel();
    _saveDocument(); // Final save before closing
    _currentOverlay?.remove();
    _titleController.dispose();
    for (var page in _pages) {
      page.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }
}

// ==================== MODELS ====================
class DocumentSection {
  final String title;
  final int lineNumber;
  DocumentSection({required this.title, required this.lineNumber});
}

class _MenuSection {
  final List<_MenuItem> items;
  _MenuSection({required this.items});
}

class _MenuItem {
  final IconData icon;
  final String text;
  final String? shortcut;
  final bool hasSubmenu;
  final bool isChecked;
  final VoidCallback? onTap;
  _MenuItem({
    required this.icon,
    required this.text,
    this.shortcut,
    this.hasSubmenu = false,
    this.isChecked = false,
    this.onTap,
  });
}

void _goBackToBockOne(BuildContext context) {
  final rootNavigator = Navigator.of(context, rootNavigator: true);
  if (rootNavigator.canPop()) {
    rootNavigator.pop();
    return;
  }

  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
  }
}

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Email and password are required');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await ApiConfig.login(email, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      if (kIsWeb) {
        // For web, use a popup-based flow to avoid redirect URI issues
        await _handleGoogleSignInWeb();
      } else {
        // For mobile, use the standard flow
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          // Add clientId for mobile if available
          // clientId: '905403783172-0da236stbhj0ceieaunatkhu91sg6efv.apps.googleusercontent.com',
        );
        
        // Sign out first to ensure clean state
        try {
          await googleSignIn.signOut();
        } catch (e) {
          // Ignore sign out errors
        }
        
        final GoogleSignInAccount? account = await googleSignIn.signIn();
        
        if (account == null) {
          // User cancelled sign-in
          if (mounted) {
            setState(() => _isLoading = false);
          }
          return;
        }

        // Get authentication with retry logic
        GoogleSignInAuthentication auth;
        try {
          auth = await account.authentication;
        } catch (e) {
          // Retry once if authentication fails
          await Future.delayed(const Duration(milliseconds: 500));
          auth = await account.authentication;
        }
        
        if (auth.idToken == null) {
          throw Exception('Failed to get ID token from Google. Please try again.');
        }

        await ApiConfig.googleSignIn(auth.idToken!);
        
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      if (mounted) {
        setState(() {
          String errorMsg = e.toString();
          if (errorMsg.contains('Exception: ')) {
            errorMsg = errorMsg.replaceFirst('Exception: ', '');
          }
          if (errorMsg.contains('PlatformException')) {
            errorMsg = 'Google sign-in failed. Please check your internet connection and try again.';
          }
          _errorMessage = errorMsg;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignInWeb() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['openid', 'email', 'profile'],
      clientId: '905403783172-0da236stbhj0ceieaunatkhu91sg6efv.apps.googleusercontent.com',
    );

    try {
      // Try silent sign-in first (recommended for web)
      GoogleSignInAccount? account = await googleSignIn.signInSilently();
      
      // If silent sign-in fails, use regular sign-in
      if (account == null) {
        account = await googleSignIn.signIn();
        if (account == null) {
          return; // User cancelled
        }
      }

      // Get authentication - try multiple times as ID token might not be immediately available
      GoogleSignInAuthentication auth = await account.authentication;
      
      // If ID token is null, try again with a delay
      int retries = 0;
      while (auth.idToken == null && retries < 3) {
        await Future.delayed(Duration(milliseconds: 500 * (retries + 1)));
        auth = await account.authentication;
        retries++;
      }
      
      // If still no ID token, use access token to get user info and send to backend
      if (auth.idToken == null) {
        if (auth.accessToken == null) {
          throw Exception('Failed to get authentication token from Google');
        }
        
        // Use access token - send to backend which will fetch user info
        // This avoids CORS issues with Google API
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/auth/google-access'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'accessToken': auth.accessToken,
          }),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          ApiConfig.setAuthToken(data['token'], data['user']['id']);
        } else {
          throw Exception(data['error'] ?? 'Failed to sign in with Google');
        }
      } else {
        // We have ID token, use it normally
        await ApiConfig.googleSignIn(auth.idToken!);
      }
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _goBackToBockOne(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF94A3B8)),
                    label: const Text(
                      'Back to Bock One',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C3AED).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'BockDocs',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 56),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF7C3AED),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C3AED),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF7C3AED),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C3AED),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xFF334155))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFF334155))),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    icon: Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.g_mobiledata, size: 24, color: Colors.white);
                      },
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF334155)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== SIGNUP PAGE ====================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Name, email, and password are required');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await ApiConfig.signup(name, email, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C3AED).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'BockDocs',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Create your account',
                  style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 56),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                _buildTextField(
                  _nameController,
                  'Full Name',
                  Icons.person_outline,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  _emailController,
                  'Email address',
                  Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                _buildPasswordField(
                  _passwordController,
                  'Password',
                  _obscurePassword,
                  () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 24),
                _buildPasswordField(
                  _confirmPasswordController,
                  'Confirm Password',
                  _obscureConfirmPassword,
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, color: Color(0xFF7C3AED)),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7C3AED)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Color(0xFF94A3B8),
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
      ),
    );
  }
}

// ==================== FORGOT PASSWORD PAGE ====================
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _resetToken; // For development - token from response

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Email is required';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _isLoading = true;
    });

    try {
      // Get reset token from backend
      final response = await ApiConfig.forgotPassword(email);
      if (!mounted) return;
      
      String? resetToken;
      if (response.containsKey('resetToken')) {
        resetToken = response['resetToken'] as String?;
        _resetToken = resetToken;
      }
      
      // Try to send email via EmailJS (browser-based, no backend config needed)
      if (resetToken != null) {
        final frontendUrl = 'http://localhost:5000'; // Or get from config
        final resetLink = '$frontendUrl/#/reset-password?token=$resetToken';
        
        // Import EmailService at the top of the file
        // final emailSent = await EmailService.sendPasswordResetEmail(
        //   toEmail: email,
        //   resetToken: resetToken,
        //   resetLink: resetLink,
        // );
        
        // For now, we'll just show the token in development
        // Uncomment the EmailService call above after setting up EmailJS
      }
      
      setState(() {
        _successMessage = response['message'] ?? 'Password reset link has been sent to your email.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _successMessage = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C3AED).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your email to receive a password reset link',
                  style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 56),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _successMessage!,
                            style: const TextStyle(color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                          if (_resetToken != null) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Development Mode - Reset Token:',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              _resetToken!,
                              style: const TextStyle(
                                color: Color(0xFF7C3AED),
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/reset-password',
                                  arguments: {'token': _resetToken},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                              ),
                              child: const Text('Reset Password Now'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF7C3AED),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C3AED),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleForgotPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remember your password? ',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== RESET PASSWORD PAGE ====================
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    // Get token from route arguments if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        final token = args['token'] as String?;
        if (token != null) {
          setState(() {
            _tokenController.text = token;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final token = _tokenController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (token.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Token and password are required';
        _successMessage = null;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
        _successMessage = null;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _isLoading = true;
    });

    try {
      await ApiConfig.resetPassword(token, password);
      if (!mounted) return;
      
      setState(() {
        _successMessage = 'Password reset successfully! You can now sign in with your new password.';
      });
      
      // Navigate to login after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _successMessage = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C3AED).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_open_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Set New Password',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your reset token and new password',
                  style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 56),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        _successMessage!,
                        style: const TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                TextField(
                  controller: _tokenController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Reset Token',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.key_rounded,
                      color: Color(0xFF7C3AED),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C3AED),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF7C3AED),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C3AED),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF7C3AED),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF7C3AED),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remember your password? ',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== HOME PAGE ====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarExpanded = false;
  List<Document> documents = [];
  bool _isLoading = true;
  String? _userName;
  String? _userEmail;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    if (!ApiConfig.isAuthenticated) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await ApiConfig.currentUser();
      final docs = await ApiConfig.getUserDocuments();

      if (!mounted) return;

      setState(() {
        _userName = profile['name'];
        _userEmail = profile['email'];
        documents = docs
            .map(
              (doc) => Document(
                id: doc['id'].toString(),
                title: doc['title'] ?? 'Untitled',
                lastModified: DateTime.tryParse(doc['lastModified'] ?? doc['updatedAt'] ?? doc['createdAt']) ?? DateTime.now(),
              ),
            )
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
      if (message.toLowerCase().contains('unauthorized')) {
        Future.microtask(() => _logout());
      }
    }
  }

  String get _userInitial {
    if ((_userName ?? '').isNotEmpty) {
      return _userName!.trim()[0].toUpperCase();
    }
    if ((_userEmail ?? '').isNotEmpty) {
      return _userEmail!.trim()[0].toUpperCase();
    }
    return 'U';
  }

  Future<void> _logout() async {
    await ApiConfig.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSidebarExpanded ? 280 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                border: Border(right: BorderSide(color: Color(0xFF334155))),
              ),
              child: _isSidebarExpanded ? _buildSidebar() : null,
            ),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/editor').then((_) => _loadDocuments()),
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF9333EA)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Text('BockDocs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
            ],
          ),
        ),
        _buildSidebarItem(Icons.folder_rounded, 'BockDrive', true, null),
        _buildSidebarItem(Icons.settings_rounded, 'Settings', false, () => Navigator.pushNamed(context, '/settings').then((_) => _loadDocuments())),
        _buildSidebarItem(Icons.arrow_back_rounded, 'Back to Bock One', false, () => _goBackToBockOne(context)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFF7C3AED),
                child: Text(
                  _userInitial,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _userName ?? 'BockDocs user',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail ?? '—',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isSelected, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C3AED).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF94A3B8), size: 24),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF94A3B8), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), border: Border(bottom: BorderSide(color: Color(0xFF334155)))),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                tooltip: 'Back to Bock One',
                onPressed: () => _goBackToBockOne(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_isSidebarExpanded ? Icons.close : Icons.menu, color: Colors.white, size: 24),
                onPressed: () => setState(() => _isSidebarExpanded = !_isSidebarExpanded),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Color(0xFF334155))),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search documents...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton(
                icon: CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF7C3AED),
                  child: Text(
                    _userInitial,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                color: const Color(0xFF1E293B),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(children: const [Icon(Icons.settings_rounded, color: Color(0xFF94A3B8), size: 20), SizedBox(width: 12), Text('Settings', style: TextStyle(color: Colors.white))]),
                    onTap: () => Future.delayed(Duration.zero, () => Navigator.pushNamed(context, '/settings').then((_) => _loadDocuments())),
                  ),
                    PopupMenuItem(
                      child: Row(children: const [Icon(Icons.logout, color: Colors.red, size: 20), SizedBox(width: 12), Text('Sign Out', style: TextStyle(color: Colors.red))]),
                      onTap: () => Future.delayed(Duration.zero, () => _logout()),
                    ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    final padding = isMobile ? 16.0 : 40.0;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Start a new document', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                              const SizedBox(height: 24),
                              InkWell(
                                onTap: () => Navigator.pushNamed(context, '/editor').then((_) => _loadDocuments()),
                                child: Container(
                                  width: isMobile ? double.infinity : 180,
                                  height: 200,
                                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF7C3AED).withOpacity(0.7)]), borderRadius: BorderRadius.circular(16)),
                                        child: Icon(Icons.add_rounded, size: 48, color: Colors.white),
                                      ),
                                      const SizedBox(height: 20),
                                      Text('Blank Document', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(padding: EdgeInsets.symmetric(horizontal: padding), child: const Divider(color: Color(0xFF334155))),
                        const SizedBox(height: 32),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: const Text('Recent documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                        const SizedBox(height: 24),
                        if (_errorMessage != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        _isLoading
                            ? Center(child: Padding(padding: EdgeInsets.all(padding), child: const CircularProgressIndicator(color: Color(0xFF7C3AED))))
                            : documents.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(padding),
                                      child: Column(
                                        children: const [
                                          Icon(Icons.description_outlined, size: 64, color: Color(0xFF64748B)),
                                          SizedBox(height: 16),
                                          Text('No documents yet', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 18)),
                                          SizedBox(height: 8),
                                          Text('Create your first document to get started', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: padding),
                                    itemCount: documents.length,
                                    itemBuilder: (context, index) => _buildDocumentCard(documents[index], index),
                                  ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(Document doc, int index) {
    return InkWell(
      onTap: () {
        final tabsManager = Provider.of<DocumentTabsManager>(context, listen: false);
        // Check if document is already open
        final existingTab = tabsManager.openDocuments.indexWhere(
          (openDoc) => openDoc.documentId == doc.id,
        );
        if (existingTab != -1) {
          // Switch to existing tab
          tabsManager.switchToTab(existingTab);
          // Navigate to editor if not already there
          Navigator.pushNamed(context, '/editor');
        } else {
          // Open new tab
          Navigator.pushNamed(
            context,
            '/editor',
            arguments: {'documentId': doc.id},
          ).then((_) => _loadDocuments());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.description_rounded, color: Color(0xFF7C3AED), size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.title, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('Opened ${_getTimeAgo(doc.lastModified)}', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(children: const [Icon(Icons.drive_file_rename_outline, color: Color(0xFF94A3B8), size: 20), SizedBox(width: 12), Text('Rename')]),
                  onTap: () => Future.delayed(Duration.zero, () => _showRenameDialog(doc, index)),
                ),
                PopupMenuItem(
                  child: Row(children: const [Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20), SizedBox(width: 12), Text('Remove', style: TextStyle(color: Colors.red))]),
                  onTap: () async {
                    try {
                      final success = await ApiConfig.deleteDocument(doc.id);
                      if (success && mounted) {
                        setState(() => documents.removeAt(index));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document deleted'), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString().replaceFirst('Exception: ', '')),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(Document doc, int index) {
    final controller = TextEditingController(text: doc.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Rename Document', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8)))),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty && controller.text.trim() != doc.title) {
                try {
                  // Get document content first
                  final docData = await ApiConfig.getDocument(doc.id);
                  await ApiConfig.saveDocument(doc.id, controller.text.trim(), docData['content'] ?? '');
                  if (mounted) {
                    setState(() => documents[index].title = controller.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Document renamed'),
                        backgroundColor: Color(0xFF10B981),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to rename: ${e.toString().replaceFirst('Exception: ', '')}'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              } else {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
            child: const Text('Rename', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    if (diff.inHours > 0) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return 'Just now';
  }
}

// Removed duplicate _buildDocumentCard with (BuildContext, Document, int) signature

class Document {
  final String id;
  String title;
  final DateTime lastModified;
  Document({required this.id, required this.title, required this.lastModified});
}

// ==================== SETTINGS PAGE ====================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _statusMessage;
  Color _statusColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (!ApiConfig.isAuthenticated) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final profile = await ApiConfig.currentUser();
      if (!mounted) return;
      setState(() {
        _nameController.text = profile['name'] ?? '';
        _emailController.text = profile['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _statusMessage = message;
        _statusColor = Colors.redAccent;
        _isLoading = false;
      });
      if (message.toLowerCase().contains('unauthorized')) {
        Future.microtask(() => _logout());
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
      _statusMessage = null;
    });

    try {
      await ApiConfig.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Settings updated';
        _statusColor = Colors.green;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings updated'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = e.toString().replaceFirst('Exception: ', '');
        _statusColor = Colors.redAccent;
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    await ApiConfig.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFF7C3AED),
                      child: Text(
                        (_nameController.text.isNotEmpty
                                ? _nameController.text[0]
                                : (_emailController.text.isNotEmpty ? _emailController.text[0] : 'U'))
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_statusMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(color: _statusColor),
                      ),
                    ),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF7C3AED),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF7C3AED),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Divider(color: Color(0xFF334155)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => _logout(),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
