import 'package:flutter/material.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me Screen')),
      body: const Center(child: Text('Welcome to the Me Screen!')),
    );
  }
}
