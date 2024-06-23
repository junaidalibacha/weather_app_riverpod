import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/pages/temp_settings/temp_setting_provider.dart';
import 'package:weather_app_riverpod/pages/temp_settings/temp_setting_state.dart';

class TempSettingsPage extends StatelessWidget {
  const TempSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temp Settings'),
      ),
      body: ListView(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final tempUnit = ref.watch(tempSettingsProvider);
              return SwitchListTile.adaptive(
                title: const Text('Temperature Unit'),
                subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
                value: tempUnit != const Fahrenheit(),
                onChanged: (_) {
                  ref.read(tempSettingsProvider.notifier).toggleTempUnit();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
