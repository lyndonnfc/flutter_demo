import 'package:flutter/material.dart';
import 'package:flutter_demo/http/api.dart';
import 'package:flutter_demo/http/http_util.dart';
import 'package:flutter_demo/constant/constants.dart';
import 'package:flutter_demo/widget/end_line.dart';
import 'package:flutter_demo/util/DataUtils.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_demo/pages/login_page.dart';

class CollectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('喜欢的文章'),
      ),
      body: CollectListPage(),
    );
  }
}

class CollectListPage extends StatefulWidget {
  CollectListPage();

  @override
  _CollectListPageState createState() => _CollectListPageState();
}

class _CollectListPageState extends State<CollectListPage> {
  int curPage = 0;
  Map<String,String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _scrollController = ScrollController();

  _CollectListPageState();

  @override
  void initState() {
    super.initState();
    _getCollectList();

    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getCollectList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null || listData.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: _scrollController,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void _getCollectList() {
    String url = Api.COLLECT_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;

        var _listData = map['datas'];

        listTotalSize = map["total"];

        setState(() {
          List list1 = List();
          if (curPage == 0) {
            listData.clear();
          }
          curPage++;

          list1.addAll(listData);
          list1.addAll(_listData);
          if (list1.length >= listTotalSize) {
            list1.add(Constants.endLinTag);
          }
          listData = list1;
        });
      }
    }, params: map);
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    _getCollectList();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = listData[i];

    if (i == listData.length - 1 &&
        itemData.toString() == Constants.endLinTag) {
      return EndLine();
    }

    Row row1 = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
              children: <Widget>[
                Text('作者:  '),
                Text(
                  itemData['author'],
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ],
            )),
        Text(itemData['niceDate'])
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            itemData['title'],
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Icon(
//            isCollect ? Icons.favorite : Icons.favorite_border,
//            color: isCollect ? Colors.red : null,
            Icons.favorite, color: Colors.red,
          ),
          onTap: () {
            _handleListItemCollect(itemData);
          },
        )
      ],
    );

    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: row1,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: title,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: chapterName,
        ),
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          _itemClick(itemData);
        },
        child: column,
      ),
    );
  }

  void _handleListItemCollect(itemData) {
    DataUtils.isLogin().then((isLogin) {
      if (!isLogin) {
        // 未登录
        _login();
      } else {
        _itemUnCollect(itemData);
      }
    });
  }

  _login() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }

  void _itemClick(var itemData) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(title: itemData['title'], url: itemData['link']);
    }));
  }

  //取消收藏
  void _itemUnCollect(var itemData) {
    String url;

    url = Api.UNCOLLECT_LIST;

    Map<String, String> map = Map();
    map['originId'] = itemData['originId'].toString();
    url = url + itemData['id'].toString() + "/json";
    HttpUtil.post(url, (data) {
      setState(() {
        listData.remove(itemData);
      });
    }, params: map);
  }

}
