import 'package:flutter/material.dart';
import 'package:catsao/ui/drawer_page.dart';
import 'package:catsao/ui/news_page.dart';
import 'package:catsao/util/stirngs_helper.dart';

/**
 * home page of application.
 */
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: StringResources.APP_NAME,
      theme: new ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: new HomePage(title: StringResources.APP_NAME),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<Text> tabTexts = <Text>[
      new Text(
          StringResources.TAB_TOP_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_SH_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_GN_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_GJ_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_YL_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_TY_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_JS_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_KJ_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_CJ_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      ),
      new Text(
          StringResources.TAB_SS_CN,
          style: new TextStyle(
              fontSize: 20.0
          )
      )
    ];
    final List<Tab> tabs = [];
    for (int i = 0 ; i < tabTexts.length ; i++) {
      tabs.add(
        new Tab(
          child: tabTexts[i],
        )
      );
    }

    return new DefaultTabController(
        length: tabs.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(
                widget.title
            ),
            bottom: new TabBar(
              isScrollable: true,
              tabs: tabs,

            ),
          ),
          body: new TabBarView(
              children: tabTexts.map((Text tab) {
                return new Center(
                  child: new NewsPage(
                    tabName: tab.data,
                  )
                );
              }).toList()
          ),
          drawer: new DrawerPage(),
        )
    );
  }
}