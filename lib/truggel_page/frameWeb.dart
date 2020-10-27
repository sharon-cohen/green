import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final webViewKey = GlobalKey<_FrameWeb>();

class FrameWeb extends StatefulWidget {
  FrameWeb({Key key, this.title, this.Url, this.fromFooter}) : super(key: key);
  final fromFooter;
  final String title;
  final String Url;

  @override
  _FrameWeb createState() => _FrameWeb();
}

class _FrameWeb extends State<FrameWeb> {
  String url = "https://flutter.dev/";

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged>
      _onchanged; // here we checked the url state if it loaded or start Load or abort Load

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          // if the full website page loaded
          print("loaded...");
        } else if (state.type == WebViewState.abortLoad) {
          // if there is a problem with loading the url
          print("there is a problem...");
        } else if (state.type == WebViewState.startLoad) {
          // if the url started loading
          print("start loading...");
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebviewPlugin
        .dispose(); // disposing the webview widget to avoid any leaks
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.Url,
        withJavascript: false, // run javascript
        withZoom: false, // if you want the user zoom-in and zoom-out
        hidden:
            true, // put it true if you want to show CircularProgressIndicator while waiting for the page to load
        withLocalStorage: true,
        appBar: AppBar(
          title: Text(widget.title.toString()),
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: widget.fromFooter == false
              ? new IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                )
              : Container(),
          elevation: 1, // give the appbar shadows
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.refresh),
              onTap: () {
                flutterWebviewPlugin.reload();
                // flutterWebviewPlugin.reloadUrl(); // if you want to reloade another url
              },
            ),
            InkWell(
              child: Icon(Icons.stop),
              onTap: () {
                flutterWebviewPlugin.stopLoading(); // stop loading the url
              },
            ),
            // InkWell(
            //   child: Icon(Icons.remove_red_eye),
            //   onTap: () {
            //     flutterWebviewPlugin.show(); // appear the webview widget
            //   },
            // ),
            // InkWell(
            //child: Icon(Icons.close),
            //   onTap: () {
            //     flutterWebviewPlugin.hide(); // hide the webview widget
            //   },
            // ),
            InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () {
                flutterWebviewPlugin.goBack(); // for going back
              },
            ),
            InkWell(
              child: Icon(Icons.forward),
              onTap: () {
                flutterWebviewPlugin.goForward(); // for going forward
              },
            ),
          ], // make the icons colors inside appbar with white color
        ),
        initialChild: Container(
          // but if you want to add your own waiting widget just add InitialChild
          color: Colors.white,
          child: const Center(
            child: Text('waiting...'),
          ),
        ));
  }
}
