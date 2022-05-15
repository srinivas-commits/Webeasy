import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatefulWidget {
  const WebViewClass({Key? key}) : super(key: key);

  @override
  State<WebViewClass> createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final FlutterTts flutterTts = FlutterTts();
  double pitch = 1.0;
  double rate = 0.5;
  bool _isPlaying = false;

  int _stackToView = 1;
  var currentUrl = "";
  var textualContent;

  final url =
      "http://extractorapi.com/api/v1/extractor/?apikey=c1c45e2157e673755dd4e79c7905639431ab2557&url=";

  void listenTospeech(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setQueueMode(1);
    var result;

    result = await flutterTts.speak(text);
  }

  void pauseSpeech() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void getText() async {
    int len, div = 0, i = 0;
    String text = "";
    try {
      // print("printing the urls");
      // print(url + currentUrl);
      final response = await get(Uri.parse(url + currentUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        textualContent = jsonData["text"];

        print("length: " + textualContent.toString().length.toString());
        len = textualContent.toString().length;
        if (len < 2000) {
          listenTospeech(textualContent.toString());
        } else {
          div = len ~/ 2000;
          text = textualContent.toString();

          for (i = 0; i <= div; i++) {
            var c = i + 1;
            try {
              // print("start at: $i");
              // print("end at: $c");
              if (c * 2000 < len) {
                listenTospeech(text.substring(i * 2000, 2000 * c));
              } else {
                listenTospeech(text.substring(i * 2000, len));
              }
            } catch (err) {
              ErrorSummary(err.toString());
              // print(err);
            }
          }
        }
      } else {
        ErrorSummary("error in response body");
        print("Hello at line 91");
        // print("error here in response");
        // print(response.body);
      }
    } catch (e) {
      ErrorSummary(e.toString());
      // print("Hello");
      // print(e.toString());
    }
  }

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webeasy'),
        leading: goBack(),
        actions: [_rate()],
      ),
      body: WebView(
        allowsInlineMediaPlayback: true,
        initialUrl: "https://www.google.com",
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: _handleLoad,
        onWebViewCreated: (WebViewController webViewController) {
          print("here line: 37");
          _controller.complete(webViewController);
        },
        gestureNavigationEnabled: true,
        onPageStarted: (url) {
          print("new object: $url");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          speechBtn(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget speechBtn() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          return FloatingActionButton(
            onPressed: () async {
              String? url;
              if (controller.hasData) {
                url = (await controller.data!.currentUrl())!;
              }
              setState(() {
                currentUrl = url!;
              });
              print(currentUrl);
              if (_isPlaying == false) {
                getText();
              } else if (_isPlaying == true) {
                pauseSpeech();
              }
            },
            child: _isPlaying ? Icon(Icons.pause) : Icon(Icons.volume_up),
          );
        });
  }

  Widget goBack() {
    flutterTts.stop();
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          return GestureDetector(
            onTap: () async {
              // print("go back pressed");
              await controller.data?.goBack();
            },
            child: const Icon(Icons.arrow_back),
          );
        });
  }

  Widget _rate() {
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $rate",
      activeColor: Colors.white,
    );
  }
}
