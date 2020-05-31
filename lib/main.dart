import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Number Reader',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TtsState ttsState;
  FlutterTts flutterTts;
  dynamic languages;
  List<bool> selections = [ true, false ];

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
    ttsState = TtsState.stopped;

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _setLanguage(lang) async {
    await flutterTts.setLanguage(lang);
  }

  Future _speak() async {
    await flutterTts.setVolume(1.0);
    // await flutterTts.setSpeechRate(1.0);
    // await flutterTts.setPitch(1.0);

    var result = await flutterTts.speak('$_counter');
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  get isPlaying => ttsState == TtsState.playing;

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Number Reader'),
      ),
      body: new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new SizedBox(
                width: 100.0,
                height: 100.0,
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ToggleButtons(
                        children: [
                          new Image.asset(
                            'icons/flags/png/gb.png',
                            package: 'country_icons',
                            fit: BoxFit.fill,
                          ),
                          new Image.asset(
                            'icons/flags/png/tr.png',
                            package: 'country_icons',
                            fit: BoxFit.fill,
                          )
                        ],
                        onPressed: (int index) {
                          setState(() {
                            selections.setAll(0, [ false, false ]);
                            selections[index] = true;
                          });
                          if (index==0) {
                            _setLanguageEnglish();
                          } else {
                            _setLanguageTurkish();
                          }

                        },
                        isSelected: selections,
                        selectedBorderColor: Colors.lightBlueAccent,
                        selectedColor: Colors.blue
                      )
                    ]),
              ),
              new SizedBox(
                width: 100.0,
                height: 100.0,
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '$_counter',
                        style: new TextStyle(
                            fontSize: 50.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      )
                    ]),
              ),
              new SizedBox(
                width: 100.0,
                height: 100.0,
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: ttsState == TtsState.playing ? null : decrementButtonPressed,
                        iconSize: 48.0,
                        color: const Color(0xFF000000),
                      ),
                      new IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: ttsState == TtsState.playing ? null : incrementButtonPressed,
                        iconSize: 48.0,
                        color: const Color(0xFF000000),
                      )
                    ]),
              )
            ]),
        alignment: Alignment.center,
      ),
    );
  }

  void decrementButtonPressed() {
    if (ttsState == TtsState.stopped) setState(() {
      _counter--;
      _speak();
    });
  }
  void incrementButtonPressed() {
    if (ttsState == TtsState.stopped) setState(() {
      _counter++;
      _speak();
    });
  }
  void _setLanguageEnglish() {
    _setLanguage('en-GB');
    if (ttsState == TtsState.stopped) setState(() {
      _speak();
    });
  }
  void _setLanguageTurkish() {
    _setLanguage('tr-TR');
    if (ttsState == TtsState.stopped) setState(() {
      _speak();
    });
  }
}
