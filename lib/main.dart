import 'package:flutter/material.dart';
import 'package:pokedex_simplificada_v2/app.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart'
    as dependency_injector;

final themeModeNotifier = ValueNotifier(ThemeMode.system);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dependency_injector.init();
  runApp(const MyApp());
}
