import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/routes/route_names.dart';

/// Admin layout wrapper for admin screens
class AdminLayout extends StatelessWidget {
  final String currentRoute;
  final String title;
  final Widget child;

  const AdminLayout({
    super.key,
    required this.currentRoute,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: child,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 48,
                  color: AppColors.onPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Admin Panel',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                Text(
                  'BockVote Administration',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: RouteNames.adminDashboard,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.how_to_vote,
                  title: 'Elections',
                  route: RouteNames.adminElections,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: 'Users',
                  route: RouteNames.adminUsers,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bar_chart,
                  title: 'Results',
                  route: RouteNames.adminResults,
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/admin/settings',
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = currentRoute == route;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      onTap: () {
        Navigator.of(context).pop();
        if (!isSelected) {
          context.go(route);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(RouteNames.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}