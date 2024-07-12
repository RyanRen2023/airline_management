import 'package:flutter/material.dart';
import 'package:airline_management/customer/AddCustomerPage.dart';
import 'package:airline_management/customer/CustomerListPage.dart';
import 'package:airline_management/customer/Customer.dart';
import 'package:airline_management/customer/CustomerDetailView.dart';

import 'CustermerDetailPage.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  int _selectedIndex = 0;
  Customer? _selectedCustomer;

  final List<Customer> customers = [
    Customer(
        firstName: 'John',
        lastName: 'Doe',
        address: '123 Main St',
        birthday: '1990-01-01'),
    Customer(
        firstName: 'Jane',
        lastName: 'Smith',
        address: '456 Elm St',
        birthday: '1992-02-02'),
  ];

  void _onCustomerSelectedWide(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }

  void _onCustomerSelected(Customer customer) {
    _selectedCustomer = customer;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CustomerDetailPage(title: 'Add Customer', customer: customer);
      }),
    );
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var width = size.width;

    if (width > heigh && width > 720) {
      // landscape
      return showWideScreen();
    } else {
      //Portrait screen
      return showNormalScreen();
    }
  }

  Widget showWideScreen() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomerListPage(
            customers: customers,
            onCustomerSelected: _onCustomerSelectedWide,
            selectedCustomer: _selectedCustomer,
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedCustomer != null
              ? CustomerDetailView(customer: _selectedCustomer!)
              : Center(child: Text('Select a customer to view details')),
        ),
      ],
    );
  }

  Widget showNormalScreen() {
    return Column(
      children: [
        Expanded(
          child: CustomerListPage(
            customers: customers,
            onCustomerSelected: _onCustomerSelected,
            selectedCustomer: _selectedCustomer,
          ),
        ),
        if (_selectedCustomer != null)
          Expanded(
            child: CustomerDetailView(customer: _selectedCustomer!),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          responsiveLayout(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddCustomerPage(title: 'Add Customer')),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
