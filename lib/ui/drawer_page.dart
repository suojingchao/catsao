import 'package:flutter/material.dart';
import 'package:catsao/util/sp_helper.dart';
import 'package:catsao/loader/weather_loader.dart';
import 'package:catsao/util/log_helper.dart';

import 'package:catsao/entity/weather_entity.dart';

import 'package:flutter/rendering.dart';

/**
 * this page used to display a drawer on the left of screen.
 */
class DrawerPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _DrawerPageState();

}

class _DrawerPageState extends State<DrawerPage> {
  final String TAG = 'DrawerPageState';
  List<WeatherEntity> _weatherInfo = null;
  SharedPreferenceHelper spHelper = new SharedPreferenceHelper();
  WeatherLoader loader = new WeatherLoader();

  _initData() async {
    await loader.init();
    _weatherInfo = await loader.loadData(offset: 0, limit: 0);
    Log.i(TAG, _weatherInfo.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _generateWeatherItem() {
    return new Container(
      padding: const EdgeInsets.all(15.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  _weatherInfo[0].location,
                  style: new TextStyle(
                      fontSize: 24.0
                  ),
                ),
                new Text(
                  _weatherInfo[0].tmp,
                  style: new TextStyle(
                      fontSize: 28.0
                  ),
                )
              ],
            ),
            new SizedBox(
              width: 60.0,
              height: 60.0,
              child: _generateWeatherIcon()
            ),
          ]
      ),
    );
  }

  _generateWeatherIcon() {
    Widget result = null;
    Log.i(TAG, '${_weatherInfo[0].statusCode} ${_weatherInfo[0].statusTxt}');
    switch (_weatherInfo[0].statusCode) {
      case '100':
        result = new Image.asset('assets/weather-sunny.png');
        break;
      case '101':
      case '104':
        result = new Image.asset('assets/weather-cloudy.png');
        break;
      case '102':
      case '103':
        result = new Image.asset('assets/weather-partycloudy.png');
        break;
      case '200':
      case '201':
      case '202':
      case '203':
      case '204':
      case '205':
      case '206':
      case '207':
      case '208':
      case '209':
      case '210':
      case '211':
      case '212':
      case '213':
        result = new Image.asset('assets/weather-windy-variant.png');
        break;
      case '302':
      case '303':
      case '304':
        result = new Image.asset('assets/weather-lightning.png');
        break;
      case '300':
      case '301':
      case '305':
      case '306':
      case '307':
      case '308':
      case '309':
        result = new Image.asset('assets/weather-rainy.png');
        break;
      case '310':
      case '311':
      case '312':
      case '313':
        result = new Image.asset('assets/weather-pouring.png');
        break;
      case '400':
      case '401':
      case '402':
      case '403':
      case '407':
        result = new Image.asset('assets/weather-snowy.png');
        break;
      case '404':
      case '405':
      case '406':
        result = new Image.asset('assets/weather-snowy-rainy.png');
        break;
      default: {
        result = new Image.asset('assets/weather-sunny.png');
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(new Image.asset("assets/flutter_bg.png"));
    if (_weatherInfo != null && _weatherInfo.length > 0) {
      widgets.add(_generateWeatherItem());
    }

    return new Drawer(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        )
    );
  }
}