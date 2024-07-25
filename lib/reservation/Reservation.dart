import 'package:floor/floor.dart';

@entity
class Reservation {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String flightCode;
  final String date;

  Reservation({
      this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.flightCode,
    required this.date,
     });
}