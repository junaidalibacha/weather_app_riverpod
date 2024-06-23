import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/exceptions/weather_exception.dart';
import 'package:weather_app_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/services/providers/weather_service_provider.dart';
import 'package:weather_app_riverpod/services/weather_service.dart';

part 'weather_repository.g.dart';

@riverpod
WeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  return WeatherRepository(weatherService: ref.watch(weatherServiceProvider));
}

class WeatherRepository {
  WeatherRepository({required this.weatherService});

  final WeatherService weatherService;

  Future<CurrentWeather> fetchWeather(String city) async {
    try {
      final directGeocoding = await weatherService.getDirectGeoCoding(city);
      log('directGeocoding ======> $directGeocoding');

      final tempWeather = await weatherService.getWeather(directGeocoding);
      log('tempWeather ======> $tempWeather');

      final currentWeather = tempWeather.copyWith(
        name: directGeocoding.name,
        sys: tempWeather.sys.copyWith(country: directGeocoding.country),
      );
      log('currentWeather =====> $currentWeather');

      return currentWeather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
