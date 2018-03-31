import 'dart:async';

import 'package:catsao/entity/news_item_entity.dart';
import 'package:catsao/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NewsDao {
  static final String TABLE_NAME = 'news';
  static final String COLUMN_NAME_ID = 'id';
  static final String COLUMN_NAME_UNIQUEKEY = 'uniquekey';
  static final String COLUMN_NAME_TITLE = 'title';
  static final String COLUMN_NAME_DATE = 'date';
  static final String COLUMN_NAME_CATEGORY = 'category';
  static final String COLUMN_NAME_AUTHOR = 'author';
  static final String COLUMN_NAME_URL = 'url';
  static final String COLUMN_NAME_THUMBPIC0 = 'thumbpic0';
  static final String COLUMN_NAME_THUMBPIC1 = 'thumbpic1';
  static final String COLUMN_NAME_THUMBPIC2 = 'thumbpic2';

  final String CREATE_TABLE = '''
              CREATE TABLE ${TABLE_NAME} (${COLUMN_NAME_ID} INTEGER PRIMARY KEY, ${COLUMN_NAME_UNIQUEKEY} TEXT UNIQUE ON CONFLICT IGNORE, 
              ${COLUMN_NAME_TITLE} TEXT, ${COLUMN_NAME_DATE} INTEGER, ${COLUMN_NAME_CATEGORY} TEXT,
              ${COLUMN_NAME_AUTHOR} TEXT, ${COLUMN_NAME_URL} TEXT, ${COLUMN_NAME_THUMBPIC0} TEXT,
              ${COLUMN_NAME_THUMBPIC1} TEXT, ${COLUMN_NAME_THUMBPIC2} TEXT);
              ''';

  static NewsDao _instance = new NewsDao._internal();

  Database db = null;

  NewsItemEntity entity = null;

  factory NewsDao() {
    return _instance;
  }

  NewsDao._internal() {
  }

  onCreate(Database db, int version) async {
    await db.execute(CREATE_TABLE);
  }

  onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  insert(NewsItemEntity news) async {
    if (db == null) {
      await new DBHelper().initDB();
      db = new DBHelper().db;
    }
    news.id = await db.insert(TABLE_NAME, news.toMap());
    return news;
  }

  insertBatch(List<NewsItemEntity> items) async {
    if (db == null) {
      await new DBHelper().initDB();
      db = new DBHelper().db;
    }
    Batch batch = db.batch();
    for (int i = 0 ; i < items.length ; i++) {
      batch.insert(TABLE_NAME, items[i].toMap());
    }
    await batch.commit();
  }

  Future<NewsItemEntity> getNews(String uniquekey) async {
    if (db == null) {
      await new DBHelper().initDB();
      db = new DBHelper().db;
    }
    List<Map> maps = await db.query(TABLE_NAME,
      where: "$COLUMN_NAME_UNIQUEKEY = ?",
      whereArgs: [uniquekey]);
    if (maps.length > 0) {
      return new NewsItemEntity.fromMap(maps.first);
    }
    return null;
  }

  Future<List<NewsItemEntity>> getNewsByOffset(String type, int offset, int limit, {newsDate: 0}) async {
    if (db == null) {
      await new DBHelper().initDB();
      db = new DBHelper().db;
    }
    List<Map> maps = await db.query(
      TABLE_NAME,
      where: '${COLUMN_NAME_CATEGORY}=? and ${COLUMN_NAME_DATE}>?',
      whereArgs: [type, newsDate],
      offset: offset,
      limit: limit
    );
    if (maps.length > 0) {
      List<NewsItemEntity> result = [];
      for (int i = 0 ; i < maps.length ; i++) {
        result.add(new NewsItemEntity.fromMap(maps[i]));
      }
      return result;
    }
    return null;
  }

  Future<int> delete(String uniquekey) async {
    if (db == null) {
      await new DBHelper().initDB();
      db = new DBHelper().db;
    }
    return await db.delete(TABLE_NAME, where: "$COLUMN_NAME_UNIQUEKEY = ?", whereArgs: [uniquekey]);
  }

  Future<int> update(NewsItemEntity news) async {
    if (db == null) {
      await new DBHelper().initDB();
      db = new DBHelper().db;
    }
    return await db.update(TABLE_NAME, news.toMap(),
        where: "$COLUMN_NAME_UNIQUEKEY = ?", whereArgs: [news.id]);
  }

  Future close() async => db.close();
}