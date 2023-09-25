import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static late SharedPreferences sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putString(String key, String value)
  {
    return sharedPreferences.setString(key, value);
  }

  static dynamic getData(key)
  {
    return sharedPreferences.get(key);
  }
}