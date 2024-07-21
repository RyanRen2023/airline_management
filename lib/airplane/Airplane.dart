import 'package:floor/floor.dart';

@entity
class Airplane {
  @primaryKey
  final int id;
  final String airplaneType;
  final int numberOfPassengers;
  final int maxSpeed;
  final int rangeToFly;

  Airplane(
      {required this.id,
        required this.airplaneType,
        required this.numberOfPassengers,
        required this.maxSpeed,
        required this.rangeToFly});
}
