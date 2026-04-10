import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drive_exit_scope.dart';
import '../models/drive_models.dart';
import '../services/file_services.dart';
import '../services/file_api_service.dart';
import '../services/folder_api_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class MobileDrive extends StatefulWidget {
  const MobileDrive({super.key});

  @override
  State<MobileDrive> createState() => _MobileDriveState();
}

class _MobileDriveState extends State<MobileDrive> {
  String selectedSection = 'Home';
  int selectedBottomTab = 0; // 0: Home, 1: Starred, 2: Files, 3: Trash
  String selectedSubTab = 'Suggestions'; // For Home tab: Suggestions/Activity
  String selectedSidebarSection = 'My Drive'; // For Files tab sidebar sections
  final FileService _fileService = FileService();
  List<DriveItem> allFiles = [];
  List<DriveItem> myDriveFiles = [];
  List<DriveItem> recentFiles = [];
  List<DriveItem> starredFiles = [];
  List<DriveItem> trashFiles = [];
  List<DriveItem> filteredFiles = [];
  bool isLoading = false;
  String searchQuery = '';

  String? _userEmail;
  bool _isUserLoading = false;

  // Dark Purple theme colors
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFF9333EA);
  static const Color darkPurple = Color(0xFF5B21B6);
  static const Color purpleAccent = Color(0xFFA855F7);
  static const Color darkBackground = Color(0xFF0F0F23);
  static const Color cardBackground = Color(0xFF1E1B3A);
  static const Color surfaceColor = Color(0xFF2D2A54);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFF475569);
  static const Color accentGlow = Color(0xFF4C1D95);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadCurrentUser();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load files from root folder
      final files = await FileApiService.getFiles();
      final starred = await FileApiService.getStarredFiles();
      final trash = await FileApiService.getTrashedFiles();

      setState(() {
        myDriveFiles = files;
        starredFiles = starred;
        trashFiles = trash;
        recentFiles = files.take(5).toList(); // Get recent from files
        _updateFilteredFiles();
        isLoading = false;
      });
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
      // Ignore errors, show default avatar instead
    } finally {
      if (mounted) {
        setState(() {
          _isUserLoading = false;
        });
      }
    }
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


  void _updateFilteredFiles() {
    switch (selectedBottomTab) {
      case 0: // Home tab - show suggestions/activity
        if (selectedSubTab == 'Suggestions') {
          filteredFiles = myDriveFiles.take(7).toList();
        } else {
          filteredFiles = [];
        }
        break;
      case 1: // Starred tab
        filteredFiles = starredFiles;
        break;
      case 2: // Files tab - show based on sidebar selection
        switch (selectedSidebarSection) {
          case 'My Drive':
            filteredFiles = myDriveFiles;
            break;
          case 'Recent':
            filteredFiles = recentFiles;
            break;
          default:
            filteredFiles = myDriveFiles;
        }
        break;
      case 3: // Trash tab
        filteredFiles = trashFiles;
        break;
      default:
        filteredFiles = myDriveFiles;
    }

    if (searchQuery.isNotEmpty) {
      filteredFiles = filteredFiles
          .where((file) => file.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  Future<void> _toggleStarred(DriveItem item) async {
    if (item.id == null) return;

    final result = await FileApiService.toggleStar(item.id!, item.isStarred);
    
    if (result['success'] == true) {
      // Reload files to get updated state
      await _loadInitialData();
      
      final message = result['isStarred'] == true
          ? '${item.name} added to starred'
          : '${item.name} removed from starred';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: primaryPurple,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          if (selectedBottomTab == 0) _buildTabBar(),
          if (selectedBottomTab == 2) _buildFilesHeader(),
          if (selectedBottomTab == 1) _buildStarredHeader(),
          if (selectedBottomTab == 3) _buildTrashHeader(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryPurple))
                : _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: selectedBottomTab != 3
          ? FloatingActionButton(
              onPressed: () => _showNewMenu(context),
              backgroundColor: primaryPurple,
              elevation: 8,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final exitScope = DriveExitScope.maybeOf(context);
    final canExitDrive = exitScope?.onExit != null;

    return AppBar(
      backgroundColor: cardBackground,
      elevation: 0,
      shadowColor: primaryPurple.withOpacity(0.3),
      automaticallyImplyLeading: false,
      leadingWidth: canExitDrive ? 104 : 56,
      leading: Builder(
        builder: (scaffoldContext) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canExitDrive)
              IconButton(
                onPressed: exitScope!.onExit,
                icon: const Icon(Icons.arrow_back, color: textPrimary),
                tooltip: 'Back to Bock Chain',
              ),
            IconButton(
              onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              icon: const Icon(Icons.menu, color: textPrimary),
              tooltip: 'Open menu',
            ),
          ],
        ),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryPurple.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search, color: textSecondary),
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(color: textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search in Drive',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: textMuted),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _updateFilteredFiles();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        _buildUserAvatar(),
        const SizedBox(width: 16),
      ],
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
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryPurple, lightPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
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
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: cardBackground,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryPurple, darkPurple, accentGlow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [purpleAccent, lightPurple, primaryPurple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.cloud, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'BockDrive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: cardBackground,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home, 'Home', () {
                    setState(() {
                      selectedBottomTab = 0;
                      selectedSection = 'Home';
                      selectedSubTab = 'Suggestions';
                      _updateFilteredFiles();
                    });
                  }, isSelected: selectedBottomTab == 0),
                  _buildDrawerItem(Icons.folder, 'My Drive', () {
                    setState(() {
                      selectedBottomTab = 2;
                      selectedSection = 'Files';
                      selectedSidebarSection = 'My Drive';
                      _updateFilteredFiles();
                    });
                  }, isSelected: selectedBottomTab == 2 && selectedSidebarSection == 'My Drive'),
                  _buildDrawerItem(Icons.access_time, 'Recent', () {
                    setState(() {
                      selectedBottomTab = 2;
                      selectedSection = 'Files';
                      selectedSidebarSection = 'Recent';
                      _updateFilteredFiles();
                    });
                  }, isSelected: selectedBottomTab == 2 && selectedSidebarSection == 'Recent'),
                  _buildDrawerItem(Icons.star_outline, 'Starred', () {
                    setState(() {
                      selectedBottomTab = 1;
                      selectedSection = 'Starred';
                      _updateFilteredFiles();
                    });
                  }, isSelected: selectedBottomTab == 1),
                  _buildDrawerItem(Icons.delete_outline, 'Trash', () {
                    setState(() {
                      selectedBottomTab = 3;
                      selectedSection = 'Trash';
                      _updateFilteredFiles();
                    });
                  }, isSelected: selectedBottomTab == 3),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  surfaceColor.withOpacity(0.8),
                  cardBackground.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryPurple.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: primaryPurple.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1.72 GB of 15 GB used',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 1.72 / 15,
                    backgroundColor: surfaceColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryPurple),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Get more storage',
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        gradient: isSelected 
            ? LinearGradient(
                colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: isSelected 
            ? Border.all(color: primaryPurple.withOpacity(0.5), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? primaryPurple : textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? textPrimary : textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSubTab = 'Suggestions';
                  _updateFilteredFiles();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: selectedSubTab == 'Suggestions'
                      ? Border(
                          bottom: BorderSide(color: primaryPurple, width: 3),
                        )
                      : null,
                ),
                child: Text(
                  'Suggestions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedSubTab == 'Suggestions'
                        ? primaryPurple
                        : textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSubTab = 'Activity';
                  _updateFilteredFiles();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: selectedSubTab == 'Activity'
                      ? Border(
                          bottom: BorderSide(color: primaryPurple, width: 3),
                        )
                      : null,
                ),
                child: Text(
                  'Activity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedSubTab == 'Activity'
                        ? primaryPurple
                        : textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesHeader() {
    String headerText = selectedSidebarSection;
    
    return Container(
      color: cardBackground,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 18,
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              Icon(Icons.arrow_upward, size: 16, color: textSecondary),
              const SizedBox(width: 16),
              Icon(Icons.grid_view, color: textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarredHeader() {
    return Container(
      color: cardBackground,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Starred',
            style: TextStyle(
              fontSize: 18,
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              Icon(Icons.arrow_upward, size: 16, color: textSecondary),
              const SizedBox(width: 16),
              Icon(Icons.grid_view, color: textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrashHeader() {
    return Container(
      color: cardBackground,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Trash',
            style: TextStyle(
              fontSize: 18,
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              Icon(Icons.arrow_upward, size: 16, color: textSecondary),
              const SizedBox(width: 16),
              Icon(Icons.grid_view, color: textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (selectedBottomTab == 0 && selectedSubTab == 'Activity') {
      return _buildActivityView();
    } else {
      return _buildFilesList();
    }
  }

  Widget _buildActivityView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.timeline,
              size: 64,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No recent activity',
            style: TextStyle(
              fontSize: 18,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Activity from the last 30 days will appear here',
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilesList() {
    if (filteredFiles.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: darkBackground,
      child: ListView.builder(
        itemCount: filteredFiles.length,
        itemBuilder: (context, index) {
          return _buildMobileFileItem(filteredFiles[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    if (selectedBottomTab == 3) {
      message = 'Trash is empty';
      icon = Icons.delete_outline;
    } else if (selectedBottomTab == 1) {
      message = 'No starred files';
      icon = Icons.star_outline;
    } else if (selectedBottomTab == 0 && selectedSubTab == 'Activity') {
      message = 'No recent activity';
      icon = Icons.timeline;
    } else {
      message = 'No files found';
      icon = Icons.folder_open;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              size: 64,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (selectedBottomTab == 3) ...[
            const SizedBox(height: 12),
            Text(
              'Items in trash will be automatically deleted after 30 days',
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (selectedBottomTab == 1) ...[
            const SizedBox(height: 12),
            Text(
              'Add stars to files to see them here',
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileFileItem(DriveItem item) {
    bool isInTrash = selectedBottomTab == 3;
    bool isHomeSuggestions = selectedBottomTab == 0 && selectedSubTab == 'Suggestions';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () => _openFile(item),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryPurple.withOpacity(0.3)),
          ),
          child: Icon(
            _fileService.getFileIcon(item.type),
            color: primaryPurple,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isInTrash ? textMuted : textPrimary,
                ),
              ),
            ),
            if (!isInTrash)
              GestureDetector(
                onTap: () => _toggleStarred(item),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    item.isStarred ? Icons.star : Icons.star_outline,
                    color: item.isStarred ? Colors.amber : textSecondary,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              if (!isInTrash && !isHomeSuggestions) ...[
                Text(
                  'Modified ${item.lastModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ] else if (isHomeSuggestions) ...[
                Icon(Icons.people, size: 12, color: primaryPurple),
                const SizedBox(width: 4),
                Text(
                  'You opened • ${item.lastModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ] else ...[
                Text(
                  'Deleted • ${item.lastModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => _showFileOptions(context, item),
            icon: const Icon(Icons.more_vert, color: textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryPurple,
        unselectedItemColor: textMuted,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: selectedBottomTab,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) {
          setState(() {
            selectedBottomTab = index;
            if (index == 0) {
              selectedSection = 'Home';
              selectedSubTab = 'Suggestions';
            } else if (index == 1) {
              selectedSection = 'Starred';
            } else if (index == 2) {
              selectedSection = 'Files';
              selectedSidebarSection = 'My Drive';
            } else if (index == 3) {
              selectedSection = 'Trash';
            }
            _updateFilteredFiles();
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Starred',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            label: 'Trash',
          ),
        ],
      ),
    );
  }

  void _showNewMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: primaryPurple.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create new',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(Icons.create_new_folder, 'New folder', () => _handleNewAction('folder')),
            _buildMenuOption(Icons.upload_file, 'File upload', () => _handleNewAction('upload_file')),
            _buildMenuOption(Icons.drive_folder_upload, 'Folder upload', () => _handleNewAction('upload_folder')),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryPurple.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryPurple),
        ),
        title: Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  void _showFileOptions(BuildContext context, DriveItem item) {
    bool isInTrash = selectedBottomTab == 3;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: primaryPurple.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _fileService.getFileIcon(item.type),
                    color: primaryPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!isInTrash) ...[
              _buildFileOption(Icons.open_in_new, 'Open', () {
                Navigator.pop(context);
                _openFile(item);
              }),
              _buildFileOption(
                item.isStarred ? Icons.star : Icons.star_outline,
                item.isStarred ? 'Remove from starred' : 'Add to starred',
                () {
                  Navigator.pop(context);
                  _toggleStarred(item);
                },
              ),
              _buildFileOption(Icons.share, 'Share', () => Navigator.pop(context)),
              _buildFileOption(Icons.download, 'Download', () => Navigator.pop(context)),
              _buildFileOption(Icons.delete_outline, 'Move to trash', () {
                Navigator.pop(context);
                _moveToTrash(item);
              }, isDestructive: true),
            ] else ...[
              _buildFileOption(Icons.restore, 'Restore', () {
                Navigator.pop(context);
                _restoreFromTrash(item);
              }),
              _buildFileOption(Icons.delete_forever, 'Delete forever', () {
                Navigator.pop(context);
                _deleteForeverConfirmation(item);
              }, isDestructive: true),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Open a file from the mobile list.
  ///
  /// - For folders, we currently just show a message (navigation can be
  ///   extended later to mirror desktop behaviour).
  /// - For files, we open the backend preview URL in the browser / external app.
  void _openFile(DriveItem item) {
    if (item.type == DriveItemType.folder) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Folder preview is not yet supported on mobile for "${item.name}".'),
          backgroundColor: primaryPurple,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (item.type == DriveItemType.image) {
      _showImagePreview(item);
      return;
    }

    _openInBrowser(item);
  }

  Future<void> _showImagePreview(DriveItem item) async {
    if (item.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot preview this image – missing file id'),
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
            content: Text('You need to be logged in to preview images'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          final dialogHeight = MediaQuery.of(context).size.height * 0.8;
          return Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(12),
            child: SizedBox(
              height: dialogHeight,
              child: Column(
                children: [
                  Container(
                    color: cardBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: textPrimary),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Center(
                          child: Image.network(
                            previewUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: primaryPurple,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Failed to load image preview.',
                                    style: TextStyle(color: textPrimary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to preview image: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Open the authenticated preview URL in the system browser / viewer.
  Future<void> _openInBrowser(DriveItem item) async {
    if (item.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot open this file – missing file id'),
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
          SnackBar(
            content: const Text('You need to be logged in to open files'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final uri = Uri.parse(previewUrl);
      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

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

  Widget _buildFileOption(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDestructive ? Colors.red.withOpacity(0.3) : primaryPurple.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.2) : primaryPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : primaryPurple),
        ),
        title: Text(
          title, 
          style: TextStyle(
            color: isDestructive ? Colors.red : textPrimary, 
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
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

  Future<void> _createNewFolder() async {
    String folderName = 'Untitled folder';
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: folderName);
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('New folder', style: TextStyle(color: textPrimary)),
          content: TextField(
            controller: controller,
            style: TextStyle(color: textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryPurple.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryPurple, width: 2),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: textMuted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      final folderResult = await FolderApiService.createFolder(name: result);
      
      if (folderResult['success'] == true) {
        // Reload files to get the new folder
        await _loadInitialData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Folder "$result" created successfully'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(folderResult['message'] ?? 'Failed to create folder'),
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
        String? firstFailureMessage;

        for (final file in result) {
          final uploadResult = await FileApiService.uploadFile(file);
          if (uploadResult['success'] == true) {
            successCount++;
          } else {
            failCount++;
            firstFailureMessage ??= uploadResult['message']?.toString();
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
                content: Text(
                  firstFailureMessage != null
                      ? '$successCount uploaded, $failCount failed: $firstFailureMessage'
                      : '$successCount uploaded, $failCount failed',
                ),
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
    // Folder selection is only supported on web and desktop platforms.
    // On native mobile (Android/iOS) the underlying picker does not expose
    // a directory chooser, so we show a clear message instead of failing silently.
    if (!(kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Folder upload is only available on web and desktop.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    try {
      final result = await _fileService.pickDirectory();
      if (result != null) {
        final newFolder = DriveItem(
          name: result.split('/').last,
          type: DriveItemType.folder,
          size: 'Unknown',
          lastModified: 'Just now',
          owner: 'me',
          location: 'My Drive',
          isStarred: false,
        );
        
        setState(() {
          myDriveFiles.insert(0, newFolder);
          recentFiles.insert(0, newFolder);
          if (recentFiles.length > 5) {
            recentFiles.removeLast();
          }
          _updateFilteredFiles();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Folder uploaded successfully'),
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

  Future<void> _moveToTrash(DriveItem item) async {
    if (item.id == null) return;

    final result = await FileApiService.deleteFile(item.id!);
    
    if (result['success'] == true) {
      // Reload files to reflect deletion
      await _loadInitialData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} moved to trash'),
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

  void _restoreFromTrash(DriveItem item) {
    setState(() {
      trashFiles.remove(item);
      final restoredItem = item.copyWith(location: 'My Drive');
      myDriveFiles.add(restoredItem);
      if (restoredItem.isStarred) {
        starredFiles.add(restoredItem);
      }
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} restored'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteForeverConfirmation(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete forever?', style: TextStyle(color: textPrimary)),
        content: Text(
          'Are you sure you want to permanently delete "${item.name}"? This action cannot be undone.',
          style: TextStyle(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFromTrash(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete forever'),
          ),
        ],
      ),
    );
  }

  void _deleteFromTrash(DriveItem item) {
    setState(() {
      trashFiles.remove(item);
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} deleted permanently'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
