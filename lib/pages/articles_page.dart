import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/article_list_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ArticlesPage extends StatefulWidget {
  final data;

  ArticlesPage(this.data);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = List();
  List<dynamic> list;

  @override
  void initState() {
    super.initState();

    list = widget.data['children'];

    for (var value in list) {
      tabs.add(Tab(text: value['name']));
    }

    _tabController = TabController(length: list.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: DefaultTabController(
        length: list.length,
        child: Scaffold(
          appBar: TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: Theme.of(context).accentColor,
            tabs: tabs,
          ),
          body: TabBarView(
            children: list.map((dynamic itemData){
              return ArticleListPage(itemData['id'].toString());
            }).toList(),
            controller: _tabController,
          ),
        )
      ),
    );
  }
}
