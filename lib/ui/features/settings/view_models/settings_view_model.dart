import 'package:flutter/material.dart';

/// ViewModel quản lý cài đặt giao diện Chế độ sáng / tối.
class SettingsViewModel extends ChangeNotifier {
  bool _isLightMode = true;

  bool get isLightMode => _isLightMode;
  ThemeMode get themeMode => _isLightMode ? ThemeMode.light : ThemeMode.dark;

  void setLightMode(bool value) {
    if (_isLightMode != value) {
      _isLightMode = value;
      notifyListeners();
    }
  }
}
