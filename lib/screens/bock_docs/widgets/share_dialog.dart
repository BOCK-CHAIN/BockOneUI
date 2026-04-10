import 'package:flutter/material.dart';

class ShareDialog extends StatefulWidget {
  final String documentId;

  const ShareDialog({super.key, required this.documentId});

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  final TextEditingController _emailController = TextEditingController();
  final List<String> _sharedUsers = [];
  bool _isLoading = false;

  void _addUser() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_sharedUsers.contains(email)) {
      setState(() {
        _sharedUsers.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeUser(String email) {
    setState(() {
      _sharedUsers.remove(email);
    });
  }

  void _save() async {
    setState(() => _isLoading = true);
    // TODO: Connect to backend to share document
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter email to share',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addUser,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _sharedUsers
                .map((email) => Chip(
                      label: Text(email),
                      onDeleted: () => _removeUser(email),
                    ))
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Save'),
        ),
      ],
    );
  }
}