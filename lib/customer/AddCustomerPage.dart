import 'package:airline_management/Properties.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
import 'Customer.dart';

class AddCustomerPage extends StatefulWidget {
  AddCustomerPage(
      {super.key,
      required this.title,
      required this.addNewCustomer,
      required this.createFromLast,
      this.preCustomer});
  final Function(Customer) addNewCustomer;
  final String title;
  final bool createFromLast;
  final Customer? preCustomer;

  @override
  State<StatefulWidget> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      return 'First name cannot be empty';
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
                      return 'Last name cannot be empty';
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
                      return 'Address cannot be empty';
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
                      return 'Birthday cannot be empty';
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
