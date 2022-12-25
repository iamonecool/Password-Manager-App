import 'package:shared_preferences/shared_preferences.dart';

class PasswordSharedPreferences {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setRootPassword(String password) async {
    await _preferences.setString("rootPassword", password);
  }

  static String? getRootPassword() {
    return _preferences.getString("rootPassword");
  }

  static Future setHasRegistered(bool hasRegistered) async {
    await _preferences.setBool("hasRegistered", hasRegistered);
  }

  static bool? getHasRegistered() {
    return _preferences.getBool("hasRegistered");
  }

  static Future setServicesList(List<String> nameOfServices) async {
    await _preferences.setStringList("services", nameOfServices);
  }

  static List<String>? getServicesList() {
    return _preferences.getStringList("services");
  }

  static Future setUsername(String nameOfService, String username) async {
    _preferences.setString(nameOfService + "Username", username);
  }

  static String? getUsername(String nameOfService) {
    return _preferences.getString(nameOfService + "Username");
  }

  static Future setPassword(String nameOfService, String password) async {
    _preferences.setString(nameOfService + "Password", password);
  }

  static String? getPassword(String nameOfService) {
    return _preferences.getString(nameOfService + "Password");
  }

  static Future setWebsite(String nameOfService, String username) async {
    _preferences.setString(nameOfService + "Website", username);
  }

  static String? getWebsite(String nameOfService) {
    return _preferences.getString(nameOfService + "Website");
  }

  static Future setEmail(String nameOfService, String password) async {
    _preferences.setString(nameOfService + "Email", password);
  }

  static String? getEmail(String nameOfService) {
    return _preferences.getString(nameOfService + "Email");
  }
}
