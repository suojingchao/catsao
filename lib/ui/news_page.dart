import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:catsao/util/sp_helper.dart';
import 'package:catsao/loader/news_loader.dart';
import 'package:catsao/ui/refresh_page.dart';
import 'package:catsao/util/log_helper.dart';
import 'package:catsao/util/stirngs_helper.dart';
import 'package:catsao/entity/news_item_entity.dart';
import 'package:catsao/loader/loader.dart';
import 'package:catsao/ui/load_more_footer.dart';
/**
 * this page used to display news list. different type can reuse it.
 */
class NewsPage extends StatefulWidget {

  String tabName = null;
  NewsPage({this.tabName});

  @override
  State<StatefulWidget> createState() => new _NewsPageState();

}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  final String TAG = 'NewsPageState';
  List<NewsItemEntity> _newsItemInfo = [];
  String type = null;
  String spLoadTimeKey = null;
  int lastLoadTime = null;
  SharedPreferenceHelper spHelper = new SharedPreferenceHelper();
  NewsLoader newsLoader = null;

  // placeholder item for loadmore feature.
  NewsItemEntity loadMoreHolder = new NewsItemEntity(category: "loadmore", humanableDate: "1970-01-01 00:00");

  int _dataOffset = 0;
  int _dataLimit = 30;

  bool showRefresh = false;
  bool showLoading = true;
  bool showData = false;

  String footerText = StringResources.LOADMORE;
  int footerMode = LoadmoreFooter.MODE_LOADING;

  AnimationController animationController = null;
  Animation<double> animation = null;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  dispose() {
    animationController?.dispose();
    super.dispose();
  }

  _initData() async {
    switch (widget.tabName) {
      case StringResources.TAB_TOP_CN:
        type = 'top';
        spLoadTimeKey = SharedPreferenceHelper.KEY_TOP_LAST_LOADTIME;
        break;
      case StringResources.TAB_SH_CN:
        type = 'shehui';
        spLoadTimeKey = SharedPreferenceHelper.KEY_SH_LAST_LOADTIME;
        break;
      case StringResources.TAB_GN_CN:
        type = 'guonei';
        spLoadTimeKey = SharedPreferenceHelper.KEY_GN_LAST_LOADTIME;
        break;
      case StringResources.TAB_GJ_CN:
        type = 'guoji';
        spLoadTimeKey = SharedPreferenceHelper.KEY_GJ_LAST_LOADTIME;
        break;
      case StringResources.TAB_YL_CN:
        type = 'yule';
        spLoadTimeKey = SharedPreferenceHelper.KEY_YL_LAST_LOADTIME;
        break;
      case StringResources.TAB_TY_CN:
        type = 'tiyu';
        spLoadTimeKey = SharedPreferenceHelper.KEY_TY_LAST_LOADTIME;
        break;
      case StringResources.TAB_JS_CN:
        type = 'junshi';
        spLoadTimeKey = SharedPreferenceHelper.KEY_JS_LAST_LOADTIME;
        break;
      case StringResources.TAB_KJ_CN:
        type = 'keji';
        spLoadTimeKey = SharedPreferenceHelper.KEY_KJ_LAST_LOADTIME;
        break;
      case StringResources.TAB_CJ_CN:
        type = 'caijing';
        spLoadTimeKey = SharedPreferenceHelper.KEY_CJ_LAST_LOADTIME;
        break;
      case StringResources.TAB_SS_CN:
        type = 'shishang';
        spLoadTimeKey = SharedPreferenceHelper.KEY_SS_LAST_LOADTIME;
        break;
    }
    Map<String, String> options = {
      'type': type,
      'spLoadTimeKey': spLoadTimeKey,
      'tabName': widget.tabName
    };
    newsLoader = new NewsLoader(options);
    await newsLoader.init();
    _loadData(DataSource.DEFAULT);
  }

  _loadData(DataSource datasource) async {
    _newsItemInfo.remove(loadMoreHolder);
    List<NewsItemEntity> tempData = await newsLoader.loadData(
      datasource: datasource,
      offset: _dataOffset,
      limit: _dataLimit
    );
    if (tempData != null) {
      Log.i(TAG, 'tempData.length=${tempData.length}');
      if (datasource == DataSource.NETWORK) {
        _newsItemInfo.clear();
        _dataOffset = tempData.length;
      } else {
        _dataOffset += _dataLimit;
      }
      _newsItemInfo.addAll(tempData);
      _newsItemInfo.add(loadMoreHolder);
      _newsItemInfo.sort(_compareNews);
      for (int i = 0 ; i < _newsItemInfo.length ; i++) {
        Log.i(TAG, '_newsItemInfo[$i].date=${_newsItemInfo[i].date}');
      }
    } else {
      if (datasource == DataSource.DATABASE) {
        footerText = StringResources.NO_MORE;
        footerMode = LoadmoreFooter.MODE_NO_MORE;
      }
    }
    setState(() {
      if (_newsItemInfo.length > 1) {
        Log.i(TAG, 'DataMode');
        showData = true;
        showRefresh = false;
        showLoading = false;
      } else {
        Log.i(TAG, 'RefreshMode');
        showRefresh = true;
        showData = false;
        showLoading = false;
      }
    });
  }

  _generateItem(BuildContext context, int position) {
    Log.i(TAG, 'generateItem position is $position');
    if (position == _newsItemInfo.length - 1) {
      return _generateLoadMoreItem();
    } else if (_newsItemInfo[position].thumbnail0 != null &&
      _newsItemInfo[position].thumbnail1 != null &&
      _newsItemInfo[position].thumbnail2 != null) {
      return _generateThreePicItem(position);
    } else {
      return _generateOnePicItem(position);
    }
  }

  _generateLoadMoreItem() {
    return new LoadmoreFooter(
      text: footerText,
      loadWorker: _loadData,
      mode: footerMode
    );
  }

  _generateOnePicItem(int position) {
    return new GestureDetector(
      onTap: () {
        _launchURL(_newsItemInfo[position].url);
      },
      child: new Card(
        child: new Material(
          child: new InkWell(
            child: new Container(
              padding: const EdgeInsets.all(15.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: new Text(
                        _newsItemInfo[position].title,
                        style: new TextStyle(
                            fontSize: 20.0
                        ),
                      )
                  ),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          padding: const EdgeInsets.all(3.0),
                          child: new SizedBox(
                            child: new Image.network(
                              _newsItemInfo[position].thumbnail0,
                              fit: BoxFit.fitWidth,
                            ),
                            height: 200.0,
                          )
                        )
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                          padding: const EdgeInsets.all(3.0),
                          child: new Text(
                            _newsItemInfo[position].humanableDate,
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey
                            ),
                          )
                      ),
                      new Container(
                          padding: const EdgeInsets.all(3.0),
                          child: new Text(
                            _newsItemInfo[position].author,
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          color: Colors.transparent
        ),
      ),
    );
  }

  _generateThreePicItem(int position) {
    return new GestureDetector(
      onTap: () {
        _launchURL(_newsItemInfo[position].url);
      },
      child: new Card(
        child: new Container(
          padding: const EdgeInsets.all(15.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: new Text(
                    _newsItemInfo[position].title,
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  )
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new Container(
                          padding: const EdgeInsets.all(4.0),
                          child: new Image.network(_newsItemInfo[position].thumbnail0)
                      )
                  ),
                  new Expanded(
                      child: new Container(
                          padding: const EdgeInsets.all(4.0),
                          child: new Image.network(_newsItemInfo[position].thumbnail1)
                      )
                  ),
                  new Expanded(
                      child: new Container(
                          padding: const EdgeInsets.all(4.0),
                          child: new Image.network(_newsItemInfo[position].thumbnail2)
                      )
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.all(3.0),
                      child: new Text(
                        _newsItemInfo[position].humanableDate,
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey
                        ),
                      )
                  ),
                  new Container(
                      padding: const EdgeInsets.all(3.0),
                      child: new Text(
                        _newsItemInfo[position].author,
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey
                        ),
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  _compareNews(NewsItemEntity pre, NewsItemEntity post) {
    int result = 0;
    if (pre == null && post == null) {
      result = 0;
    } else if (pre != null && post != null) {
      if (pre.date == post.date) {
        result = 0;
      } else if (pre.date > post.date) {
        result = -1;
      } else {
        result = 1;
      }
    } else if (pre != null) {
      result = 1;
    } else if (post != null) {
      result = -1;
    } else {
      result = 0;
    }
    return result;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _generateBody() {
    if (showLoading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else if (showRefresh) {
      return new RefreshPage(
          onTap: () async {
            Log.i(TAG, 'LoadingMode');
            setState(() {
              showLoading = true;
              showRefresh = false;
              showData = false;
            });
            _loadData(DataSource.NETWORK);
          }
      );
    } else {
      Log.i(TAG, '_newsItemInfo.data.length=${_newsItemInfo.length}');
      return new RefreshIndicator(
        child: new ListView.builder(
            itemCount: _newsItemInfo.length,
            itemBuilder: _generateItem
        ),
        onRefresh: () async {
          await _loadData(DataSource.NETWORK);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Log.i(TAG, 'build');
    return _generateBody();
  }

}