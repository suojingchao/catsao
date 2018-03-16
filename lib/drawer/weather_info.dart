import 'dart:convert';
import 'package:http/http.dart';


class WeatherInfo {
  String country;
  String location;
  String tmp;
  String cond;
  String hum;
  String windDir;
  String windSc;
  String winSpd;

  WeatherInfo(Response response) {
    Map map = JSON.decode(response.body);
    print('result:' + map.toString());
    if (map.isNotEmpty) {
      List list = map['HeWeather6'];
      if (list.isNotEmpty) {
        Map inner = list[0];
        Map basic = inner['basic'];
        Map now = inner['now'];
        country = basic['cnty'];
        location = basic['location'];
        tmp = now['tmp'];
        cond = basic['cond_txt'];
        hum = now['hum'];
        windDir = basic['wind_dir'];
        windSc = now['wind_sc'];
        winSpd = basic['wind_spd'];
      }
    }
  }

}