import 'package:airline_management/database/DatabaseOperator.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/customer/AddCustomerPage.dart';
import 'package:airline_management/customer/CustomerListPage.dart';
import 'package:airline_management/customer/Customer.dart';
import 'package:airline_management/customer/CustomerDetailView.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
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
          title: AppLocalizations.of(context)!
              .translate(Const.TITLE_CUSTOMER_DETAIL)!,
          customer: _selectedCustomer!,
          updateCustomer: onUpdateCustomer,
          deleteCustomer: onDeleteCustomer,
        );
      }),
    );
  }

  void onAddNewCustomer(Customer customer) async {
    int? customerId = await customerDAO?.insertCustomer(customer);
    Customer newCus = Customer(
        id: customerId,
        firstName: customer.firstName,
        lastName: customer.lastName,
        address: customer.address,
        birthday: customer.birthday);
    setState(() {
      customers.add(newCus);
    });

    showSnackBar(
        AppLocalizations.of(context)!.translate(Const.SNACKBAR_ADD_SUCCESS)!);
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
    showSnackBar(AppLocalizations.of(context)!
        .translate(Const.SNACKBAR_UPDATE_SUCCESS)!);
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
    setState(() {
      _selectedCustomer = null;
    });
    showSnackBar(AppLocalizations.of(context)!.translate(Const.SNACKBAR_DELETE_SUCCESS)!);
  }

  void showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              :  Center(child: Text(AppLocalizations.of(context)!.translate(Const.SNACKBAR_ADD_SUCCESS)!)),
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
                        title: AppLocalizations.of(context)!.translate(Const.TITLE_ADD_CUSTOMER)!,
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
