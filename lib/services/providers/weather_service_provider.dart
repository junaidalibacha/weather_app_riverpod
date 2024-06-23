import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/dio/dio_provider.dart';
import 'package:weather_app_riverpod/services/weather_service.dart';

part 'weather_service_provider.g.dart';

@riverpod
WeatherService weatherService(WeatherServiceRef ref) {
  return WeatherService(dio: ref.watch(dioProvider));
}
