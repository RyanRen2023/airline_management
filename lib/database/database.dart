// Required package imports
import 'dart:async';
import 'package:airline_management/reservation/ReservationDAO.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../airplane/Airplane.dart';
import '../airplane/AirplaneDAO.dart';
import '../customer/Customer.dart';
import '../customer/CustomerDAO.dart';
import '../flights/FlightItem.dart';
import '../flights/FlightDao.dart';
import '../reservation/Reservation.dart';
part 'database.g.dart'; // the generated code will be there

//添加了新的实体需要修改版本号！！
@Database(version: 1, entities: [Customer, Airplane,FlightItem,Reservation])
abstract class AppDatabase extends FloorDatabase {
  CustomerDAO get customerDAO;
  AirplaneDAO get airplaneDAO;
  FlightDao get flightDao;
  ReservationDAO get reservationDao;
}
