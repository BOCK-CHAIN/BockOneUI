import 'package:flutter/material.dart';

import 'package:bock_vote/core/services/service_locator.dart' as bock_vote_services;
import 'package:bock_vote/main.dart' as bock_vote_app;

class BockVoteHostScreen extends StatefulWidget {
  const BockVoteHostScreen({super.key});

  @override
  State<BockVoteHostScreen> createState() => _BockVoteHostScreenState();
}

class _BockVoteHostScreenState extends State<BockVoteHostScreen> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = bock_vote_services.serviceLocator.initialize();
  }

  void _close() {
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

        return Scaffold(
          body: Stack(
            children: [
              const bock_vote_app.MyApp(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: _close,
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
