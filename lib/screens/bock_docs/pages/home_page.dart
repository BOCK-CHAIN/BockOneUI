import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import '../widgets/custom_widgets.dart'; // assuming you have DocumentCard and TemplateCard here

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // You can keep your existing documents list or replace with your service call

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          bottom: false,
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
            title: Text(
              'BockDocs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final theme = Theme.of(context);
              return PopupMenuButton<String>(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  size: 20,
                  color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
                ),
                onSelected: (value) {
                  if (value == 'theme') {
                    themeProvider.toggleTheme();
                  } else if (value == 'search') {
                    // Handle search
                  } else if (value == 'settings') {
                    Navigator.pushNamed(context, '/settings');
                  } else if (value == 'profile') {
                    Navigator.pushNamed(context, '/settings');
                  } else if (value == 'logout') {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'theme',
                    child: Row(
                      children: [
                        Icon(
                          themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'search',
                    child: Row(
                      children: [
                        Icon(Icons.search, size: 20),
                        const SizedBox(width: 12),
                        const Text('Search'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined, size: 20),
                        const SizedBox(width: 12),
                        const Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20),
                        const SizedBox(width: 12),
                        const Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        const Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.description, color: Colors.white, size: 40),
                  SizedBox(height: 16),
                  Text(
                    'BockDocs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (bool value) {
                themeProvider.toggleTheme();
              },
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start a new document',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TemplateCard(
                        icon: Icons.add,
                        label: 'Blank',
                        color: Theme.of(context).primaryColor,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'blank'});
                        },
                      ),
                      const SizedBox(width: 16),
                      TemplateCard(
                        icon: Icons.description_outlined,
                        label: 'Resume',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'resume'});
                        },
                      ),
                      const SizedBox(width: 16),
                      TemplateCard(
                        icon: Icons.article_outlined,
                        label: 'Letter',
                        color: Colors.green,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'letter'});
                        },
                      ),
                      const SizedBox(width: 16),
                      TemplateCard(
                        icon: Icons.file_present_outlined,
                        label: 'Report',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'report'});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Recent documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                // Add your DocumentCard list here or reuse your existing document list with updated widget
              ],
            ),
          ),
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/editor', arguments: {'template': 'blank'});
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}