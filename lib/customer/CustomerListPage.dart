import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';


/// A stateless widget that displays a list of customers.
///
/// The [CustomerListPage] widget displays a scrollable list of customers. When a customer
/// is tapped, the [onCustomerSelected] callback is invoked with the selected customer.
class CustomerListPage extends StatelessWidget {
  /// List of customers to display.
  final List<Customer> customers;
  /// Callback function to be invoked when a customer is selected.
  final Function(Customer) onCustomerSelected;
  /// Currently selected customer.
  final Customer? selectedCustomer;
  /// Creates a [CustomerListPage].
  ///
  /// The [customers] parameter must not be null and specifies the list of customers to display.
  /// The [onCustomerSelected] parameter must not be null and specifies the callback function
  /// to invoke when a customer is selected.
  /// The [selectedCustomer] parameter specifies the currently selected customer, if any.
  const CustomerListPage({
    super.key,
    required this.customers,
    required this.onCustomerSelected,
    required this.selectedCustomer,
  });

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${customers[index].firstName} ${customers[index].lastName}'),
          selected: selectedCustomer == customers[index],
          onTap: () {
            onCustomerSelected(customers[index]);
          },
        );
      },
    );
  }
}
