import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      'images/ic_launcher_round.png',
      width: 100.0,
      height: 100.0
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        children: <Widget>[
          icon,
          ListTile(
            title: const Text('关于项目'),
            subtitle: const Text('第一个flutter学习项目'),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).accentColor
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return ArticleDetailPage(
                    title: 'WanAndroid_Flutter版',
                    url: 'https://github.com/lyndonnfc/flutter_demo'
                );
              }));
            },
          )
        ],
      ),
    );
  }
}
