import 'package:airline_management/Properties.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
import 'Customer.dart';
/// A stateful widget that provides a form for adding a new customer.
class AddCustomerPage extends StatefulWidget {
  /// Creates an [AddCustomerPage].
  ///
  /// The [title], [addNewCustomer], and [createFromLast] parameters must not be null.
  /// The [preCustomer] parameter is optional and used only if [createFromLast] is true.
  AddCustomerPage(
      {super.key,
      required this.title,
      required this.addNewCustomer,
      required this.createFromLast,
      this.preCustomer});

  /// Callback function to add a new customer.
  final Function(Customer) addNewCustomer;
  /// The title of the page.
  final String title;
  /// A flag indicating whether to prefill the form with data from the previous customer.
  final bool createFromLast;
  /// The previous customer data to prefill the form, if any.
  final Customer? preCustomer;

  @override
  State<StatefulWidget> createState() => _AddCustomerPageState();
}
/// State for [AddCustomerPage].
class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  /// Submits the new customer form if valid.
  void submitNewCustomer() {
    if (_formKey.currentState!.validate()) {
      var firstName = _firstNameController.text;
      var lastName = _lastNameController.text;
      var address = _addressController.text;
      var birthday = _birthdayController.text;
      widget.addNewCustomer(Customer(
          firstName: firstName,
          lastName: lastName,
          address: address,
          birthday: birthday));
      Navigator.pop(context);
    }
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
      setState(() {
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.createFromLast) {
      Customer preCustomer = widget.preCustomer!;
      _firstNameController.text = preCustomer.firstName;
      _lastNameController.text = preCustomer.lastName;
      _addressController.text = preCustomer.address;
      _birthdayController.text = preCustomer.birthday;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
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
                          .translate(Const.LAST_NAME)),
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
                          .translate(Const.LABEL_ADDRESS)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate(Const.ADDRESS_CANNOT_BE_EMPTY)!;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .translate(Const.LABEL_BIRTHDAY)),
                  onTap: () {
                    // Hide the keyboard when the date picker is shown
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
                ),
                SizedBox(height: Properties.SIZEDBOX_HIGHT),
                ElevatedButton(
                  onPressed: () {
                    // Add customer logic here
                    submitNewCustomer();
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate(Const.BUTTON_SUBMIT)!),
                ),
              ],
            ),
          )),
    );
  }
}
