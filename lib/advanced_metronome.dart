import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

final player = AudioPlayer();
final currentDuration = Stopwatch();

class MetronomeSettings {
  int duration;
  int bpm;

  MetronomeSettings(this.duration, this.bpm);
}

List<MetronomeSettings> metronomeSettings = [];

class AdvancedMetronome extends StatefulWidget {
  @override
  _AdvancedMetronomeState createState() => _AdvancedMetronomeState();
}

class _AdvancedMetronomeState extends State<AdvancedMetronome> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _bpmController = TextEditingController();

  Timer? _timer;
  bool _isPlaying = false;

  Future<void> _playClickSound() async {
    await player.stop();
    await player.play(AssetSource('metronome_basic_sound.mp3'));
  }

  void _startStopMetronome() {
    if (_isPlaying) {
      _timer?.cancel();
    } else {
      for (MetronomeSettings settings in metronomeSettings) {
        currentDuration.reset();
        currentDuration.start();
        final int delay = (60 / settings.bpm * 1000).round();
        _timer = Timer.periodic(Duration(milliseconds: delay), (timer) {
          _playClickSound();
          if ((currentDuration.elapsedMilliseconds) >=
              (settings.duration * 1000)) {
            print("aaa");
            _timer?.cancel();
          }
        });
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _saveSettings(duration, bpm) {
    MetronomeSettings settings =
        MetronomeSettings(int.parse(duration), int.parse(bpm));
    metronomeSettings.add(settings);
    setState(() {});
  }

  void _clearSettings() {
    metronomeSettings.clear();
    setState(() {});
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _durationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Duração do metrônomo',
                  hintText: 'Digite os segundos ex: 60',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _bpmController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'BPM desejado',
                  hintText: 'Digite o BPM ex: 120',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () =>
                  _saveSettings(_durationController.text, _bpmController.text),
              child: const Text('Salvar configurações'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _startStopMetronome,
              child: Text(_isPlaying ? 'Stop' : 'Start'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _clearSettings,
              child: const Text('Limpar configurações'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: metronomeSettings.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'BPM: ${metronomeSettings[index].bpm}, Duration: ${metronomeSettings[index].duration}'),
                  );
                },
              ),
            )
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
