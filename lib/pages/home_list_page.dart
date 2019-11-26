import 'package:flutter/material.dart';
import 'package:flutter_demo/constant/constants.dart';
import 'package:flutter_demo/http/api.dart';
import 'package:flutter_demo/http/http_util.dart';
import 'package:flutter_demo/widget/slide_view.dart';
import 'package:flutter_demo/widget/end_line.dart';
import 'package:flutter_demo/item/article_item.dart';

class HomeListPage extends StatefulWidget {
  @override
  _HomeListPageState createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {

  List listData = List();
  var bannerData;
  var curPage = 0;
  var listTotalSize = 0;

  ScrollController _scrollController = ScrollController();
  TextStyle titleTextStyle = TextStyle(fontSize: 15.0);
  TextStyle subTitleTextStyle = TextStyle(color:Colors.blue, fontSize: 12.0);

  _HomeListPageState(){
    _scrollController.addListener((){
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;

      if (maxScroll ==  pixels && listData.length < listTotalSize) {
        getHomeArticleList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBanner();
    getHomeArticleList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    getBanner();
    getHomeArticleList();
    return null;
  }

  SlideView _bannerView;
  void getBanner() {
    String bannerUrl = Api.BANNER;
    HttpUtil.get(bannerUrl, (data) {
      if (data != null) {
        setState(() {
          bannerData = data;
          _bannerView = SlideView(bannerData);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length + 1,
        itemBuilder: (context,i) => buildItem(i),
        controller: _scrollController,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Widget buildItem(int i) {
    if (i == 0) {
      return Container(
        height: 180.0,
        child: _bannerView,
      );
    }
    i -= 1;

    var itemData = listData[i];

    if (itemData is String && itemData == Constants.endLinTag) {
      return EndLine();
    }

    return ArticleItem(itemData);
  }



  void getHomeArticleList() {
    String url = Api.ARTICLE_LIST;
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
    });
  }
}
