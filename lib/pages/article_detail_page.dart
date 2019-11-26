import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String url;


  ArticleDetailPage(
      {
        Key key,
        @required this.title,
        @required this.url
      }
  ):super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final fluttearrWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    fluttearrWebViewPlugin.onDestroy.listen((_){
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
