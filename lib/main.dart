import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

final player = AudioPlayer();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Metronome(),
    );
  }
}

class Metronome extends StatefulWidget {
  @override
  _MetronomeState createState() => _MetronomeState();
}

class _MetronomeState extends State<Metronome> {
  Timer? _timer;
  bool _isPlaying = false;
  int _bpm = 120;

  Future<void> _playClickSound() async {
    await player.stop();
    await player.play(AssetSource('metronome_basic_sound.mp3'));
  }

  void _startStopMetronome() {
    if (_isPlaying) {
      _timer?.cancel();
    } else {
      final int delay = (60 / _bpm * 1000).round();
      _timer = Timer.periodic(Duration(milliseconds: delay), (timer) {
        _playClickSound();
      });
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BPM: $_bpm',
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _startStopMetronome,
              child: Text(_isPlaying ? 'Stop' : 'Start'),
            ),
            const SizedBox(height: 24.0),
            Slider(
              value: _bpm.toDouble(),
              min: 60,
              max: 240,
              onChanged: (value) {
                setState(() {
                  _bpm = value.round();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose();
    super.dispose();
  }
}
