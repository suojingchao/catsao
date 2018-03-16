import 'dart:convert';
import 'package:http/http.dart';
import 'lifestyle_entity.dart';
import 'package:flutter/services.dart';

class LifestyleInfo {
  List<LifestyleEntity> data = [];

  LifestyleInfo(Response response) {
    Map map = JSON.decode(response.body);
    if (map.isNotEmpty) {
      List list = map['HeWeather6'];
      if (list.isNotEmpty) {
        Map inner = list[0];
        List lifestyle = inner['lifestyle'];
        for (int i = 0 ; i < lifestyle.length ; i++) {
          data.add(new LifestyleEntity(
              name: lifestyle[i]['type'],
              shortDes: lifestyle[i]['brf'],
              des: lifestyle[i]['txt']
          ));
        }
      }
    }
    print("lifestyle:\n${map}");
  }

}