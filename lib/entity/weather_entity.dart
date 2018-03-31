
class WeatherEntity {
  String country;
  String location;
  String tmp;
  String cond;
  String hum;
  String windDir;
  String windSc;
  String windSpd;
  String statusCode;
  String statusTxt;

  WeatherEntity({this.country, this.location, this.tmp, this.cond, this.hum
    , this.windDir, this.windSc, this.windSpd, this.statusCode, this.statusTxt});

  WeatherEntity.fromSP(List<String> list) {
    country = list[0];
    location = list[1];
    tmp = list[2];
    cond = list[3];
    hum = list[4];
    windDir = list[5];
    windSc = list[6];
    windSpd = list[7];
    statusCode = list[8];
    statusTxt = list[9];
  }

  toList() {
    List<String> result = [];
    result.add(country);
    result.add(location);
    result.add(tmp);
    result.add(cond);
    result.add(hum);
    result.add(windDir);
    result.add(windSc);
    result.add(windSpd);
    result.add(statusCode);
    result.add(statusTxt);
    return result;
  }
}