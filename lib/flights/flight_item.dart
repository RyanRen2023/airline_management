import 'package:floor/floor.dart';

@entity
class FlightItem {
  @primaryKey
  final int id;
  final String flightCode;
  final String departureCity;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;

  FlightItem(this.id, this.flightCode, this.departureCity, this.destinationCity, this.departureTime, this.arrivalTime);
}
