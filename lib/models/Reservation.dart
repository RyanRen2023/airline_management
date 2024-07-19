import 'package:floor/floor.dart';

@entity
class Reservation {
  static int ID = 1;

  @primaryKey
  final int id;

  final int customerId;
  final int flightId;
  final String date;

  Reservation(this.id, this.customerId, this.flightId, this.date) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}