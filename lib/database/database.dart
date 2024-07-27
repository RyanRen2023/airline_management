// Required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../airplane/Airplane.dart';
import '../airplane/AirplaneDAO.dart';
import '../customer/Customer.dart';
import '../customer/CustomerDAO.dart';
import '../flights/FlightItem.dart';
import '../flights/FlightDao.dart';
part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Customer, Airplane, FlightItem])
abstract class AppDatabase extends FloorDatabase {
  CustomerDAO get customerDAO;
  AirplaneDAO get airplaneDAO;
  FlightDao get flightDao;
}
