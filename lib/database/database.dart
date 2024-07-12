// Required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../customer/Customer.dart';
import '../customer/CustomerDAO.dart';

part 'database.g.dart'; // the generated code will be there


@Database(version: 1, entities: [Customer])
abstract class AppDatabase extends FloorDatabase {

  CustomerDAO get customerDAO;
}