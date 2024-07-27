
import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';

class CustomerDetailView extends StatelessWidget {
  Customer customer;
  Function(Customer) updateCustomer;
  Function(Customer) deleteCustomer;

  CustomerDetailView(
      {super.key,
      required this.customer,
      required this.updateCustomer,
      required this.deleteCustomer});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  void updateCustomers() {
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
  }

  void deleteDialogConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm to Delete Customer?'),
          content: Text('Confirm to Delete Customer?'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                deleteCustomers();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    Customer cus = customer!;
    _firstNameController.text = cus.firstName!;
    _lastNameController.text = cus.lastName!;
    _addressController.text = cus.address;
    _birthdayController.text = cus.birthday;

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
                onPressed: updateCustomers,
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteDialogConfirm(context);
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
