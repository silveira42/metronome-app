import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

final player = AudioPlayer();
final durationcounter = Stopwatch();
final beatcounter = Stopwatch();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'Flutter Demo Home Page', bpm: '60', duration: '10'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.bpm,
      required this.duration});

  final String title;
  final String bpm;
  final String duration;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void beatcontrol(String action, String pduration, String pbpm) async {
    var bpm = int.parse(pbpm);
    var duration = int.parse(pduration);

    durationcounter.reset();
    beatcounter.reset();
    durationcounter.start();
    beatcounter.start();

    //TODO: find way to create beep instead of play mp3 due to delay.

    await player.setSource(AssetSource('metronome_basic_sound.mp3'));
    await player.resume();
    while (durationcounter.elapsedMilliseconds <= 1000 * duration) {
      if (beatcounter.elapsedMilliseconds == (60 / bpm) * 1000) {
        await player.setSource(AssetSource('metronome_basic_sound.mp3'));
        await player.resume();
        beatcounter.reset();
      }
    }

    durationcounter.reset();
    durationcounter.stop();
    beatcounter.stop();
  }

  TextEditingController contbpm = TextEditingController();
  TextEditingController contduration = TextEditingController();

  @override
  void initState() {
    contbpm.text = widget.bpm;
    contduration.text = widget.duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Press this button to start the metronome:',
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Duração do metrônomo',
                    border: OutlineInputBorder(),
                  ),
                  controller: contduration,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'BPM',
                    border: OutlineInputBorder(),
                  ),
                  controller: contbpm,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () =>
                        beatcontrol("start", contduration.text, contbpm.text),
                    tooltip: 'Play',
                    child: const Icon(Icons.play_arrow),
                  ),
                  FloatingActionButton(
                    onPressed: () => beatcontrol("stop", "0", "0"),
                    tooltip: 'Stop',
                    child: const Icon(Icons.stop),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
