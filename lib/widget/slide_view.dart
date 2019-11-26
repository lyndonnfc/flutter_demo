import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';

class SlideView extends StatefulWidget {
  var data;

  SlideView(this.data);

  @override
  _SlideViewState createState() => _SlideViewState(data);
}

class _SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin{
  TabController _tabController;
  List data;
  int virtualIndex = 0;
  _SlideViewState(this.data);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: data == null ? 0: data.length,
        vsync: this
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (data != null && data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        virtualIndex = i;
        var item = data[i];
        var imgUrl = item['imagePath'];
        var title = item['title'];
        item['link'] = item['url'];
        items.add(new GestureDetector(
          onTap: () {
            _handOnItemClick(item);
          },
          child: AspectRatio(
            aspectRatio: 2.0 / 1.0,
            child: new Stack(
              children: <Widget>[
                Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    width: 1000.0
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: 1000.0,
                    color: const Color(0x50000000),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        title,
                        style: TextStyle(color: Colors.white,fontSize: 15.0)
                    )
                  ),
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child:  _buildIndicator()
                ),
              ],
            ),
          ),
        ));
      }
    }

    return TabBarView(
        controller: _tabController,
        children: items
    );
  }

  Widget _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < widget.data.length; i++) {
      indicators.add(Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == virtualIndex ? Colors.blue : Colors.white)));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: indicators);
  }

  void _handOnItemClick (itemData) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) {
          return ArticleDetailPage(
              title: itemData['title'],
              url: itemData['link']
          );
        }
    ));
  }

}
