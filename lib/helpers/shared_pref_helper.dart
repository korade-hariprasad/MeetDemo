import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _emailKey = 'email';
  static const String _nameKey = 'name';

  // Save email and name to SharedPreferences
  Future<void> saveUserDetails(String email, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_nameKey, name);
  }

  // Get email from SharedPreferences
  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Get name from SharedPreferences
  Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  // Clear user details from SharedPreferences
  Future<void> clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);
  }
}