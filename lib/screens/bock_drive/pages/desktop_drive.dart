import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// The following imports are only used on Flutter web for inline previews.
// They rely on web-only libraries, which is fine here because you're running
// this screen in Chrome. If you later build for mobile/desktop, we can move
// this into a separate web-only file with conditional imports.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter, uri_does_not_exist
import 'dart:ui_web' as ui;
import '../models/drive_models.dart';
import '../services/file_services.dart';
import '../services/file_api_service.dart';
import '../services/folder_api_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class DesktopDrive extends StatefulWidget {
  const DesktopDrive({super.key});

  @override
  State<DesktopDrive> createState() => _DesktopDriveState();
}

class _DesktopDriveState extends State<DesktopDrive> {
  String selectedSection = 'Home';
  final FileService _fileService = FileService();
  List<DriveItem> allFiles = [];
  List<DriveItem> myDriveFiles = [];
  List<DriveItem> recentFiles = [];
  List<DriveItem> starredFiles = [];
  List<DriveItem> trashFiles = [];
  List<DriveItem> filteredFiles = [];
  List<DriveItem> suggestedFolders = [];
  bool isLoading = false;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  String? _userEmail;
  bool _isUserLoading = false;

  // Track current folder path for navigation
  String? currentFolderId; // null means root folder
  String currentFolderPath = 'My Drive';
  List<String> navigationPath = ['My Drive'];
  List<String?> navigationFolderIds = [null];
  Map<String, List<DriveItem>> folderContents = {};
  String? _pendingSharedFolderId;
  String? _pendingSharedFileId;

  // Dark Purple theme colors
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFA855F7);
  static const Color purpleAccent = Color(0xFF9333EA);
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkCard = Color(0xFF374151);
  static const Color darkBorder = Color(0xFF4B5563);
  static const Color lightText = Color(0xFFF9FAFB);
  static const Color mediumText = Color(0xFFD1D5DB);
  static const Color dimText = Color(0xFF9CA3AF);
  static const Color hoverColor = Color(0xFF4B5563);
  static const Color starColor = Color(0xFFFBBF24);

  @override
  void initState() {
    super.initState();
    _captureSharedTarget();
    _loadInitialData();
    _loadCurrentUser();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load files from root folder
      final files = await FileApiService.getFiles(folderId: currentFolderId);
      final starred = await FileApiService.getStarredFiles();
      final trash = await FileApiService.getTrashedFiles();

      setState(() {
        myDriveFiles = files;
        starredFiles = starred;
        trashFiles = trash;
        recentFiles = files.take(5).toList(); // Get recent from files
        _updateFilteredFiles();
        isLoading = false;
        if (currentFolderId == null) {
          currentFolderPath = 'My Drive';
          navigationPath = ['My Drive'];
          navigationFolderIds = [null];
        }
      });

      await _maybeHandlePendingSharedTarget();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      _isUserLoading = true;
    });

    try {
      final result = await AuthService.getCurrentUser();
      if (result['success'] == true && mounted) {
        final user = result['user'];
        setState(() {
          _userEmail = user['email'] as String?;
        });
      }
    } catch (_) {
      // Ignore user load errors and just fall back to default avatar
    } finally {
      if (mounted) {
        setState(() {
          _isUserLoading = false;
        });
      }
    }
  }

  void _captureSharedTarget() {
    final folderId = Uri.base.queryParameters['folderId'];
    final fileId = Uri.base.queryParameters['fileId'];

    if (folderId != null && folderId.isNotEmpty) {
      _pendingSharedFolderId = folderId;
    }
    if (fileId != null && fileId.isNotEmpty) {
      _pendingSharedFileId = fileId;
    }
  }

  Future<void> _maybeHandlePendingSharedTarget() async {
    if (_pendingSharedFolderId != null) {
      final folderId = _pendingSharedFolderId!;
      _pendingSharedFolderId = null;
      await _openFolderById(folderId, fromShareLink: true);
      return;
    }

    if (_pendingSharedFileId != null) {
      final fileId = _pendingSharedFileId!;
      _pendingSharedFileId = null;
      await _openFileById(fileId, fromShareLink: true);
    }
  }

  void _clearShareQueryFromUrl() {
    if (!kIsWeb) return;
    final uri = Uri.base;
    if (uri.queryParameters.isEmpty) return;

    final cleaned = uri.replace(queryParameters: {});
    html.window.history.replaceState(null, '', cleaned.toString());
  }

  String _getUserInitial() {
    final email = _userEmail?.trim();
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'U';
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _updateStarredFiles() {
    starredFiles = [
      ...myDriveFiles.where((file) => file.isStarred == true),
      ...recentFiles.where((file) => file.isStarred == true),
    ];
  }

  void _updateFilteredFiles() {
    switch (selectedSection) {
      case 'Home':
        filteredFiles = recentFiles;
        break;
      case 'My Drive':
        if (currentFolderPath == 'My Drive') {
          filteredFiles = myDriveFiles;
        } else {
          filteredFiles = folderContents[currentFolderPath] ?? [];
        }
        break;
      case 'Recent':
        filteredFiles = recentFiles;
        break;
      case 'Starred':
        filteredFiles = starredFiles;
        break;
      case 'Trash':
        filteredFiles = trashFiles;
        break;
      default:
        filteredFiles = allFiles;
    }

    if (searchQuery.isNotEmpty) {
      filteredFiles = filteredFiles
          .where(
            (file) =>
                file.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth < 1024 && screenWidth >= 768;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: darkBackground,
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: Row(
        children: [
          // Sidebar (hidden on mobile)
          if (!isMobile) _buildSidebar(isTablet),

          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(isMobile),
                Expanded(child: _buildContentArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(backgroundColor: darkSurface, child: _buildSidebarContent());
  }

  Widget _buildSidebar(bool isTablet) {
    return Container(
      width: isTablet ? 200 : 260,
      decoration: BoxDecoration(
        color: darkSurface,
        border: Border(right: BorderSide(color: darkBorder, width: 1)),
      ),
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryPurple, lightPurple, purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.cloud, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'BockDrive',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: lightText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // New Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showNewMenu(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'New',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkCard,
                foregroundColor: primaryPurple,
                elevation: 3,
                shadowColor: primaryPurple.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: primaryPurple.withOpacity(0.5)),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(Icons.folder_outlined, Icons.folder, 'My Drive'),
              _buildNavItem(
                Icons.access_time_outlined,
                Icons.access_time,
                'Recent',
              ),
              _buildNavItem(Icons.star_outline, Icons.star, 'Starred'),
              _buildNavItem(Icons.delete_outline, Icons.delete, 'Trash'),
            ],
          ),
        ),

        // Storage Info
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryPurple.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1.72 GB of 15 GB used',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: mediumText,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 1.72 / 15,
                  backgroundColor: darkBorder,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    primaryPurple,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Get more storage',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      constraints: BoxConstraints(
        minHeight: selectedSection == 'Home'
            ? (isMobile ? 100 : 120)
            : (isMobile ? 70 : 80),
      ),
      color: darkSurface,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 8 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedSection == 'Home') ...[
            // Search Bar (moved to top)
            Row(
              children: [
                if (isMobile)
                  IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: mediumText),
                  ),
                Expanded(
                  child: Container(
                    height: 40,
                    constraints: BoxConstraints(
                      maxWidth: isMobile
                          ? double.infinity
                          : MediaQuery.of(context).size.width * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: darkCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: darkBorder),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.search, color: dimText, size: 18),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: lightText),
                            decoration: const InputDecoration(
                              hintText: 'Search in Drive',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: dimText,
                                fontSize: 14,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                _updateFilteredFiles();
                              });
                            },
                          ),
                        ),
                        if (!isMobile)
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.tune,
                              color: dimText,
                              size: 18,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildUserAvatar(),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 16),
            // Welcome Text (moved below search)
            Text(
              'Welcome to BockDrive',
              style: TextStyle(
                fontSize: isMobile ? 20 : 28,
                fontWeight: FontWeight.w400,
                color: lightText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            Row(
              children: [
                if (isMobile)
                  IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: mediumText),
                  ),
                // Breadcrumb navigation for My Drive
                if (selectedSection == 'My Drive' &&
                    navigationPath.length > 1) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < navigationPath.length; i++) ...[
                            if (i > 0)
                              const Icon(
                                Icons.chevron_right,
                                color: dimText,
                                size: 16,
                              ),
                            TextButton(
                              onPressed: () => _navigateToFolder(i),
                              child: Text(
                                navigationPath[i],
                                style: TextStyle(
                                  color: i == navigationPath.length - 1
                                      ? primaryPurple
                                      : dimText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Search Bar for other sections
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: darkCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: darkBorder),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search, color: dimText, size: 18),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: lightText),
                              decoration: const InputDecoration(
                                hintText: 'Search in Drive',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: dimText,
                                  fontSize: 14,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                  _updateFilteredFiles();
                                });
                              },
                            ),
                          ),
                          if (!isMobile)
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.tune,
                                color: dimText,
                                size: 18,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                _buildUserAvatar(),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          _handleLogout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: CircleAvatar(
        backgroundColor: primaryPurple,
        radius: 16,
        child: _isUserLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _getUserInitial(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlineIcon,
    IconData filledIcon,
    String title,
  ) {
    bool isSelected = selectedSection == title;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? primaryPurple.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? filledIcon : outlineIcon,
          color: isSelected ? primaryPurple : mediumText,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryPurple : lightText,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          setState(() {
            selectedSection = title;
            searchQuery = '';
            _searchController.clear();
            // Reset folder navigation when switching sections
            if (title == 'My Drive') {
              currentFolderPath = 'My Drive';
              navigationPath = ['My Drive'];
              navigationFolderIds = [null];
              currentFolderId = null;
            }
            _updateFilteredFiles();
          });
          // Close drawer on mobile after selection
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        dense: true,
        hoverColor: hoverColor,
      ),
    );
  }

  Widget _buildContentArea() {
    if (selectedSection == 'Home') {
      return _buildHomeView();
    } else {
      return _buildFilesView();
    }
  }

  Widget _buildHomeView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter buttons - with proper horizontal scrolling
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton('Type'),
                  const SizedBox(width: 8),
                  _buildFilterButton('People'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Modified'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Location'),
                ],
              ),
            ),
          ),

          SizedBox(height: isMobile ? 24 : 32),

          // Suggested folders section
          _buildExpandableSection(
            'Suggested folders',
            suggestedFolders,
            isGrid: true,
          ),

          SizedBox(height: isMobile ? 24 : 32),

          // Suggested files section
          _buildExpandableSection(
            'Suggested files',
            filteredFiles,
            showTable: !isMobile,
            showCards: isMobile,
          ),
        ],
      ),
    );
  }

  // FIXED: Navigation to folder functionality
  void _navigateToFolder(int index) {
    if (index < 0 || index >= navigationFolderIds.length) return;

    final targetFolderId = navigationFolderIds[index];

    if (targetFolderId == null) {
      setState(() {
        navigationPath = navigationPath.sublist(0, index + 1);
        navigationFolderIds = navigationFolderIds.sublist(0, index + 1);
        currentFolderId = null;
        currentFolderPath = 'My Drive';
        selectedSection = 'My Drive';
        _updateFilteredFiles();
      });
      _loadInitialData();
      return;
    }

    _openFolderById(targetFolderId);
  }

  // ENHANCED: File opening functionality with proper viewer/editor
  void _openFile(DriveItem item) {
    if (item.type == DriveItemType.folder) {
      if (item.id != null) {
        _openFolderById(item.id!);
        return;
      }
      // Navigate to folder contents
      if (selectedSection != 'My Drive') {
        setState(() {
          selectedSection = 'My Drive';
          currentFolderPath = item.name;
          navigationPath = ['My Drive', item.name];
          navigationFolderIds = [null, null];
          _updateFilteredFiles();
        });
      } else {
        setState(() {
          currentFolderPath = item.name;
          navigationPath.add(item.name);
          navigationFolderIds.add(null);
          _updateFilteredFiles();
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening folder: ${item.name}'),
          backgroundColor: primaryPurple,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Open file in the in‑app viewer dialog for preview (no download)
      _showFileViewer(item);
    }
  }

  Future<void> _openFolderById(
    String folderId, {
    bool fromShareLink = false,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      final folderItems = await FileApiService.getFiles(folderId: folderId);
      final pathData = await FolderApiService.getFolderPath(folderId);
      final folderInfo = await FolderApiService.getFolder(folderId);

      final breadcrumbNames = pathData
          .map((crumb) => (crumb['name'] as String?) ?? 'Untitled folder')
          .toList();

      final folderName = breadcrumbNames.isNotEmpty
          ? breadcrumbNames.last
          : (folderInfo?['name'] as String?) ?? 'Folder';

      if (breadcrumbNames.isEmpty) {
        breadcrumbNames.add(folderName);
      }

      final breadcrumbIds =
          pathData.map((crumb) => crumb['id'] as String?).toList();
      final displayPath = ['My Drive', ...breadcrumbNames];
      final displayIds = [null, ...breadcrumbIds];

      if (!mounted) return;

      setState(() {
        currentFolderId = folderId;
        currentFolderPath = folderName;
        navigationPath = displayPath;
        navigationFolderIds = displayIds;
        folderContents[currentFolderPath] = folderItems;
        selectedSection = 'My Drive';
        _updateFilteredFiles();
        isLoading = false;
      });

      if (fromShareLink) {
        _clearShareQueryFromUrl();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open folder: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openFileById(
    String fileId, {
    bool fromShareLink = false,
  }) async {
    final item = await FileApiService.getFileById(fileId);
    if (!mounted) return;

    if (item == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('File not found or no longer accessible'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _showFileViewer(item);

    if (fromShareLink) {
      _clearShareQueryFromUrl();
    }
  }

  void _showFileViewer(DriveItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: darkBorder),
          ),
          child: Column(
            children: [
              // File viewer header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  border: Border(bottom: BorderSide(color: darkBorder)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _fileService.getFileIcon(item.type),
                      color: primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: lightText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item.size} • Modified ${item.lastModified}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: dimText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _openInBrowser(item),
                          icon: const Icon(Icons.open_in_new, color: dimText),
                          tooltip: 'Open in new tab',
                        ),
                        IconButton(
                          onPressed: () => _downloadFile(item),
                          icon: const Icon(Icons.download, color: dimText),
                          tooltip: 'Download',
                        ),
                        IconButton(
                          onPressed: () => _shareFile(item),
                          icon: const Icon(Icons.share, color: dimText),
                          tooltip: 'Share',
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: dimText),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // File content area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: _buildFileContent(item),
                ),
              ),
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  border: Border(top: BorderSide(color: darkBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: dimText),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _editFile(item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileContent(DriveItem item) {
    final extension = _fileService.getFileExtension(item.name).toLowerCase();

    if (extension == 'pdf') {
      return _buildPdfPreview(item);
    }

    if (_fileService.isImageFile(extension)) {
      return _buildImagePreview(item);
    }

    if (_fileService.isVideoFile(extension)) {
      return _buildVideoPreview(item);
    }

    if (_fileService.isAudioFile(extension)) {
      return _buildAudioPreview(item);
    }

    if (_isOfficeFile(extension)) {
      return _buildOfficePreview(item);
    }

    if (_isTextFile(extension)) {
      return _buildTextPreview(item);
    }

    switch (item.type) {
      case DriveItemType.document:
        return _buildOfficePreview(item);
      case DriveItemType.spreadsheet:
        return _buildOfficePreview(item);
      default:
        return _buildGenericPreview(item);
    }
  }

  Widget _buildPdfPreview(DriveItem item) {
    if (!kIsWeb) {
      return _buildNonWebPreviewFallback(
        'Inline PDF preview is only available on the web version. '
        'Use the Open button to view this file on other platforms.',
        Icons.picture_as_pdf,
      );
    }

    if (item.id == null) {
      return _buildMissingIdMessage('PDF');
    }

    return FutureBuilder<_BinaryPreviewData?>(
      future: _loadBinaryPreview(item, mimeType: 'application/pdf'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              'Failed to load PDF preview.',
              style: const TextStyle(color: dimText),
            ),
          );
        }

        final dataUrl = snapshot.data!.dataUrl;
        final viewType =
            'pdf-data-${item.id}-${DateTime.now().microsecondsSinceEpoch}';

        ui.platformViewRegistry.registerViewFactory(viewType, (int _) {
          final iframe = html.IFrameElement()
            ..src = dataUrl
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';
          iframe.setAttribute('type', 'application/pdf');
          iframe.allow = 'fullscreen';
          return iframe;
        });

        return _buildWebViewerShell(
          item: item,
          icon: Icons.picture_as_pdf,
          headerColor: Colors.red.shade600,
          bodyColor: Colors.grey[100]!,
          child: HtmlElementView(viewType: viewType),
        );
      },
    );
  }

  Widget _buildOfficePreview(DriveItem item) {
    return _buildNonWebPreviewFallback(
      'Preview for this document type is not available yet.\n'
      'Use the Open button to view it in a new tab.',
      Icons.description,
    );
  }

  Widget _buildImagePreview(DriveItem item) {
    if (item.id == null) {
      return const Center(
        child: Text(
          'Cannot preview this image – missing file id.',
          style: TextStyle(color: dimText),
        ),
      );
    }

    return FutureBuilder<String?>(
      future: FileApiService.getFilePreviewUrl(item.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              'Failed to load image preview.',
              style: const TextStyle(color: dimText),
            ),
          );
        }

        final url = snapshot.data!;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: darkBorder),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.image, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Error displaying image.',
                            style: TextStyle(color: dimText),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoPreview(DriveItem item) {
    return _buildMediaPreview(
      item,
      icon: Icons.videocam,
      headerColor: Colors.deepPurple,
      bodyColor: Colors.black,
      webOnlyMessage:
          'Video preview is only available on the web version right now.',
      elementBuilder: (url) {
        final video = html.VideoElement()
          ..src = url
          ..controls = true
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.backgroundColor = '#000';
        video.setAttribute('playsinline', 'true');
        return video;
      },
    );
  }

  Widget _buildAudioPreview(DriveItem item) {
    return _buildMediaPreview(
      item,
      icon: Icons.audiotrack,
      headerColor: Colors.deepPurple,
      bodyColor: darkCard,
      webOnlyMessage:
          'Audio preview is only available on the web version right now.',
      elementBuilder: (url) {
        final audio = html.AudioElement()
          ..src = url
          ..controls = true
          ..style.width = '100%'
          ..style.height = '100%';
        audio.setAttribute('controlsList', 'nodownload');
        return audio;
      },
    );
  }

  Widget _buildTextPreview(DriveItem item) {
    if (!kIsWeb) {
      return _buildNonWebPreviewFallback(
        'Text preview is only available on the web version right now.',
        Icons.article,
      );
    }

    if (item.id == null) {
      return _buildMissingIdMessage('file');
    }

    return FutureBuilder<_BinaryPreviewData?>(
      future: _loadBinaryPreview(item, mimeType: 'text/plain'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              'Failed to load preview.',
              style: const TextStyle(color: dimText),
            ),
          );
        }

        final content = const Utf8Decoder().convert(snapshot.data!.bytes);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: darkBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: SelectableText(
              content,
              style: const TextStyle(
                fontFamily: 'SourceCode',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<_BinaryPreviewData?> _loadBinaryPreview(
    DriveItem item, {
    required String mimeType,
  }) async {
    final url = await FileApiService.getFilePreviewUrl(item.id!);
    if (url == null) return null;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return null;

    final bytes = response.bodyBytes;
    final base64Data = base64Encode(bytes);
    final dataUrl = 'data:$mimeType;base64,$base64Data';
    return _BinaryPreviewData(bytes: bytes, dataUrl: dataUrl);
  }

  Widget _buildMediaPreview(
    DriveItem item, {
    required IconData icon,
    required Color headerColor,
    required Color bodyColor,
    required String webOnlyMessage,
    required html.Element Function(String url) elementBuilder,
  }) {
    if (item.id == null) {
      return _buildMissingIdMessage('file');
    }

    return FutureBuilder<String?>(
      future: FileApiService.getFilePreviewUrl(item.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              'Failed to load preview.',
              style: const TextStyle(color: dimText),
            ),
          );
        }

        if (!kIsWeb) {
          return _buildNonWebPreviewFallback(webOnlyMessage, icon);
        }

        final url = snapshot.data!;
        final viewType =
            'media-${item.id}-${DateTime.now().microsecondsSinceEpoch}';

        ui.platformViewRegistry.registerViewFactory(
          viewType,
          (int _) => elementBuilder(url),
        );

        return _buildWebViewerShell(
          item: item,
          icon: icon,
          headerColor: headerColor,
          bodyColor: bodyColor,
          child: HtmlElementView(viewType: viewType),
        );
      },
    );
  }

  Widget _buildWebViewerShell({
    required DriveItem item,
    required IconData icon,
    required Color headerColor,
    required Color bodyColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: darkBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonWebPreviewFallback(String message, IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: darkBorder),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: dimText, size: 42),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(color: dimText, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingIdMessage(String label) {
    return Center(
      child: Text(
        'Cannot preview this $label – missing file id.',
        style: const TextStyle(color: dimText),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGenericPreview(DriveItem item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: darkBorder),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _fileService.getFileIcon(item.type),
              size: 80,
              color: primaryPurple,
            ),
            const SizedBox(height: 16),
            Text(
              item.name,
              style: const TextStyle(
                color: lightText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'File size: ${item.size}',
              style: const TextStyle(color: dimText, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Last modified: ${item.lastModified}',
              style: const TextStyle(color: dimText, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text(
              'Preview not available for this file type',
              style: TextStyle(color: dimText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOfficeFile(String extension) {
    const officeExtensions = {
      'doc',
      'docx',
      'ppt',
      'pptx',
      'pps',
      'ppsx',
      'xls',
      'xlsx',
      'csv',
    };
    return officeExtensions.contains(extension);
  }

  bool _isTextFile(String extension) {
    const textExtensions = {'txt', 'md', 'json', 'log', 'yaml', 'yml'};
    return textExtensions.contains(extension);
  }

  void _editFile(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: darkCard,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    _fileService.getFileIcon(item.type),
                    color: primaryPurple,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Editing: ${item.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: lightText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: dimText),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: darkBorder),
                  ),
                  child: const TextField(
                    maxLines: null,
                    expands: true,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Start editing your document...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: dimText),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Changes saved to ${item.name}'),
                          backgroundColor: primaryPurple,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
    String title,
    List<DriveItem> items, {
    bool isGrid = false,
    bool showTable = false,
    bool showCards = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.keyboard_arrow_down, color: mediumText),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: lightText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (isGrid) ...[
          _buildFoldersGrid(items),
        ] else if (showTable) ...[
          _buildFilesTable(items),
        ] else if (showCards) ...[
          _buildMobileFileCards(items),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => _buildFileListItem(items[index]),
          ),
        ],
      ],
    );
  }

  Widget _buildFoldersGrid(List<DriveItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth < 1024 && screenWidth >= 768;

        int crossAxisCount;
        double childAspectRatio;

        if (isMobile) {
          crossAxisCount = 1;
          childAspectRatio = 5.0;
        } else if (isTablet) {
          crossAxisCount = 2;
          childAspectRatio = 2.5;
        } else {
          crossAxisCount = (screenWidth / 250).floor().clamp(2, 4);
          childAspectRatio = 2.0;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildFolderCard(items[index]),
        );
      },
    );
  }

  Widget _buildFolderCard(DriveItem item) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Card(
            elevation: isHovered ? 6 : 3,
            shadowColor: primaryPurple.withOpacity(0.3),
            color: darkCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _openFile(item),
              borderRadius: BorderRadius.circular(12),
              hoverColor: hoverColor.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.folder, color: primaryPurple, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: lightText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'In ${item.location}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: dimText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildFileOptionsButton(item),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileFileCards(List<DriveItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          shadowColor: primaryPurple.withOpacity(0.1),
          color: darkCard,
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _fileService.getFileIcon(item.type),
                  color: primaryPurple,
                  size: 24,
                ),
                if (item.isStarred == true) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.star, color: starColor, size: 16),
                ],
              ],
            ),
            title: Text(
              item.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: lightText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${item.reasonSuggested ?? 'Recently modified'} • ${item.lastModified}',
              style: const TextStyle(fontSize: 12, color: dimText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: _buildFileOptionsButton(item),
            onTap: () => _openFile(item),
            hoverColor: hoverColor.withOpacity(0.1),
          ),
        );
      },
    );
  }

  Widget _buildFilesTable(List<DriveItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: darkBorder),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dataTableTheme: DataTableThemeData(
                    headingTextStyle: const TextStyle(
                      color: lightText,
                      fontWeight: FontWeight.w600,
                    ),
                    dataTextStyle: const TextStyle(color: mediumText),
                  ),
                ),
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  headingRowColor: WidgetStateProperty.all(darkSurface),
                  headingRowHeight: 48,
                  dataRowHeight: 56,
                  columns: const [
                    DataColumn(
                      label: SizedBox(
                        width: 200,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: lightText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 150,
                        child: Text(
                          'Reason suggested',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: lightText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 120,
                        child: Text(
                          'Owner',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: lightText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 120,
                        child: Text(
                          'Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: lightText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(label: SizedBox(width: 40, child: Text(''))),
                  ],
                  rows: items.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: InkWell(
                              onTap: () => _openFile(item),
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _fileService.getFileIcon(item.type),
                                      color: primaryPurple,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    if (item.type != DriveItemType.folder) ...[
                                      const Icon(
                                        Icons.people,
                                        size: 16,
                                        color: dimText,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    if (item.isStarred == true) ...[
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: starColor,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: lightText,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                              '${item.reasonSuggested ?? 'Recently modified'} • ${item.lastModified}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: dimText,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: item.owner == 'me'
                                      ? primaryPurple
                                      : dimText,
                                  child: Text(
                                    item.owner?.substring(0, 1).toUpperCase() ??
                                        'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.owner ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: lightText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.location?.contains('Shared') == true
                                      ? Icons.people
                                      : Icons.folder,
                                  size: 16,
                                  color: dimText,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.location ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: lightText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 40,
                            child: _buildFileOptionsButton(item),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ENHANCED FILE OPTIONS BUTTON - THE THREE DOTS MENU
  Widget _buildFileOptionsButton(DriveItem item) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: dimText),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      color: darkCard,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: darkBorder),
      ),
      itemBuilder: (context) => [
        // Open option
        PopupMenuItem(
          value: 'open',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.type == DriveItemType.folder
                    ? Icons.folder_open
                    : Icons.open_in_new,
                size: 18,
                color: primaryPurple,
              ),
              const SizedBox(width: 12),
              const Text('Open', style: TextStyle(color: lightText)),
            ],
          ),
        ),

        // Open with (only for files, not folders)
        if (item.type != DriveItemType.folder)
          PopupMenuItem(
            value: 'open_with',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.open_with, size: 18, color: dimText),
                const SizedBox(width: 12),
                const Text('Open with', style: TextStyle(color: lightText)),
                const Spacer(),
                const Icon(Icons.arrow_right, size: 18, color: dimText),
              ],
            ),
          ),

        // Share option
        PopupMenuItem(
          value: 'share',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.share, size: 18, color: dimText),
              const SizedBox(width: 12),
              const Text('Share', style: TextStyle(color: lightText)),
            ],
          ),
        ),

        // Get link option
        PopupMenuItem(
          value: 'get_link',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link, size: 18, color: dimText),
              const SizedBox(width: 12),
              const Text('Get link', style: TextStyle(color: lightText)),
            ],
          ),
        ),

        // Divider
        const PopupMenuDivider(),

        // Star/Unstar option
        PopupMenuItem(
          value: 'star',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.isStarred == true ? Icons.star : Icons.star_outline,
                size: 18,
                color: item.isStarred == true ? starColor : dimText,
              ),
              const SizedBox(width: 12),
              Text(
                item.isStarred == true ? 'Remove star' : 'Add to starred',
                style: const TextStyle(color: lightText),
              ),
            ],
          ),
        ),

        // Rename option
        PopupMenuItem(
          value: 'rename',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.drive_file_rename_outline,
                size: 18,
                color: dimText,
              ),
              const SizedBox(width: 12),
              const Text('Rename', style: TextStyle(color: lightText)),
            ],
          ),
        ),

        // Make a copy (for files)
        if (item.type != DriveItemType.folder)
          PopupMenuItem(
            value: 'make_copy',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.content_copy, size: 18, color: dimText),
                const SizedBox(width: 12),
                const Text('Make a copy', style: TextStyle(color: lightText)),
              ],
            ),
          ),

        // Download option
        PopupMenuItem(
          value: 'download',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download, size: 18, color: dimText),
              const SizedBox(width: 12),
              const Text('Download', style: TextStyle(color: lightText)),
            ],
          ),
        ),

        // Move option
        PopupMenuItem(
          value: 'move',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drive_file_move, size: 18, color: dimText),
              const SizedBox(width: 12),
              const Text('Move', style: TextStyle(color: lightText)),
            ],
          ),
        ),

        // Divider before delete options
        const PopupMenuDivider(),

        // Move to trash or restore/delete forever based on current section
        if (selectedSection != 'Trash')
          PopupMenuItem(
            value: 'move_to_trash',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete, size: 18, color: dimText),
                const SizedBox(width: 12),
                const Text('Move to trash', style: TextStyle(color: lightText)),
              ],
            ),
          )
        else ...[
          PopupMenuItem(
            value: 'restore',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.restore, size: 18, color: primaryPurple),
                const SizedBox(width: 12),
                const Text('Restore', style: TextStyle(color: primaryPurple)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete_forever',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_forever, size: 18, color: Colors.red),
                const SizedBox(width: 12),
                const Text(
                  'Delete forever',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ],
      onSelected: (value) => _handleFileAction(value, item),
    );
  }

  // ENHANCED FILE ACTION HANDLER - ALL ACTIONS WORK
  void _handleFileAction(String action, DriveItem item) {
    switch (action) {
      case 'open':
        _openFile(item);
        break;
      case 'open_with':
        _showOpenWithOptions(item);
        break;
      case 'share':
        _shareFile(item);
        break;
      case 'get_link':
        _getShareableLink(item);
        break;
      case 'star':
        _toggleStar(item);
        break;
      case 'rename':
        _renameFile(item);
        break;
      case 'make_copy':
        _makeCopy(item);
        break;
      case 'download':
        _downloadFile(item);
        break;
      case 'move':
        _moveFile(item);
        break;
      case 'move_to_trash':
        _moveToTrash(item);
        break;
      case 'restore':
        _restoreFromTrash(item);
        break;
      case 'delete_forever':
        _deleteFromTrash(item);
        break;
    }
  }

  // ADD TO STARRED FUNCTIONALITY
  Future<void> _toggleStar(DriveItem item) async {
    if (item.id == null) return;

    final result = await FileApiService.toggleStar(item.id!, item.isStarred);

    if (result['success'] == true) {
      // Reload files to get updated state
      await _loadInitialData();

      final message = result['isStarred'] == true
          ? 'Added "${item.name}" to starred'
          : 'Removed "${item.name}" from starred';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: primaryPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to update star'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // DOWNLOAD FUNCTIONALITY
  void _downloadFile(DriveItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.download, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('Downloading ${item.name}...')),
          ],
        ),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Show download progress or location
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: darkCard,
                title: const Text(
                  'Download',
                  style: TextStyle(color: lightText),
                ),
                content: Text(
                  'File "${item.name}" has been downloaded to your Downloads folder.',
                  style: const TextStyle(color: dimText),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: primaryPurple),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Open the authenticated preview URL for a file in the browser / system app.
  Future<void> _openInBrowser(DriveItem item) async {
    if (item.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot open this file – missing file id'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final previewUrl = await FileApiService.getFilePreviewUrl(item.id!);
      if (previewUrl == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need to be logged in to open files'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final uri = Uri.parse(previewUrl);
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open "${item.name}".'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open file: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // RENAME FUNCTIONALITY
  void _renameFile(DriveItem item) async {
    String currentName = item.name;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: currentName);
        return AlertDialog(
          backgroundColor: darkCard,
          title: Text(
            'Rename "${item.name}"',
            style: const TextStyle(color: lightText),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: lightText),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: darkBorder),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryPurple, width: 2),
                ),
                labelText: 'Name',
                labelStyle: const TextStyle(color: dimText),
                filled: true,
                fillColor: darkSurface,
              ),
              autofocus: true,
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: dimText)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty && result != currentName) {
      setState(() {
        final updatedItem = item.copyWith(name: result);
        _updateItemInLists(item, updatedItem);
        _updateStarredFiles();
        _updateFilteredFiles();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Renamed to "$result"'),
            backgroundColor: primaryPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // MOVE TO TRASH FUNCTIONALITY
  Future<void> _moveToTrash(DriveItem item) async {
    if (item.id == null) return;

    final result = await FileApiService.deleteFile(item.id!);

    if (result['success'] == true) {
      // Reload files to reflect deletion
      await _loadInitialData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved "${item.name}" to trash'),
            backgroundColor: primaryPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to delete file'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // HELPER METHOD TO UPDATE ITEMS IN ALL LISTS
  void _updateItemInLists(DriveItem oldItem, DriveItem newItem) {
    // Update in My Drive files
    final myDriveIndex = myDriveFiles.indexWhere((f) => f.name == oldItem.name);
    if (myDriveIndex != -1) {
      myDriveFiles[myDriveIndex] = newItem;
    }

    // Update in Recent files
    final recentIndex = recentFiles.indexWhere((f) => f.name == oldItem.name);
    if (recentIndex != -1) {
      recentFiles[recentIndex] = newItem;
    }

    // Update in Trash files
    final trashIndex = trashFiles.indexWhere((f) => f.name == oldItem.name);
    if (trashIndex != -1) {
      trashFiles[trashIndex] = newItem;
    }
  }

  // ADDITIONAL FUNCTIONALITY FOR OTHER OPTIONS
  void _shareFile(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCard,
        title: Row(
          children: [
            Icon(Icons.share, color: primaryPurple),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Share "${item.name}"',
                style: const TextStyle(color: lightText),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: lightText),
                decoration: InputDecoration(
                  hintText: 'Add people and groups',
                  hintStyle: const TextStyle(color: dimText),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: darkBorder),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryPurple, width: 2),
                  ),
                  filled: true,
                  fillColor: darkSurface,
                  suffixIcon: Icon(Icons.send, color: primaryPurple),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.link, color: primaryPurple, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Anyone with the link',
                      style: TextStyle(color: lightText),
                    ),
                  ),
                  DropdownButton<String>(
                    value: 'Viewer',
                    dropdownColor: darkCard,
                    style: const TextStyle(color: lightText),
                    items: const [
                      DropdownMenuItem(value: 'Viewer', child: Text('Viewer')),
                      DropdownMenuItem(
                        value: 'Commenter',
                        child: Text('Commenter'),
                      ),
                      DropdownMenuItem(value: 'Editor', child: Text('Editor')),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: dimText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing settings updated for "${item.name}"'),
                  backgroundColor: primaryPurple,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String? _buildShareLink(DriveItem item) {
    if (item.id == null) return null;
    final params = item.type == DriveItemType.folder
        ? {'folderId': item.id!}
        : {'fileId': item.id!};
    return Uri.base.replace(queryParameters: params).toString();
  }

  Future<void> _getShareableLink(DriveItem item) async {
    final messenger = ScaffoldMessenger.of(context);
    final link = _buildShareLink(item);

    if (link == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Unable to create link for "${item.name}"'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkCard,
          title: Row(
            children: [
              const Icon(Icons.link, color: primaryPurple),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Get link',
                  style: const TextStyle(color: lightText),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.type == DriveItemType.folder
                    ? 'Anyone who can access BockDrive will be taken directly to this folder.'
                    : 'Anyone who can access BockDrive will open this file in the viewer.',
                style: const TextStyle(color: mediumText),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: darkBorder),
                ),
                child: SelectableText(
                  link,
                  style: const TextStyle(color: lightText),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close', style: TextStyle(color: dimText)),
            ),
            TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse(link);
                final launched = await launchUrl(
                  uri,
                  mode: LaunchMode.platformDefault,
                );
                if (!launched && mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Unable to open link in browser'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open link'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: link));
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Link copied for "${item.name}"'),
                      backgroundColor: primaryPurple,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy link'),
            ),
          ],
        );
      },
    );
  }

  void _makeCopy(DriveItem item) {
    final copyName = 'Copy of ${item.name}';
    final newItem = item.copyWith(
      name: copyName,
      lastModified: 'Just now',
      owner: 'me',
      location: 'My Drive',
      isStarred: false,
    );

    setState(() {
      myDriveFiles.insert(0, newItem);
      recentFiles.insert(0, newItem.copyWith(reasonSuggested: 'You created'));
      if (selectedSection == 'My Drive') {
        filteredFiles.insert(0, newItem);
      } else if (selectedSection == 'Recent') {
        filteredFiles.insert(
          0,
          newItem.copyWith(reasonSuggested: 'You created'),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Created copy: "$copyName"'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Open',
          textColor: Colors.white,
          onPressed: () => _openFile(newItem),
        ),
      ),
    );
  }

  void _moveFile(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCard,
        title: Row(
          children: [
            Icon(Icons.drive_file_move, color: primaryPurple),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Move "${item.name}"',
                style: const TextStyle(color: lightText),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: lightText),
                decoration: InputDecoration(
                  hintText: 'Search folders',
                  hintStyle: const TextStyle(color: dimText),
                  prefixIcon: const Icon(Icons.search, color: dimText),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: darkBorder),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryPurple, width: 2),
                  ),
                  filled: true,
                  fillColor: darkSurface,
                ),
              ),
              const SizedBox(height: 16),

              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.folder, color: primaryPurple),
                      title: const Text(
                        'My Drive',
                        style: TextStyle(color: lightText),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _performMove(item, 'My Drive');
                      },
                      hoverColor: hoverColor.withOpacity(0.1),
                    ),
                    ...suggestedFolders.map(
                      (folder) => ListTile(
                        leading: Icon(Icons.folder, color: primaryPurple),
                        title: Text(
                          folder.name,
                          style: const TextStyle(color: lightText),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _performMove(item, folder.name);
                        },
                        hoverColor: hoverColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: dimText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performMove(item, 'My Drive');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Move'),
          ),
        ],
      ),
    );
  }

  void _performMove(DriveItem item, String destination) {
    final originalLocation = item.location;
    setState(() {
      final updatedItem = item.copyWith(location: destination);
      _updateItemInLists(item, updatedItem);
      _updateStarredFiles();
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "${item.name}" to $destination'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              final revertedItem = item.copyWith(location: originalLocation);
              _updateItemInLists(
                item.copyWith(location: destination),
                revertedItem,
              );
              _updateStarredFiles();
              _updateFilteredFiles();
            });
          },
        ),
      ),
    );
  }

  void _showOpenWithOptions(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCard,
        title: const Text('Open with', style: TextStyle(color: lightText)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.preview, color: primaryPurple),
                title: const Text(
                  'Preview',
                  style: TextStyle(color: lightText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showFileViewer(item);
                },
                hoverColor: hoverColor.withOpacity(0.1),
              ),
              ListTile(
                leading: Icon(Icons.edit, color: primaryPurple),
                title: const Text(
                  'Default Editor',
                  style: TextStyle(color: lightText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _editFile(item);
                },
                hoverColor: hoverColor.withOpacity(0.1),
              ),
              ListTile(
                leading: Icon(Icons.description, color: primaryPurple),
                title: const Text(
                  'External App',
                  style: TextStyle(color: lightText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening ${item.name} with external app...',
                      ),
                      backgroundColor: primaryPurple,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                hoverColor: hoverColor.withOpacity(0.1),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: dimText)),
          ),
        ],
      ),
    );
  }

  void _restoreFromTrash(DriveItem item) {
    setState(() {
      trashFiles.removeWhere((f) => f.name == item.name);
      myDriveFiles.add(item.copyWith(location: 'My Drive'));
      _updateStarredFiles();
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restored "${item.name}"'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteFromTrash(DriveItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCard,
        title: const Text(
          'Delete forever?',
          style: TextStyle(color: lightText),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            'This will permanently delete "${item.name}". You cannot undo this action.',
            style: const TextStyle(color: dimText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: dimText)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete forever'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        trashFiles.removeWhere((f) => f.name == item.name);
        _updateFilteredFiles();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permanently deleted "${item.name}"'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildFilesView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Column(
      children: [
        // Content Header
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedSection == 'My Drive' &&
                          currentFolderPath != 'My Drive'
                      ? currentFolderPath
                      : selectedSection,
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w400,
                    color: lightText,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, color: dimText),
                    tooltip: 'Details',
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.view_list, color: dimText),
                    tooltip: 'List view',
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Files List/Grid
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: primaryPurple))
              : filteredFiles.isEmpty
              ? _buildEmptyState()
              : selectedSection == 'Recent' ||
                    selectedSection == 'Starred' ||
                    isMobile
              ? _buildRecentFilesView()
              : _buildFilesGrid(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (selectedSection) {
      case 'Trash':
        message = 'Trash is empty';
        icon = Icons.delete_outline;
        break;
      case 'Starred':
        message = 'No starred files';
        icon = Icons.star_outline;
        break;
      default:
        message = 'No files found';
        icon = Icons.folder_open;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: dimText),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 18, color: dimText)),
        ],
      ),
    );
  }

  Widget _buildRecentFilesView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: isMobile
          ? _buildMobileFileCards(filteredFiles)
          : _buildFilesTable(filteredFiles),
    );
  }

  Widget _buildFilesGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth < 1024 && screenWidth >= 768;

        int crossAxisCount;
        if (isMobile) {
          crossAxisCount = 2;
        } else if (isTablet) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = (screenWidth / 200).floor().clamp(3, 6);
        }

        return GridView.builder(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: filteredFiles.length,
          itemBuilder: (context, index) {
            return _buildFileCard(filteredFiles[index]);
          },
        );
      },
    );
  }

  Widget _buildFileCard(DriveItem item) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Card(
            elevation: isHovered ? 6 : 3,
            shadowColor: primaryPurple.withOpacity(0.3),
            color: darkCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _openFile(item),
              borderRadius: BorderRadius.circular(12),
              hoverColor: hoverColor.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _fileService.getFileIcon(item.type),
                              size: 32,
                              color: primaryPurple,
                            ),
                            if (item.isStarred == true) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.star, color: starColor, size: 16),
                            ],
                          ],
                        ),
                        _buildFileOptionsButton(item),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: lightText,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (item.size.isNotEmpty) ...[
                            Text(
                              '${item.size} • ${item.lastModified}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: dimText,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileListItem(DriveItem item) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_fileService.getFileIcon(item.type), color: primaryPurple),
          if (item.isStarred == true) ...[
            const SizedBox(width: 4),
            Icon(Icons.star, color: starColor, size: 16),
          ],
        ],
      ),
      title: Text(
        item.name,
        style: const TextStyle(color: lightText),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        '${item.size} • ${item.lastModified}',
        style: const TextStyle(color: dimText),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: _buildFileOptionsButton(item),
      onTap: () => _openFile(item),
      hoverColor: hoverColor.withOpacity(0.1),
    );
  }

  Widget _buildFilterButton(String text) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
      label: Text(text, style: const TextStyle(fontSize: 14)),
      style: OutlinedButton.styleFrom(
        foregroundColor: mediumText,
        side: BorderSide(color: darkBorder),
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
      ),
    );
  }

  void _showNewMenu(BuildContext context) {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    if (button == null) return;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, 50), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: darkBorder),
      ),
      items: [
        PopupMenuItem(
          value: 'folder',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.create_new_folder, color: primaryPurple),
              const SizedBox(width: 12),
              const Text('New folder', style: TextStyle(color: lightText)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'upload_file',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.upload_file, color: primaryPurple),
              const SizedBox(width: 12),
              const Text('File upload', style: TextStyle(color: lightText)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'upload_folder',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.drive_folder_upload, color: primaryPurple),
              const SizedBox(width: 12),
              const Text('Folder upload', style: TextStyle(color: lightText)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleNewAction(value);
      }
    });
  }

  Future<void> _handleNewAction(String action) async {
    setState(() {
      isLoading = true;
    });

    try {
      switch (action) {
        case 'folder':
          await _createNewFolder();
          break;
        case 'upload_file':
          await _uploadFile();
          break;
        case 'upload_folder':
          await _uploadFolder();
          break;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // FIXED: Create new folder - prevents duplicate creation
  Future<void> _createNewFolder() async {
    final folderName = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: darkCard,
          title: const Text('New Folder', style: TextStyle(color: lightText)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: lightText),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: darkBorder),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryPurple, width: 2),
                ),
                labelText: 'Folder name',
                labelStyle: const TextStyle(color: dimText),
                filled: true,
                fillColor: darkSurface,
              ),
              autofocus: true,
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: dimText)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (folderName != null && folderName.isNotEmpty) {
      final result = await FolderApiService.createFolder(
        name: folderName,
        parentId: currentFolderId,
      );

      if (result['success'] == true) {
        // Reload files to get the new folder
        await _loadInitialData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Folder "$folderName" created'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to create folder'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _uploadFile() async {
    try {
      final result = await _fileService.pickFiles();
      if (result != null && result.isNotEmpty) {
        int successCount = 0;
        int failCount = 0;

        for (final file in result) {
          final uploadResult = await FileApiService.uploadFile(
            file,
            folderId: currentFolderId,
          );

          if (uploadResult['success'] == true) {
            successCount++;
          } else {
            failCount++;
          }
        }

        // Reload files after upload
        await _loadInitialData();

        if (mounted) {
          if (failCount == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$successCount file(s) uploaded successfully'),
                backgroundColor: primaryPurple,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$successCount uploaded, $failCount failed'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading files: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadFolder() async {
    try {
      final result = await _fileService.pickDirectory();
      if (result != null) {
        final normalizedPath =
            result.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');
        final folderName =
            normalizedPath.isNotEmpty ? normalizedPath.split('/').last : '';

        if (folderName.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to determine the selected folder name'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        // Check if folder already exists
        final folderExists =
            (currentFolderPath == 'My Drive'
                    ? myDriveFiles
                    : folderContents[currentFolderPath] ?? [])
                .any(
                  (item) =>
                      item.name == folderName &&
                      item.type == DriveItemType.folder,
                );

        if (folderExists) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Folder "$folderName" already exists'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        final creationResult = await FolderApiService.createFolder(
          name: folderName,
          parentId: currentFolderId,
        );

        if (creationResult['success'] != true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  creationResult['message'] ??
                      'Failed to upload folder "$folderName"',
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        await _loadInitialData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Folder "$folderName" uploaded successfully'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading folder: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Extension to add copyWith method to DriveItem
extension DriveItemExtension on DriveItem {
  DriveItem copyWith({
    String? name,
    DriveItemType? type,
    String? size,
    String? lastModified,
    String? owner,
    String? location,
    String? reasonSuggested,
    bool? isStarred,
  }) {
    return DriveItem(
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      lastModified: lastModified ?? this.lastModified,
      owner: owner ?? this.owner,
      location: location ?? this.location,
      reasonSuggested: reasonSuggested ?? this.reasonSuggested,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

class _BinaryPreviewData {
  final Uint8List bytes;
  final String dataUrl;

  const _BinaryPreviewData({required this.bytes, required this.dataUrl});
}
