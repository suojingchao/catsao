import 'package:intl/intl.dart';
import 'package:catsao/db/news_dao.dart';

class NewsItemEntity {

  static final TAG = 'NewsItemEnity';

  int id;
  String uniquekey;
  String title;
  int date;
  String category;
  String author;
  String url;
  String thumbnail0;
  String thumbnail1;
  String thumbnail2;
  String humanableDate;


  NewsItemEntity({this.uniquekey, this.title, this.humanableDate, this.category,
    this.author, this.url, this.thumbnail0, this.thumbnail1, this.thumbnail2}) {
    DateTime datetime = DateTime.parse(humanableDate);
    this.date = datetime.millisecondsSinceEpoch;
  }

  toMap() {
    Map map = {NewsDao.COLUMN_NAME_UNIQUEKEY: uniquekey, NewsDao.COLUMN_NAME_TITLE: title,
               NewsDao.COLUMN_NAME_DATE: date, NewsDao.COLUMN_NAME_CATEGORY: category,
               NewsDao.COLUMN_NAME_AUTHOR: author, NewsDao.COLUMN_NAME_URL: url,
               NewsDao.COLUMN_NAME_THUMBPIC0: thumbnail0, NewsDao.COLUMN_NAME_THUMBPIC1: thumbnail1,
               NewsDao.COLUMN_NAME_THUMBPIC2: thumbnail2};
    return map;
  }

  NewsItemEntity.fromMap(Map map) {
    id = map[NewsDao.COLUMN_NAME_ID];
    uniquekey = map[NewsDao.COLUMN_NAME_UNIQUEKEY];
    title = map[NewsDao.COLUMN_NAME_TITLE];
    date = map[NewsDao.COLUMN_NAME_DATE];
    category = map[NewsDao.COLUMN_NAME_CATEGORY];
    author = map[NewsDao.COLUMN_NAME_AUTHOR];
    url = map[NewsDao.COLUMN_NAME_URL];
    thumbnail0 = map[NewsDao.COLUMN_NAME_THUMBPIC0];
    thumbnail1 = map[NewsDao.COLUMN_NAME_THUMBPIC1];
    thumbnail2 = map[NewsDao.COLUMN_NAME_THUMBPIC2];
    var formatter = new DateFormat('yyyy-MM-dd HH:mm');
    humanableDate = formatter.format(new DateTime.fromMillisecondsSinceEpoch(date));

  }


}