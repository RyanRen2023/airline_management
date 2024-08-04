import 'package:airline_management/customer/Customer.dart';
import 'package:floor/floor.dart';

/// Data Access Object (DAO) for the Customer entity.
@dao
abstract class CustomerDAO {
  /// Finds all customers in the database.
  ///
  /// Returns a [Future] that completes with a list of [Customer]s.
  @Query("select * from Customer")
  Future<List<Customer>> findAllCustomers();

  /// Finds a customer by their ID.
  ///
  /// [id] - The ID of the customer to find.
  ///
  /// Returns a [Stream] that emits the [Customer] if found, otherwise null.
  @Query("select * from Customer where id = :id")
  Stream<Customer?> findCustomerById(int id);

  /// Deletes a customer by their ID.
  ///
  /// [id] - The ID of the customer to delete.
  ///
  /// Returns a [Future] that completes when the customer has been deleted.
  @Query("delete from Customer where id = :id")
  Future<void> deleteCustomerById(int id);

  /// Inserts a new customer into the database.
  ///
  /// [customer] - The [Customer] to insert.
  ///
  /// Returns a [Future] that completes with the ID of the inserted customer.
  @insert
  Future<int> insertCustomer(Customer customer);

  /// Updates an existing customer in the database.
  ///
  /// [customer] - The [Customer] to update.
  ///
  /// Returns a [Future] that completes when the customer has been updated.
  @update
  Future<void> updateCustomer(Customer customer);
}
