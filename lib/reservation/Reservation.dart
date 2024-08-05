import 'package:floor/floor.dart';

import '../customer/Customer.dart';
import '../flights/FlightItem.dart';

@entity
class Reservation {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ForeignKey(entity: Customer, parentColumns: ['id'], childColumns: ['customerId'])
  final int customerId;

  @ForeignKey(entity: FlightItem, parentColumns: ['id'], childColumns: ['flightId'])
  final int flightId;

  final String date;

  Reservation({
    this.id,
    required this.customerId,
    required this.flightId,
    required this.date,
  });
}