import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'lifestyle_entity.dart';
import 'lifestyle_info.dart';
import 'weather_info.dart';

class DrawerHome extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => new DrawerHomeState();

}

class DrawerHomeState extends State<DrawerHome> {
  static const String _API_KEY = '616f06eea4844970a1e8a9a27566f767';
  String _nowWeatherUrl = 'https://free-api.heweather.com/s6/weather/now?';
  String _lifeStyleUrl = 'https://free-api.heweather.com/s6/weather/lifestyle?';
  Map<String, double> _currentLocation;
  WeatherInfo _weatherInfo = null;
  LifestyleInfo _lifestyleInfo = null;
  _initLocation() async {
    _currentLocation = <String, double>{};

    var location = new Location();

    try {
      _currentLocation = await location.getLocation;
      _getWeatherInfo();
      _getLifeStyle();
      print(_currentLocation);
    } on PlatformException {
      _currentLocation = null;
    }

  }

  _formatUrl(url) {
    url = url + 'location=' + _currentLocation['longitude'].toString() + ',' +  _currentLocation['latitude'].toString() + '&key=' + _API_KEY;
    return url;
  }

  _getWeatherInfo() async {
    http.Response response = await http.get(_formatUrl(_nowWeatherUrl));
    setState(() {
      _weatherInfo = new WeatherInfo(response);
    });

  }

  _getLifeStyle() async {
    http.Response response = await http.get(_formatUrl(_lifeStyleUrl));
    setState(() {
      _lifestyleInfo = new LifestyleInfo(response);
      print('data.length=${_lifestyleInfo.data.length}');
    });

  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  _generateLifestyleItem(LifestyleEntity item) {
    return new Column(
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Text(
                item.name,
                style: new TextStyle(
                    fontSize: 20.0
                ),
              ),
              new Text(
                _lifestyleInfo == null ? 'loading' : item.shortDes,
                style: new TextStyle(
                    fontSize: 24.0
                ),
              )
            ]
        )
        /*new Row(
          children: <Widget>[
            new Text(
              item.des,
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey
              ),
            )
          ],
        )*/
      ],
    );
  }

  _generateWeatherItem() {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Text(
                _weatherInfo == null ? 'loading' : _weatherInfo.location,
                style: new TextStyle(
                    fontSize: 24.0
                ),
              ),
              new Text(
                _weatherInfo == null ? 'loading' : _weatherInfo.tmp,
                style: new TextStyle(
                    fontSize: 28.0
                ),
              )
            ],
          ),
          new SizedBox(
            width: 60.0,
            height: 60.0,
            child: new Image.asset("assets/weather-sunny.png"),
          ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Drawer(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset("assets/flutter_bg.png"),
            new Container(
                padding: const EdgeInsets.all(12.0),
                child: new Column(
                  children: <Widget>[
                    _generateWeatherItem(),
                    new ListView.builder(
                      itemCount: _lifestyleInfo == null ? 0 : _lifestyleInfo.data.length,
                      itemBuilder: (BuildContext context, int position) {
                        return _generateLifestyleItem(_lifestyleInfo.data[position]);
                      }
                    )
                  ]
                )

            )
          ],
        )
    );
  }
}