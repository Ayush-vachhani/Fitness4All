import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userDetails;

  Map<String, dynamic>? get userDetails => _userDetails;

  void setUserDetails(Map<String, dynamic>? userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }
}