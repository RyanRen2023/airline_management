import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';

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
  Widget build(BuildContext context) {
    final String message = AppLocalizations.of(context)!
        .translate(Const.THERE_IS_NO_CUSTOMER_IN_THE_LIST)!;

    return Container(
      height: double.infinity, // Ensure the ListView takes the full height
      child: customers.isEmpty
          ? Center(
              child: Text(
                message,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${customers[index].firstName} ${customers[index].lastName}'),
                  selected: selectedCustomer == customers[index],
                  onTap: () {
                    onCustomerSelected(customers[index]);
                  },
                );
              },
            ),
    );
  }
}
