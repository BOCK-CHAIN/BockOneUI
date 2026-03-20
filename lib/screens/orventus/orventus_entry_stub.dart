import 'package:flutter/material.dart';

Widget buildOrventusEntry() {
  return Scaffold(
    appBar: AppBar(title: const Text('Orventus')),
    body: const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Orventus is available on web only in this build.',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
