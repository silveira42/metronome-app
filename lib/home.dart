import 'package:flutter/material.dart';
import 'package:metronomo/basic_metronome.dart';
import 'package:metronomo/advanced_metronome.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Basic Metronome'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BasicMetronome()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Advanced Metronome'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdvancedMetronome()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
