import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/pages/temp_settings/temp_setting_state.dart';

part 'temp_setting_provider.g.dart';

@Riverpod(keepAlive: true)
class TempSettings extends _$TempSettings {
  @override
  TempSettingState build() {
    return const Celsius();
  }

  void toggleTempUnit() {
    state = switch (state) {
      Celsius() => const Fahrenheit(),
      Fahrenheit() => const Celsius(),
    };
  }
}
