/*
 * Student Name: Xihai Ren
 * Student No: 041127486
 * Professor: Eric Torunski
 * Due Date: 2024/07/12
 * Description: Lab 7 - Using database
 */

import 'package:airline_management/customer/CustomerDAO.dart';
import 'package:airline_management/flights/FlightDao.dart';
import 'package:airline_management/reservation/ReservationDAO.dart';
import '../airplane/Airplane.dart';
import '../airplane/AirplaneDAO.dart';
import '../customer/Customer.dart';
import 'database.dart';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart';



/**
 * The DatabaseOperator class handles database operations
 * such as initializing the database and accessing data access objects (DAOs).
 *
 * @version 1.0.0
 * @since Dart 2.12
 *
 * @author Xihai Ren
 */
class DatabaseOperator {
  // Static variable to hold the database instance

  static late final AppDatabase? _database;
  static const String databaseFile = "app_database.db";

  /**
   * Initializes the database if it has not been initialized.
   * Uses the Floor library to build the database.
   *
   * @return Future<void> A Future that completes when the database is initialized.
   */
  static Future<void> initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder(databaseFile).build();
  }

  static Future<void> deleteOldDatabase() async {
    final path = await sqfliteDatabaseFactory.getDatabasePath(databaseFile);
    await deleteDatabase(path);
  }


  static Future<CustomerDAO?> getCustomerDAO() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database?.customerDAO;
  }

  static Future<List<Customer>> getAllCustomers() async {
    List<Customer> list = [];
    CustomerDAO? customerDAO = await getCustomerDAO();
    if (customerDAO != null) {
      list = await customerDAO.findAllCustomers();
    }
    return list;
  }

  static Future<FlightDao?> getFlightsDAO() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database?.flightDao;
  }

  static Future<ReservationDAO?> getReservationDAO() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database?.reservationDao;
  }

  static Future<AirplaneDAO?> getAirplaneDAO() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database?.airplaneDAO;
  }

  static Future<List<Airplane>> getAllAirplanes() async {
    List<Airplane> list = [];
    AirplaneDAO? airplaneDAO = await getAirplaneDAO();
    if (airplaneDAO != null) {
      list = await airplaneDAO.findAllAirplanes();
    }
    return list;
  }
}
