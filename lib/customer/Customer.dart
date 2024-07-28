import 'package:floor/floor.dart';

@entity
class Customer {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customer(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.birthday});
}
