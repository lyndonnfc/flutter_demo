import 'package:flutter/material.dart';
import 'package:flutter_demo/constant/constants.dart';
import 'package:flutter_demo/widget/end_line.dart';
import 'package:flutter_demo/item/article_item.dart';
import 'package:flutter_demo/http/api.dart';
import 'package:flutter_demo/http/http_util.dart';

class ArticleListPage extends StatefulWidget {
  final String id;

  ArticleListPage(this.id);

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  int curPage = 0;
  Map<String,String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getArticleList();
    _scrollController.addListener((){
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getArticleList();
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
        key: PageStorageKey(widget.id),
        itemCount: listData.length,
        itemBuilder: (context,i) => buildItem(i),
        controller: _scrollController
      );

      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void _getArticleList() {
    String url = Api.ARTICLE_LIST;
    url += '$curPage/json';
    map['cid'] = widget.id;
    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;
        var _listData = map['datas'];
        listTotalSize = map['total'];

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
    _getArticleList();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = listData[i];
    if (i == listData.length - 1 && itemData.toString() == Constants.endLinTag) {
      return EndLine();
    }
    return ArticleItem(itemData);
  }
}
