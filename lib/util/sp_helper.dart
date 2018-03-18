import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

  static final String KEY_TOP_LAST_LOADTIME = 'top_last_load_time';
  static final String KEY_SH_LAST_LOADTIME = 'sh_last_load_time';
  static final String KEY_GN_LAST_LOADTIME = 'gn_last_load_time';
  static final String KEY_GJ_LAST_LOADTIME = 'gj_last_load_time';
  static final String KEY_YL_LAST_LOADTIME = 'yl_last_load_time';
  static final String KEY_TY_LAST_LOADTIME = 'ty_last_load_time';
  static final String KEY_JS_LAST_LOADTIME = 'js_last_load_time';
  static final String KEY_KJ_LAST_LOADTIME = 'kj_last_load_time';
  static final String KEY_CJ_LAST_LOADTIME = 'cj_last_load_time';
  static final String KEY_SS_LAST_LOADTIME = 'ss_last_load_time';
  static final String KEY_WEATHER_LAST_LOADTIME = 'weather_last_load_time';
  static final String KEY_WEATHER_INFO = 'weather_info';

  static SharedPreferenceHelper _instance = new SharedPreferenceHelper._internal();

  SharedPreferences sp = null;

  factory SharedPreferenceHelper() {
    return _instance;
  }

  SharedPreferenceHelper._internal();

  init() async {
    sp = await SharedPreferences.getInstance();
  }

  get(String key) {
    return sp.get(key);
  }

  getStringList(String key) {
    return sp.getStringList(key);
  }

  getString(String key) {
    return sp.getString(key);
  }

  getInt(String key) {
    return sp.getInt(key);
  }

  getBool(String key) {
    return sp.getBool(key);
  }

  getDouble(String key) {
    return sp.getDouble(key);
  }

  setBool(String key, bool value) {
    sp.setBool(key, value);
  }

  setDouble(String key, double value) {
    sp.setDouble(key, value);
  }

  setInt(String key, int value) {
    sp.setInt(key, value);
  }

  setString(String key, String value) {
    sp.setString(key, value);
  }

  setStringList(String key, List<String> value) {
    sp.setStringList(key, value);
  }
}