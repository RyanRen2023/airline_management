import 'package:airline_management/database/DatabaseOperator.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/customer/AddCustomerPage.dart';
import 'package:airline_management/customer/CustomerListPage.dart';
import 'package:airline_management/customer/Customer.dart';
import 'package:airline_management/customer/CustomerDetailView.dart';

import 'CustomerDAO.dart';
import 'CustomerDetailPage.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  Customer? _selectedCustomer;
  late CustomerDAO? customerDAO;
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    DatabaseOperator.getAllCustomers().then((value) {
      setState(() {
        customers = value;
      });
    });

    DatabaseOperator.getCustomerDAO().then((value) {
      customerDAO = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    super.setState(() {});
  }

  void onCustomerSelectedWide(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }

  void onCustomerSelected(Customer customer) {
    _selectedCustomer = customer;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CustomerDetailPage(
          title: 'Customer Detail',
          customer: customer,
          updateCustomer: onUpdateCustomer,
          deleteCustomer: onDeleteCustomer,
        );
      }),
    );
  }

  void onAddNewCustomer(Customer customer) {
    setState(() {
      customers.add(customer);
    });

    customerDAO?.insertCustomer(customer);
  }

  void onUpdateCustomer(Customer customer) {
    for (int i = 0; i < customers.length; i++) {
      if (customer.id == customers[i].id) {
        setState(() {
          customers[i] = customer;
          _selectedCustomer = customer;
        });
        break;
      }
    }
    customerDAO?.updateCustomer(customer);
  }

  void onDeleteCustomer(Customer customer) {
    for (int i = 0; i < customers.length; i++) {
      if (customer.id == customers[i].id) {
        setState(() {
          customers.removeAt(i);
          _selectedCustomer = null;
        });
        break;
      }
    }
    customerDAO?.deleteCustomerById(customer.id!);
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if (width > height && width > 720) {
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
            onCustomerSelected: onCustomerSelectedWide,
            selectedCustomer: _selectedCustomer,
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedCustomer != null
              ? CustomerDetailView(
                  customer: _selectedCustomer!,
                  updateCustomer: onUpdateCustomer,
                  deleteCustomer: onDeleteCustomer,
                )
              : const Center(child: Text('Select a customer to view details')),
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
            onCustomerSelected: onCustomerSelected,
            selectedCustomer: _selectedCustomer,
          ),
        ),
      ],
    );
  }

  Widget showAddCustomerButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCustomerPage(
                        title: 'Add Customer',
                        addNewCustomer: onAddNewCustomer,
                      )),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
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
          showAddCustomerButton(),
        ],
      ),
    );
  }
}
