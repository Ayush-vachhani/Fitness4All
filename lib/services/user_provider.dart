import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userDetails;

  Map<String, dynamic>? get userDetails => _userDetails;

  void setUserDetails(Map<String, dynamic>? userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  void registerUser(String username, String email, String password, String? profileImagePath) {
    _userDetails = {
      'username': username,
      'password': password,
      'email': email,
      'profileImagePath': profileImagePath,
    };
    notifyListeners();
  }

  void updateUserDetails(Map<String, dynamic> details) {
    if (_userDetails != null) {
      _userDetails!.addAll(details);
      notifyListeners();
    }
  }

  void clearUserDetails() {
    _userDetails = null;
    notifyListeners();
  }
}