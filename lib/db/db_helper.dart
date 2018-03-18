import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'news_dao.dart';

class DBHelper {

  static final DBHelper _singleton = new DBHelper._internal();
  Database db = null;

  NewsDao newsDao = null;

  factory DBHelper() {
    return _singleton;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "catsao.db");

    newsDao = new NewsDao();

    db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
      );
  }

  _onCreate(Database db, int version) {
    newsDao.onCreate(db, version);

  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    newsDao.onUpgrade(db, oldVersion, newVersion);
  }

  DBHelper._internal() {
  }

}