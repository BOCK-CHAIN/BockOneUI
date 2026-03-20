import 'package:flutter/material.dart';

import 'bock_defi_entry_stub.dart'
    if (dart.library.io) 'bock_defi_entry_mobile.dart';

class BockDeFiHostScreen extends StatefulWidget {
  const BockDeFiHostScreen({super.key});

  @override
  State<BockDeFiHostScreen> createState() => _BockDeFiHostScreenState();
}

class _BockDeFiHostScreenState extends State<BockDeFiHostScreen> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = defiInitializeTables();
  }

  void _retryInit() {
    setState(() {
      _initFuture = defiInitializeTables();
    });
  }

  void _close(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => _close(context),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('De-Fi'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Cannot connect to the De-Fi database.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryInit,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              defiApp(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () => _close(context),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back',
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
}
