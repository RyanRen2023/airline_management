import 'package:floor/floor.dart';
import 'package:airline_management/reservation/Reservation.dart';

@dao
abstract class ReservationDAO {
  @Query('SELECT * FROM Reservation')
  Future<List<Reservation>> getAllReservations();

  @Query('SELECT * FROM Reservation WHERE id = :id')
  Future<Reservation?> getReservationById(int id);

  @insert
  Future<void> insertReservation(Reservation reservation);

  @update
  Future<void> updateReservation(Reservation reservation);

  @delete
  Future<void> deleteReservation(Reservation reservation);
}
