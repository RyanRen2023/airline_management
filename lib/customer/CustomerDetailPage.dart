import 'package:airline_management/customer/CustomerDetailView.dart';
import 'package:flutter/material.dart';

import 'Customer.dart';

class CustomerDetailPage extends StatefulWidget {
  Customer customer;
  final String title;
  Function(Customer) updateCustomer;
  Function(Customer) deleteCustomer;

  CustomerDetailPage(
      {super.key,
      required this.title,
      required this.customer,
      required this.updateCustomer,
      required this.deleteCustomer});

  @override
  State<StatefulWidget> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: CustomerDetailView(customer: widget.customer,updateCustomer: widget.updateCustomer,deleteCustomer: widget.deleteCustomer,),
    );
  }
}
