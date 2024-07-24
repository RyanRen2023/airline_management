import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


 import '../flights/flight_item.dart';
import 'Reservation.dart';
import 'ReservationDAO.dart';

part 'ReservationDatabase.g.dart';

@Database(version: 1, entities: [Reservation])
abstract class ReservationDatabase extends FloorDatabase {
  ReservationDAO get getReservationDao;

}


