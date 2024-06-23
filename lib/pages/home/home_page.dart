import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_riverpod/constants/constants.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/pages/home/weather_state.dart';
import 'package:weather_app_riverpod/pages/search/search_page.dart';
import 'package:weather_app_riverpod/pages/temp_settings/temp_settings_page.dart';
import 'package:weather_app_riverpod/services/providers/weather_service_provider.dart';
import 'package:weather_app_riverpod/theme/theme_provider.dart';
import 'package:weather_app_riverpod/theme/theme_state.dart';
import 'package:weather_app_riverpod/widgets/error_dialog.dart';

import 'widgets/show_weather.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;
  bool loading = false;

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  void getUserLocation() async {
    final permitted = await checkLocationPermission();

    if (permitted) {
      try {
        setState(() => loading = true);
        final position = await Geolocator.getCurrentPosition();

        city = await ref
            .read(weatherServiceProvider)
            .getReverseGeoCoding(position.latitude, position.longitude);
      } catch (e) {
        city = kDefaultLocation;
      } finally {
        setState(() => loading = false);
      }
    } else {
      city = kDefaultLocation;
    }

    ref.read(weatherProvider.notifier).fetchWeather(city!);
  }

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showGeoLocatorError('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showGeoLocatorError('Location services are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showGeoLocatorError(
        'Location permissions are permanently denied, we cannot request permissions.',
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  void showGeoLocatorError(String message) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message using $kDefaultLocation'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    ref.listen(
      weatherProvider,
      (previous, next) {
        next.whenOrNull(
          data: (weather) {
            if (weather == null) return;
            if (weather.temp < 20) {
              ref.read(themeProvider.notifier).changeTheme(const LightTheme());
            } else {
              ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
            }
          },
          error: (error, stackTrace) {
            return errorDialog(context, (error as CustomError).errMsg);
          },
        );
      },
    );
    // final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              city = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );

              if (city != null) {
                ref.read(weatherProvider.notifier).fetchWeather(city!);
              }
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TempSettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ShowWeather(weatherState: weatherState),
      floatingActionButton: FloatingActionButton(
        onPressed: city == null
            ? null
            : () => ref.read(weatherProvider.notifier).fetchWeather(city!),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
