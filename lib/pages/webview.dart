import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatefulWidget {
  const WebViewClass({Key? key}) : super(key: key);

  @override
  State<WebViewClass> createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Webeasy'),
        ),
        body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            children: [
              Expanded(
                child: WebView(
                  allowsInlineMediaPlayback: true,
                  initialUrl: "https://www.google.com",
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: _handleLoad,
                  onWebViewCreated: (WebViewController webViewController) {
                    if (kDebugMode) {
                      print(webViewController.getTitle());
                    }
                    _controller.complete(webViewController);
                  },
                ),
              ),
            ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
