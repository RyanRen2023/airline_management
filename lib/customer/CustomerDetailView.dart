import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';

class CustomerDetailView extends StatelessWidget {
  final Customer customer;

  CustomerDetailView({super.key, required this.customer});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _addressController.text = customer.address;
    _birthdayController.text = customer.birthday;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Update customer logic here
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Delete customer logic here
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}