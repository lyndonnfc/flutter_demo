import 'package:flutter/material.dart';
import 'package:flutter_demo/constant/constants.dart';
import 'package:flutter_demo/pages/about_us_page.dart';
import 'package:flutter_demo/pages/collect_list_page.dart';
import 'package:flutter_demo/pages/login_page.dart';
import 'package:flutter_demo/event/login_event.dart';
import 'package:flutter_demo/util/DataUtils.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> with WidgetsBindingObserver{
  String userName;

  @override
  void initState() {
    super.initState();
    _getName();
    Constants.eventBus.on<LoginEvent>().listen((event) {
      _getName();
    });
  }

  void _getName() async {
    DataUtils.getUserName().then((username) {
      setState(() {
        userName = username;
        print('name:' + userName.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'images/ic_launcher_round.png',
      width: 100.0,
      height: 100.0,
    );

    Widget raisedButton = RaisedButton(
      child: Text(
        userName == null ? '请登录' : userName,
        style: TextStyle(color: Colors.white)
      ),
      color: Theme.of(context).accentColor,
      onPressed: () async {
        await DataUtils.isLogin().then((isLogin){
          if (!isLogin) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              }
            ));
          } else {
            print('已登录');
          }
        });
      }
    );

    Widget listLike = ListTile(
      leading: const Icon(Icons.favorite),
      title: const Text('喜欢的文章'),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).accentColor,
      ),
      onTap: () async {
        await DataUtils.isLogin().then((isLogin){
          if (isLogin) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return CollectListPage();
                }
            ));
          } else {
            print('未登录');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                }
            ));
          }
        });
      },
    );

    Widget listAbout = ListTile(
      leading: const Icon(Icons.info),
      title: const Text('关于我们'),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).accentColor
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return AboutUsPage();
            }
        ));
      },
    );

    Widget listLogout = ListTile(
      leading: const Icon(Icons.info),
      title: const Text('退出登录'),
      trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).accentColor
      ),
      onTap: () {
        DataUtils.clearLoginInfo();
        setState(() {
          userName = null;
        });
      },
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      children: <Widget>[
        image,
        raisedButton,
        listLike,
        listAbout,
        listLogout
      ],
    );
  }


}
