import 'package:floor/floor.dart';
/// Entity class representing a customer in the database.
@entity
class Customer {
  /// The primary key ID of the customer. It is auto-generated.
  @PrimaryKey(autoGenerate: true)
  final int? id;
  /// The first name of the customer.
  final String firstName;
  /// The last name of the customer.
  final String lastName;
  /// The address of the customer.
  final String address;
  /// The birthday of the customer.
  final String birthday;
  /// Creates a [Customer] instance.
  ///
  /// The [id] is optional and will be auto-generated if not provided.
  /// The [firstName], [lastName], [address], and [birthday] parameters must not be null.
  Customer(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.birthday});
}
