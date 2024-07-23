import 'package:airline_management/Properties.dart';
import 'package:flutter/material.dart';

import 'Customer.dart';

class AddCustomerPage extends StatefulWidget {
  AddCustomerPage(
      {super.key, required this.title, required this.addNewCustomer});
  final Function(Customer) addNewCustomer;
  final String title;

  @override
  State<StatefulWidget> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  void submitNewCustomer() {
    var firstName = _firstNameController.text;
    var lastName = _lastNameController.text;
    var address = _addressController.text;
    var birthday = _birthdayController.text;
    widget.addNewCustomer(Customer(firstName: firstName, lastName: lastName, address: address, birthday: birthday));
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
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                  labelText:
                      Properties.LABLE_FIRST_NAME[Properties.lang_index]),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            SizedBox(height: Properties.SIZEDBOX_HIGHT),
            ElevatedButton(
              onPressed: () {
                // Add customer logic here
                submitNewCustomer();
                Navigator.pop(context);
              },
              child: Text(Properties.BUTTON_SUBMIT[Properties.lang_index]),
            ),
          ],
        ),
      ),
    );
  }
}
