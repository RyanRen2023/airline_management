import 'package:floor/floor.dart';
import 'flight_item.dart';

@dao
abstract class FlightDao {
  @Query('SELECT * FROM FlightItem')
  Future<List<FlightItem>> findAllFlights();

  @insert
  Future<void> insertFlight(FlightItem flight);

  @update
  Future<void> updateFlight(FlightItem flight);

  @delete
  Future<void> deleteFlight(FlightItem flight);
}
