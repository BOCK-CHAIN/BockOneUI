import 'package:flutter/material.dart';

class DesktopDrive extends StatelessWidget {
  const DesktopDrive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BockDrive')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Desktop Drive is available on web only.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
