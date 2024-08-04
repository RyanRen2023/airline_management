import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';
import 'package:intl/intl.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';

/// A stateless widget that displays and allows editing of a customer's details.
class CustomerDetailView extends StatelessWidget {
  /// The customer to display and edit.
  Customer customer;
  /// Callback function to update a customer.
  Function(Customer) updateCustomer;
  /// Callback function to delete a customer.
  Function(Customer) deleteCustomer;
  /// Creates a [CustomerDetailView].
  ///
  /// The [customer], [updateCustomer], and [deleteCustomer] parameters must not be null.
  CustomerDetailView(
      {super.key,
      required this.customer,
      required this.updateCustomer,
      required this.deleteCustomer});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  /// Updates the customer details.
  ///
  /// Returns `true` if the update is successful, `false` otherwise.
  bool updateCustomers() {
    if (_formKey.currentState!.validate()) {
      Customer cus = this.customer;
      String firstName = _firstNameController.value.text;
      String lastName = _lastNameController.value.text;
      String address = _addressController.value.text;
      String birthday = _birthdayController.value.text;
      Customer customer = Customer(
          id: cus.id,
          firstName: firstName,
          lastName: lastName,
          address: address,
          birthday: birthday);
      updateCustomer(customer);
      return true;
    } else {
      return false;
    }
  }
  /// Shows a confirmation dialog to delete the customer.
  ///
  /// [context] - The build context.
  void deleteDialogConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .translate(Const.DIALOG_CONFIRM_DELETE_TITLE)!),
          content: Text(AppLocalizations.of(context)!
              .translate(Const.DIALOG_CONFIRM_DELETE_CONTENT)!),
          actions: <Widget>[
            TextButton(
              child: Text(
                  AppLocalizations.of(context)!.translate(Const.BUTTON_OK)!),
              onPressed: () {
                deleteCustomers();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!
                  .translate(Const.BUTTON_CANCEL)!),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  /// Deletes the customer.
  void deleteCustomers() {
    Customer cus = this.customer!;
    Customer customer = Customer(
        id: cus.id,
        firstName: cus.firstName,
        lastName: cus.lastName,
        address: cus.address,
        birthday: cus.birthday);
    deleteCustomer(customer);
  }
  /// Shows a date picker dialog to select the customer's birthday.
  ///
  /// [context] - The build context.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    Customer cus = customer;
    _firstNameController.text = cus.firstName;
    _lastNameController.text = cus.lastName;
    _addressController.text = cus.address;
    _birthdayController.text = cus.birthday;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate(Const.FIRST_NAME)!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate(Const.LAST_NAME)!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate(Const.LABEL_ADDRESS)!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate(Const.LABEL_BIRTHDAY)!),
                onTap: () {
                  // Hide the keyboard when the date picker is shown
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context);
                },
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Birthday cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      updateCustomers();
                    },
                    child: Text(AppLocalizations.of(context)!
                        .translate(Const.BUTTON_UPDATE)!),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteDialogConfirm(context);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .translate(Const.BUTTON_DELETE)!),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
