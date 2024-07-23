import 'package:airline_management/customer/Customer.dart';
import 'package:floor/floor.dart';

@dao
abstract class CustomerDAO {
  @Query("select * from Customer")
  Future<List<Customer>> findAllCustomers();

  @Query("select * from Customer where id = :id")
  Stream<Customer?> findCustomerById(int id);

  @Query("delete from Customer where id = :id")
  Future<void> deleteCustomerById(int id);

  @insert
  Future<int> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);
}
