import 'package:flutter/material.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rimac App Bar')),
      body: const Center(child: Text('Rimac App Body')),
    );
  }
}
