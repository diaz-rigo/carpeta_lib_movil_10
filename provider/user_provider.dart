import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;

  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;

  Future<void> setUser(
      String userId, String userName, String userEmail, String? userPhotoUrl) async {
    _userId = userId;
    _userName = userName;
    _userEmail = userEmail;
    _userPhotoUrl = userPhotoUrl;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
    if (userPhotoUrl != null) {
      await prefs.setString('userPhotoUrl', userPhotoUrl);
    }
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    _userPhotoUrl = prefs.getString('userPhotoUrl');
    notifyListeners();
  }

  Future<void> clearUser() async {
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userPhotoUrl = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userPhotoUrl');

    notifyListeners();
  }
}
