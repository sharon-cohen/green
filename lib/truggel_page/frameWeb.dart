
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class FrameWeb extends StatefulWidget {
  FrameWeb ({Key key, this.title,this.Url}) : super(key: key);

  final String title;
  final String Url;
  @override
  _FrameWeb  createState() => _FrameWeb ();
}

class _FrameWeb  extends State<FrameWeb > {
  WebViewController controller;

  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();

  Future<void> _onWillPop(BuildContext context) async {
    print("onwillpop");
    if (await controller.canGoBack()) {
      controller.goBack();
    } else {
      controller.clearCache();

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
          backgroundColor: Colors.red,
        ),
        body: WebView(
          initialUrl: widget.Url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController c) {
            _controllerCompleter.future.then((value) => controller = value);
            _controllerCompleter.complete(c);
          },
        ),
      ),
    );
  }
}