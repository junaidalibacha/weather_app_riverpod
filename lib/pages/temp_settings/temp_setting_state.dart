sealed class TempSettingState {
  const TempSettingState();
}

final class Celsius extends TempSettingState {
  const Celsius();

  @override
  String toString() => 'Celsius()';
}

final class Fahrenheit extends TempSettingState {
  const Fahrenheit();

  @override
  String toString() => 'Fahrenheit()';
}
