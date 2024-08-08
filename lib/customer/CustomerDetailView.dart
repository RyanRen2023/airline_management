import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';
import 'package:intl/intl.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';

/// A stateless widget that displays and allows editing of a customer's details.
class CustomerDetailView extends StatelessWidget {
  /// The customer to display and edit.
  final Customer customer;

  /// Callback function to update a customer.
  final Function(Customer) updateCustomer;

  /// Callback function to delete a customer.
  final Function(Customer) deleteCustomer;

  /// Creates a [CustomerDetailView].
  ///
  /// The [customer], [updateCustomer], and [deleteCustomer] parameters must not be null.
  CustomerDetailView({
    super.key,
    required this.customer,
    required this.updateCustomer,
    required this.deleteCustomer,
  });

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<String> _birthdayNotifier = ValueNotifier<String>("");

  /// Updates the customer details.
  ///
  /// Returns `true` if the update is successful, `false` otherwise.
  bool updateCustomers() {
    if (_formKey.currentState!.validate()) {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String address = _addressController.text;
      String birthday = _birthdayNotifier.value;

      Customer updatedCustomer = Customer(
        id: customer.id,
        firstName: firstName,
        lastName: lastName,
        address: address,
        birthday: birthday,
      );

      updateCustomer(updatedCustomer);
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
            ),
          ],
        );
      },
    );
  }

  /// Deletes the customer.
  void deleteCustomers() {
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
      _birthdayNotifier.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controller text with current customer information
    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _addressController.text = customer.address;
    _birthdayController.text = customer.birthday;

    _birthdayNotifier.value = customer.birthday;

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
                    .translate(Const.FIRST_NAME)!,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .translate(Const.FIRST_NAME_CANNOT_BE_EMPTY)!;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translate(Const.LAST_NAME)!,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .translate(Const.LAST_NAME_CANNOT_BE_EMPTY)!;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translate(Const.LABEL_ADDRESS)!,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .translate(Const.ADDRESS_CANNOT_BE_EMPTY)!;
                }
                return null;
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: _birthdayNotifier,
              builder: (context, value, child) {
                _birthdayController.text = value;
                return TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate(Const.LABEL_BIRTHDAY)!,
                  ),
                  onTap: () {
                    // Hide the keyboard and show the date picker
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate(context);
                  },
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate(Const.BIRTHDAY_CANNOT_BE_EMPTY)!;
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: updateCustomers,
                  child: Text(AppLocalizations.of(context)!
                      .translate(Const.BUTTON_UPDATE)!),
                ),
                ElevatedButton(
                  onPressed: () => deleteDialogConfirm(context),
                  child: Text(AppLocalizations.of(context)!
                      .translate(Const.BUTTON_DELETE)!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}