import 'package:flutter/material.dart';
import 'package:airline_management/customer/Customer.dart';



class CustomerListPage extends StatelessWidget {

  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;
  final Customer? selectedCustomer;
  const CustomerListPage({
    super.key,
    required this.customers,
    required this.onCustomerSelected,
    required this.selectedCustomer,
  });

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${customers[index].firstName} ${customers[index].lastName}'),
          selected: selectedCustomer == customers[index],
          onTap: () {
            onCustomerSelected(customers[index]);
          },
        );
      },
    );
  }
}
