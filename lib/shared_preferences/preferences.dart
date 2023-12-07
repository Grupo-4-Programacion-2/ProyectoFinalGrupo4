import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static late SharedPreferences _prefs;

  static String _name = '';
  static bool _isSession = false;
  static String _userId = '1';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get name {
    return _prefs.getString('name') ?? _name;
  }

  static set name( String name ) {
    _name = name;
    _prefs.setString('name', name );
  }

  static bool get isSession {
    return _prefs.getBool('isSession') ?? _isSession;
  }

  static set isSession( bool value ) {
    _isSession = value;
    _prefs.setBool('isSession', value );
  }

  static String get userId {
    return _prefs.getString('userId') ?? _userId;
  }

  static set userId( String value ) {
    _userId = value;
    _prefs.setString('userId', value );
  }

}