import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';

class CustomerDetailView extends StatelessWidget {
  final Customer customer;
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

  void deleteCustomers() {
    Customer cus = this.customer;
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
                onPressed: updateCustomers,
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: deleteCustomers,
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
