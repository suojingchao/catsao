import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'loader.dart';
import '../entity/news_item_entity.dart';
import '../util/sp_helper.dart';
import '../db/news_dao.dart';
import '../util/log_helper.dart';

class NewsLoader extends Loader<NewsItemEntity> {

  static NewsLoader _instatnce = new NewsLoader._internal();
  static String type = null;
  static String spLoadTimeKey = null;
  static String tabName = null;

  final String TAG = 'NewsLoader';
  final String JUHE_API_KEY = '3a86f36bd3ecac8a51135ded5eebe862';
  final String NEWS_URL = 'http://v.juhe.cn/toutiao/index?';
  int lastLoadTime = null;
  List<NewsItemEntity> data = [];

  factory NewsLoader(Map<String, String> options) {
    type = options['type'];
    spLoadTimeKey = options['spLoadTimeKey'];
    tabName = options['tabName'];
    return _instatnce;
  }

  SharedPreferenceHelper spHelper = null;

  NewsLoader._internal() {
    spHelper = new SharedPreferenceHelper();
  }

  @override
  Future<List<NewsItemEntity>> loadData() async {
    if (data != null) {
      data.clear();
    } else {
      data = [];
    }
    lastLoadTime = spHelper.getInt(spLoadTimeKey);
    Log.i(TAG, 'news type ${tabName}, lastLoadTime=${lastLoadTime}');
    try {
      if (lastLoadTime == null || new DateTime.now().millisecondsSinceEpoch - lastLoadTime > 1000 * 60 * 60) {
        await _loadDataFromNetwork();
      } else {
        await _loadDataFromDB();
      }
    } catch(ex) {
      Log.i(TAG, ex.toString());
      data = null;
    }
    return data;
  }

  init() async {
    await spHelper.init();
  }

  _formatUrl() {
    return '${NEWS_URL}type=${type}&key=${JUHE_API_KEY}';
  }

  _loadDataFromDB() async {
    data = await new NewsDao().getNewsByOffset(tabName, 0, 30);
  }

  _loadDataFromNetwork() async {
    http.Response response = await http.get(_formatUrl());
    Log.i(TAG, 'news type ${tabName} response :\n ${response.body}');
    _parseResponse(response);
    new NewsDao().insertBatch(data);
    spHelper.setInt(spLoadTimeKey, new DateTime.now().millisecondsSinceEpoch);
  }

  _parseResponse(http.Response response) {
    Map map = JSON.decode(response.body);
    Map result = map['result'];
    String stat = result['stat'];
    if (stat.compareTo('1') == 0) {
      Log.i(TAG, 'stat == 1, this respones is ok!');
      List d = result['data'];
      for (int i = 0 ; i < d.length ; i++) {
        Map item = d[i];
        data.add(new NewsItemEntity(
            uniquekey: item['uniquekey'],
            title: item['title'],
            date: item['date'],
            category: item['category'],
            author: item['author_name'],
            url: item['url'],
            thumbnail0: item['thumbnail_pic_s'],
            thumbnail1: item['thumbnail_pic_s02'],
            thumbnail2: item['thumbnail_pic_s03']
        ));
      }
    }
    Log.i(TAG, 'parseReponse data: ${data.length}');
  }
}