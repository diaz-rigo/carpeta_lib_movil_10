import 'package:austins/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl; // Nueva variable para la URL de la foto de perfil

  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;

void setUser(String userId, String userName, String userEmail, String? userPhotoUrl) {
  _userId = userId;
  _userName = userName;
  _userEmail = userEmail;
  _userPhotoUrl = userPhotoUrl;
  notifyListeners();
}

  Future<void> loadUser() async {
    final session = await getUserSession();
    _userId = session['userId'];
    _userName = session['userName'];
    _userEmail = session['userEmail'];
    _userPhotoUrl = session['userPhotoUrl']; // Cargar foto desde la sesión si existe
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userPhotoUrl = null;
    notifyListeners();
  }
}
