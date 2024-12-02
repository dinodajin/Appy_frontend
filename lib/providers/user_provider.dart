import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';
  String _moduleId = '';

  String get userId => _userId;
  String get moduleId => _moduleId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void setModuleId(String moduleId) {
    _moduleId = moduleId;
    notifyListeners();
  }
}
