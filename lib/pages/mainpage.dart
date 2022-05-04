import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:webeasy/pages/webview.dart';

class MainController extends StatefulWidget {
  String title;
  MainController({Key? key, required this.title}) : super(key: key);

  @override
  State<MainController> createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Column(children: [
        GestureDetector(
          onTap: () async {
            await flutterTts.setLanguage('en-US');
            await flutterTts.setPitch(1);
            await flutterTts.speak('Browser For Audio');
          },
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WebViewClass()),
            );
          },
          child: Container(
            color: Colors.blueGrey,
            width: width,
            height: height / 2,
            alignment: Alignment.center,
            child: const Text(
              'Browser For Audio',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await flutterTts.setLanguage('en-US');
            await flutterTts.setPitch(1);
            await flutterTts.speak('Browser For Braille');
          },
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WebViewClass()),
            );
          },
          child: Container(
            color: Colors.blueGrey[400],
            width: width,
            height: height / 2,
            alignment: Alignment.center,
            child: const Text(
              'Browser For Braille',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ]),
    ));
  }
}
