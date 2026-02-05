import 'package:flutter/material.dart';

class lab3 extends StatelessWidget {
  const lab3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Step test'),
          ],
        ),
      ),
    );
  }
}
