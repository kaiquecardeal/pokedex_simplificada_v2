import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart';
import 'main.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  scaffoldBackgroundColor: Color(0xFF181818),
  cardColor: Color(0xFF232323),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: 'Pokedex Simplificada v2',
          debugShowCheckedModeBanner: false,
          routerConfig: getIt<GoRouter>(),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}
