import 'package:floor/floor.dart';

@entity
class Flight {
  static int ID = 1;

  @primaryKey
  final int id;

  final String flightNumber;
  final String departureCity;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;
  final int capacity;

  Flight(
      this.id,
      this.flightNumber,
      this.departureCity,
      this.destinationCity,
      this.departureTime,
      this.arrivalTime,
      this.capacity,
      ) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}