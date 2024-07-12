import 'package:airline_management/customer/CustomerDetailView.dart';
import 'package:flutter/material.dart';

import 'Customer.dart';

class CustomerDetailPage extends StatefulWidget {

  Customer customer;
  final String title;

  CustomerDetailPage({super.key, required this.title, required this.customer});



  @override
  State<StatefulWidget> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {


  @override
  Widget build(BuildContext context) {
    return CustomerDetailView(customer: widget.customer);
  }
}
