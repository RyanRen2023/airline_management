import 'package:floor/floor.dart';
import 'package:airline_management/flights/FlightItem.dart';
// version 2
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
