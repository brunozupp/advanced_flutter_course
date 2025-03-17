final class Constants {

  Constants._();

  /// In order to work this url being in local I need to replace http by the
  /// ip.
  /// To android is 10.0.2.2
  /// To ios and real device is the ip from the machine
  static const String BASE_URL_ANDROID = "http://10.0.2.2:5050/api";
  static const String BASE_URL_IOS = "http://127.0.0.1:5050/api";
}