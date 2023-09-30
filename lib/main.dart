import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    _speech = stt.SpeechToText();
    // TODO: implement initState
    // playsound();
    super.initState();
  }

  String _text = '';
  playsound() {
    final player = AudioPlayer();
    player.setAsset('music/welcome_optex.mp3');
    player.play();
    player.playerStateStream.listen((event) {
      if (player.processingState == ProcessingState.completed) {
        _listen();
      }
    });
  }

  void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_text',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              onPressed: () => playsound(),
              child: Icon(
                Icons.ac_unit,
                size: 50,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        //۱۲۳۴۵۶۷۸۹۱۰
        //  _speech.systemLocale() ;
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'fa_IR',
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _text = val.recognizedWords;

              print(_text);
            }
          }),
        );

        // تنظیم زبان به فارسی
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
