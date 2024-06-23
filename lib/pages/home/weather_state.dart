import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/data/weather_repository.dart';
import 'package:weather_app_riverpod/models/app_weather/app_weather.dart';

part 'weather_state.g.dart';

@riverpod
class Weather extends _$Weather {
  @override
  FutureOr<AppWeather?> build() => Future.value(null);

  Future<void> fetchWeather(String city) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentWeather =
          await ref.read(weatherRepositoryProvider).fetchWeather(city);

      return AppWeather.fromCurrentWeather(currentWeather);
    });
  }
}
