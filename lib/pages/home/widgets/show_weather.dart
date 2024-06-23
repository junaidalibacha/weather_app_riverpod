import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/models/app_weather/app_weather.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/pages/home/widgets/show_icon.dart';

import 'select_city.dart';
import 'show_temperature.dart';

class ShowWeather extends StatelessWidget {
  const ShowWeather({super.key, required this.weatherState});

  final AsyncValue<AppWeather?> weatherState;

  @override
  Widget build(BuildContext context) {
    // final weatherState = ref.watch(weatherProvider);
    return weatherState.when(
      skipError: true,
      data: (weather) {
        if (weather == null) return const SelectCity();

        // final appWeather = AppWeather.fromCurrentWeather(weather);
        return ListView(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height / 6),
            Text(
              weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(DateTime.now()).format(context),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  "(${weather.country})",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTemperature(
                  temperature: weather.temp,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    ShowTemperature(
                      temperature: weather.tempMax,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 5),
                    ShowTemperature(
                      temperature: weather.tempMin,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const Spacer(),
                ShowIcon(icon: weather.icon),
                Expanded(
                  flex: 3,
                  child: Text(
                    weather.description.titleCase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
      error: (error, st) {
        if (weatherState.value == null) return const SelectCity();
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              (error as CustomError).errMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
