import 'package:floor/floor.dart';
import 'Reservation.dart';


@dao
abstract class ReservationDAO {
  @insert
  Future<void> insertReservation(Reservation reservation);

  @delete
  Future<int> deleteReservation(Reservation reservation);

  @Query('SELECT * FROM Reservation WHERE id = :_id')
  Future<Reservation?> getReservationWithId(int _id);

  @Query('SELECT * FROM Reservation')
  Future<List<Reservation>> getAllReservations();

  @update
  Future<int> updateReservation(Reservation reservation);

  @Query('SELECT * FROM Reservation WHERE customerId = :_customerId')
  Future<List<Reservation>> getReservationsForCustomer(int _customerId);

  @Query('SELECT * FROM Reservation WHERE flightId = :_flightId')
  Future<List<Reservation>> getReservationsForFlight(int _flightId);
}

