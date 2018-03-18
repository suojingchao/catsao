

/**
 * follow the format of logs in Android.
 */
class Log {

  static v(String tag, String msg) {
    print('${new DateTime.now()} V/${tag}: ${msg}');
  }

  static d(String tag, String msg) {
    print('${new DateTime.now()} D/${tag}: ${msg}');
  }

  static i(String tag, String msg) {
    print('${new DateTime.now()} I/${tag}: ${msg}');
  }

  static w(String tag, String msg) {
    print('${new DateTime.now()} W/${tag}: ${msg}');
  }

  static e(String tag, String msg) {
    print('${new DateTime.now()} E/${tag}: ${msg}');
  }

}