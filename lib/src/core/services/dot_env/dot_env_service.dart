import 'dart:io';

class DotEnvService {
  final Map<String, String> _map = {};
  static DotEnvService instance = DotEnvService._();

  DotEnvService._() {
    _init();
  }

  void _init() {
    final file = File('.env');
    final envText = file.readAsStringSync();

    for (var line in envText.split('\n')) {
      final linebreak = line.split('=');
      _map[linebreak[0]] = linebreak[1];
    }
  }

  String? getValue(String key) {
    return _map[key];
  }

  String? operator [](String key) {
    return _map[key];
  }
}
