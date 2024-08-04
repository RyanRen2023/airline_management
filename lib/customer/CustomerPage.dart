import 'package:airline_management/database/DatabaseOperator.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/customer/AddCustomerPage.dart';
import 'package:airline_management/customer/CustomerListPage.dart';
import 'package:airline_management/customer/Customer.dart';
import 'package:airline_management/customer/CustomerDetailView.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
import 'CustomerDAO.dart';
import 'CustomerDetailPage.dart';

/// A StatefulWidget that represents the Customer Page in the Airline Management System.
class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _CustomerPageState();
}

/// State for [CustomerPage].
class _CustomerPageState extends State<CustomerPage> {
  Customer? _selectedCustomer;
  late CustomerDAO? customerDAO;
  List<Customer> customers = [];
  final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();

  /// Adds the previous customer to the preferences.
  ///
  /// [customer] - The customer to save in preferences.
  void savePreviousCustomerToPreference(Customer customer) {
    _preferences.setString("cus_firstname", customer.firstName);
    _preferences.setString("cus_lastname", customer.lastName);
    _preferences.setString("cus_birthday", customer.birthday);
    _preferences.setString("cus_address", customer.address);
  }

  /// Loads the previous customer from preferences.
  ///
  /// Returns a [Customer] if data is found in preferences, otherwise null.
  Future<Customer?> loadPreviousCustomerFromPreference() async {
    // Retrieve customer information from preferences

    String? firstName = await _preferences.getString('cus_firstname');
    String? lastName = await _preferences.getString('cus_lastname');
    String? birthday = await _preferences.getString('cus_birthday');
    String? address = await _preferences.getString('cus_address');

    // Check if any of the fields are null
    if (firstName.isEmpty) {
      // If any field is null, return null indicating no complete customer data in preferences
      return null;
    }

    // Create a Customer object and return it
    Customer preCustomer = Customer(
      firstName: firstName,
      lastName: lastName,
      address: address,
      birthday: birthday,
    );
    return preCustomer;
  }

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
  /// Handles customer selection in wide screen mode.
  ///
  /// [customer] - The selected customer.
  void onCustomerSelectedWide(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }
  /// Handles customer selection.
  ///
  /// [customer] - The selected customer.
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
  /// Handles adding a new customer.
  ///
  /// [customer] - The customer to add.
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
    savePreviousCustomerToPreference(newCus);

    showSnackBar(
        AppLocalizations.of(context)!.translate(Const.SNACKBAR_ADD_SUCCESS)!);
  }
  /// Handles updating a customer.
  ///
  /// [customer] - The customer to update.
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
  /// Handles deleting a customer.
  ///
  /// [customer] - The customer to delete.
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
    showSnackBar(AppLocalizations.of(context)!
        .translate(Const.SNACKBAR_DELETE_SUCCESS)!);
  }
  /// Displays a SnackBar with a given message.
  ///
  /// [message] - The message to display in the SnackBar.
  void showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  /// Builds the responsive layout for the Customer Page.
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
  /// Builds the wide screen layout.
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
              : Center(
                  child: Text(AppLocalizations.of(context)!
                      .translate(Const.SNACKBAR_ADD_SUCCESS)!)),
        ),
      ],
    );
  }
  /// Builds the normal screen layout.
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
  /// Builds the add customer button.
  Widget showAddCustomerButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            // prompt weather create from last customer.
            NavigateToAddCustomerPage();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  /// Displays a dialog for adding a customer.
  ///
  /// [context] - The BuildContext of the widget.
  /// [preCustomer] - The previous customer data to prefill.
  void showDialogForAddCustomer(BuildContext context, Customer preCustomer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .translate(Const.DIALOG_CONFIRM_CREATE_FROM_PRECUSTOMER)!),
          content: Text(AppLocalizations.of(context)!
              .translate(Const.DIALOG_CONFIRM_CREATE_FROM_PRECUSTOMER)!),
          actions: <Widget>[
            TextButton(
              child: Text(
                  AppLocalizations.of(context)!.translate(Const.BUTTON_OK)!),
              onPressed: () {
                // when choose ok ,build customer from previous customer
                Navigator.of(context).pop();
                createCustomerByPreCustomer(preCustomer);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.NO)!),
              onPressed: () {
                // when choose No ,build customer from previous customer
                Navigator.of(context).pop();
                createCustomer();
              },
            )
          ],
        );
      },
    );
  }
  /// Navigates to the AddCustomerPage.
  void createCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddCustomerPage(
              title: AppLocalizations.of(context)!
                  .translate(Const.TITLE_ADD_CUSTOMER)!,
              addNewCustomer: onAddNewCustomer,
              createFromLast: false)),
    );
  }
  /// Navigates to the AddCustomerPage pre-filled with previous customer data.
  ///
  /// [preCustomer] - The previous customer data to prefill.
  void createCustomerByPreCustomer(Customer preCustomer) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddCustomerPage(
              title: AppLocalizations.of(context)!
                  .translate(Const.TITLE_ADD_CUSTOMER)!,
              addNewCustomer: onAddNewCustomer,
              createFromLast: true,
              preCustomer: preCustomer)),
    );
  }
  /// Navigates to the AddCustomerPage.
  Future<void> NavigateToAddCustomerPage() async {
    Customer? preCustomer = await loadPreviousCustomerFromPreference();
    if (preCustomer != null) {
      showDialogForAddCustomer(context, preCustomer);
    } else {
      createCustomer();
    }
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
