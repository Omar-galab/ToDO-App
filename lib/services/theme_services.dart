import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';
  // ignore: unused_element
  _saveThemeFromBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  bool _loadThemeFromBox() {
    _box.read(_key);
    return _box.read<bool>(_key) ?? false;
  }

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchThem() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeFromBox(!_loadThemeFromBox());
  }
}
