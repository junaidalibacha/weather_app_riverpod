import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app_riverpod/constants/constants.dart';
import 'package:weather_app_riverpod/dio/dio_error_handler.dart';
import 'package:weather_app_riverpod/exceptions/weather_exception.dart';

import '../models/current_weather/current_weather.dart';
import '../models/direct_geocoding/direct_geocoding.dart';

class WeatherService {
  WeatherService({required this.dio});

  final Dio dio;

  Future<DirectGeocoding> getDirectGeoCoding(String city) async {
    try {
      final response = await dio.get(
        '/geo/1.0/direct',
        queryParameters: {
          'q': city,
          'limit': kLimit,
          'appid': dotenv.env['APPID'],
        },
      );

      if (response.statusCode != 200) throw dioErrorHandler(response);

      final List<dynamic> data = response.data as List;

      if (data.isEmpty) {
        throw WeatherException('Cannot get the location of $city');
      }

      final directGeoCoding = DirectGeocoding.fromJson(data.first);

      return directGeoCoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getReverseGeoCoding(double lat, double lng) async {
    try {
      final response = await dio.get(
        '/geo/1.0/reverse',
        queryParameters: {
          'lat': '$lat',
          'lon': '$lng',
          'units': kUnit,
          'appid': dotenv.env['APPID'],
        },
      );

      if (response.statusCode != 200) throw dioErrorHandler(response);

      final List<dynamic> data = response.data as List;

      if (data.isEmpty) {
        throw WeatherException('Cannot get the location($lat, $lng)');
      }

      final String city = data.first['name'];

      return city;
    } catch (e) {
      rethrow;
    }
  }

  Future<CurrentWeather> getWeather(DirectGeocoding directGeocoding) async {
    try {
      final response = await dio.get(
        '/data/2.5/weather',
        queryParameters: {
          'lat': '${directGeocoding.lat}',
          'lon': '${directGeocoding.lng}',
          'units': kUnit,
          'appid': dotenv.env['APPID'],
        },
      );

      if (response.statusCode != 200) throw dioErrorHandler(response);

      final currentWeather = CurrentWeather.fromJson(response.data);

      return currentWeather;
    } catch (e) {
      rethrow;
    }
  }
}
