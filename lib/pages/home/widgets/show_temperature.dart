import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/pages/temp_settings/temp_setting_state.dart';

import '../../temp_settings/temp_setting_provider.dart';

class ShowTemperature extends ConsumerWidget {
  const ShowTemperature({
    super.key,
    required this.temperature,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  final double temperature;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempUnit = ref.watch(tempSettingsProvider);

    final currentTemperature = switch (tempUnit) {
      Celsius() => "${temperature.toStringAsFixed(2)} \u2103",
      Fahrenheit() =>
        "${((temperature * 9 / 5) + 32).toStringAsFixed(2)} \u2109"
    };
    return Text(
      currentTemperature,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
