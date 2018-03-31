import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:catsao/loader/loader.dart';
import 'package:catsao/entity/weather_entity.dart';
import 'package:catsao/util/sp_helper.dart';
import 'package:catsao/util/log_helper.dart';

class WeatherLoader extends Loader<WeatherEntity> {

  static WeatherLoader _instatnce = new WeatherLoader._internal();
  static const String _API_KEY = '616f06eea4844970a1e8a9a27566f767';

  final String WEATHER_URL = 'https://free-api.heweather.com/s6/weather/now?';
  final String TAG = 'WeatherLoader';

  int lastLoadTime = null;
  Map<String, double> _currentLocation;
  List<WeatherEntity> data = null;

  factory WeatherLoader() {
    return _instatnce;
  }

  SharedPreferenceHelper spHelper = null;

  WeatherLoader._internal() {
    spHelper = new SharedPreferenceHelper();
  }

  @override
  Future<List<WeatherEntity>> loadData({DataSource datasource: DataSource.DEFAULT, int offset, int limit}) async {
    if (data != null) {
      data.clear();
    } else {
      data = [];
    }
    lastLoadTime = spHelper.getInt(SharedPreferenceHelper.KEY_WEATHER_LAST_LOADTIME);
    try {
      if (lastLoadTime == null || new DateTime.now().millisecondsSinceEpoch - lastLoadTime > 1000 * 60 * 60) {
        await _loadDataFromNetwork();
      } else {
        await _loadDataFromSP();
      }
    } catch(ex) {
      Log.i(TAG, ex.toString());
      data = null;
    }
    return data;
  }

  init() async {
    await spHelper.init();
    _currentLocation = <String, double>{};
    var location = new Location();

    try {
      _currentLocation = await location.getLocation;
      Log.i(TAG, _currentLocation.toString());
    } on PlatformException {
      _currentLocation = null;
    }
  }

  _formatUrl() {
    Log.i(TAG, '${WEATHER_URL}location=${_currentLocation['longitude']},${_currentLocation['latitude']}&key=${_API_KEY}');
    return '${WEATHER_URL}location=${_currentLocation['longitude']},${_currentLocation['latitude']}&key=${_API_KEY}';
  }

  _loadDataFromNetwork() async {
    http.Response response = await http.get(_formatUrl());
    _parseResponse(response);
    spHelper.setStringList(SharedPreferenceHelper.KEY_WEATHER_INFO, data[0].toList());
    spHelper.setInt(SharedPreferenceHelper.KEY_WEATHER_LAST_LOADTIME, new DateTime.now().millisecondsSinceEpoch);
  }

  _loadDataFromSP() async {
    List<String> cache = spHelper.getStringList(SharedPreferenceHelper.KEY_WEATHER_INFO);
    if (cache != null) {
      WeatherEntity weatherInfo = new WeatherEntity.fromSP(cache);
      data.add(weatherInfo);
    }
  }

  _parseResponse(http.Response response) {
    Map map = JSON.decode(response.body);
    Log.i(TAG, 'result:' + map.toString());
    if (map.isNotEmpty) {
      List list = map['HeWeather6'];
      if (list.isNotEmpty) {
        Map inner = list[0];
        Map basic = inner['basic'];
        Map now = inner['now'];
        data.add(
            new WeatherEntity(
                country: basic['cnty'],
                location: basic['location'],
                tmp: now['tmp'],
                cond: basic['cond_txt'],
                hum: now['hum'],
                windDir: basic['wind_dir'],
                windSc: now['wind_sc'],
                windSpd: basic['wind_spd'],
                statusCode: now['cond_code'],
                statusTxt: now['cond_txt']
            )
        );
      }
    }
  }

}