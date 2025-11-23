import 'package:flutter/material.dart';

class WelfareScreen extends StatelessWidget {
  const WelfareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welfare Screen')),
      body: const Center(child: Text('Welcome to the Welfare Screen!')),
    );
  }
}
