import 'dart:convert';
import 'dart:html';

class WebStorage {
  static T? getItem<T>(String key, T Function(dynamic json)? fromJson) {
    final value = window.localStorage[key];
    if (value == null) return null;
    final decoded = jsonDecode(value);
    return fromJson != null ? fromJson(decoded) : decoded as T;
  }

  static void setItem(String key, dynamic value) {
    window.localStorage[key] = jsonEncode(value);
  }

  static void removeItem(String key) {
    window.localStorage.remove(key);
  }
}
