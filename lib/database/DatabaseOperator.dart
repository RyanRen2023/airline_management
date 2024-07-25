/*
 * Student Name: Xihai Ren
 * Student No: 041127486
 * Professor: Eric Torunski
 * Due Date: 2024/07/12
 * Description: Lab 7 - Using database
 */

import 'package:airline_management/customer/CustomerDAO.dart';
import 'package:airline_management/flights/FlightDao.dart';
import '../customer/Customer.dart';
import 'database.dart';

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

  /**
   * Initializes the database if it has not been initialized.
   * Uses the Floor library to build the database.
   *
   * @return Future<void> A Future that completes when the database is initialized.
   */
  static Future<void> initDatabase() async {
    _database =
    await $FloorAppDatabase.databaseBuilder('airline_database.db').build();
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
  }}