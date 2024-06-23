import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/pages/home/home_page.dart';
import 'package:weather_app_riverpod/theme/theme_provider.dart';
import 'package:weather_app_riverpod/theme/theme_state.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Weather App',
      theme: switch (appTheme) {
        LightTheme() => ThemeData.light(),
        DarkTheme() => ThemeData.dark(),
      },
      home: const HomePage(),
    );
  }
}
