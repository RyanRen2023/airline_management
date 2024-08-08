import 'package:airline_management/Properties.dart';
import 'package:airline_management/customer/CustomerDetailView.dart';
import 'package:flutter/material.dart';

import 'Customer.dart';
/// A stateful widget that displays the details of a customer.
class CustomerDetailPage extends StatefulWidget {
  /// The customer whose details are to be displayed and edited.
  Customer customer;

  /// The title of the page.
  final String title;
  /// Callback function to update the customer.
  Function(Customer) updateCustomer;
  /// Callback function to delete the customer.
  Function(Customer) deleteCustomer;
  /// Creates a [CustomerDetailPage].
  ///
  /// The [title], [customer], [updateCustomer], and [deleteCustomer] parameters must not be null.
  CustomerDetailPage(
      {super.key,
      required this.title,
      required this.customer,
      required this.updateCustomer,
      required this.deleteCustomer});

  @override
  State<StatefulWidget> createState() => _CustomerDetailPageState();
}
/// State for [CustomerDetailPage].
class _CustomerDetailPageState extends State<CustomerDetailPage> {
  /// Updates the customer and pops the current page from the navigation stack.
  ///
  /// [customer] - The customer to update.
  void updateCustomer(Customer customer){
    widget.updateCustomer(customer);
    Navigator.of(context).pop();
  }
  /// Deletes the customer and pops the current page from the navigation stack.
  ///
  /// [customer] - The customer to delete.
  void deleteCustomer(Customer customer){
    widget.deleteCustomer(customer);
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: CustomerDetailView(
        customer: widget.customer,
        updateCustomer: updateCustomer,
        deleteCustomer: deleteCustomer,
      ),
    );
  }
}
