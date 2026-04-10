import 'package:flutter/material.dart';

class BockVoteHomeScreen extends StatelessWidget {
  const BockVoteHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BockVote Blockchain'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text('BockVote Native Frontend is successfully connected!'),
      ),
    );
  }
}