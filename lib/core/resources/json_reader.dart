import 'dart:convert';
import 'package:flutter/services.dart';

abstract class JsonReader {
  static late Map<String, dynamic> _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('env/env.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getNameConfig(String name) {
    return _config[name] as String;
  }
}
