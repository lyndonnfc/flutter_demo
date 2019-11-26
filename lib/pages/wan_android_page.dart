import 'package:flutter/material.dart';
import 'package:flutter_demo/constant/colors.dart';
import 'package:flutter_demo/pages/home_list_page.dart';
import 'package:flutter_demo/pages/search_page.dart';
import 'package:flutter_demo/pages/myInfo_page.dart';
import 'package:flutter_demo/pages/tree_page.dart';

class WanAndroidApp extends StatefulWidget {
  @override
  _WanAndroidAppState createState() => _WanAndroidAppState();
}

class _WanAndroidAppState extends State<WanAndroidApp> {

  int _tabIndex = 0;

  List<BottomNavigationBarItem> _navigationViews;

  var appBarTitles = ['首页','发现','我的'];

  var _body;

  initData() {
    _body = IndexedStack(
      children: <Widget>[HomeListPage(),TreePage(),MyInfoPage()],
      index: _tabIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    _navigationViews = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        title: Text(appBarTitles[0]),
        backgroundColor: Colors.blue
      ),
      BottomNavigationBarItem(
          icon: const Icon(Icons.widgets),
          title: Text(appBarTitles[1]),
          backgroundColor: Colors.blue
      ),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          title: Text(appBarTitles[2]),
          backgroundColor: Colors.blue
      )
    ];
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: AppColors.colorPrimary,
        accentColor: Colors.blue
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles[_tabIndex],
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  navigatorKey.currentState.push(MaterialPageRoute(builder: (context){
                    return SearchPage(null);
                  }));
                }
            )
          ],
        ),
        body: _body,
        bottomNavigationBar: BottomNavigationBar(
            items: _navigationViews.map((BottomNavigationBarItem navigationVew) => navigationVew).toList(),
            currentIndex: _tabIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index){
              setState(() {
                _tabIndex = index;
              });
            },
        ),
      ),
    );
  }
}
