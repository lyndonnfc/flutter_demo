import 'package:flutter/material.dart';
import 'package:flutter_demo/http/api.dart';
import 'package:flutter_demo/http/http_util.dart';
import 'package:flutter_demo/constant/constants.dart';
import 'package:flutter_demo/widget/end_line.dart';
import 'package:flutter_demo/item/article_item.dart';

class SearchListPage extends StatefulWidget {
  String id;

  SearchListPage(ValueKey<String> key): super(key: key){
    this.id = key.value.toString();
  }

  @override
  _SearchListPageState createState() => _SearchListPageState();

}

class _SearchListPageState extends State<SearchListPage> {
  int curPage = 0;
  Map<String,String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener((){
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScroll ==  pixels && listData.length < listTotalSize) {
        _articleQuery();
      }
    });
    _articleQuery();
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
          itemCount: listData.length,
          itemBuilder: (context,i) => buildItem(i),
          controller: _scrollController
      );
      return RefreshIndicator(child: listView, onRefresh: pullToRefresh);
    }
  }

  void _articleQuery() {
    String url = Api.ARTICLE_QUERY;
    url += "$curPage/json";
    map['k'] = widget.id;
    HttpUtil.post(url, (data){
      if (data != null) {
        Map<String,dynamic> map = data;
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
    },params: map);
  }

  Future<Null> pullToRefresh() async {
    curPage = 0;
    _articleQuery();
    return null;
  }

  Widget buildItem(int i){
    var itemData = listData[i];
    if (i == listData.length - 1
        && itemData.toString() == Constants.endLinTag) {
      return EndLine();
    }
    return ArticleItem.isFromSearch(itemData, widget.id);
  }
}
