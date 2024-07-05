import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget{
  const CustomerPage({super.key,required this.title});
  
  final String title;

  @override
  State<StatefulWidget> createState() => _CustomerPageState();

}

class _CustomerPageState extends State<CustomerPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Customer"),
          ],
        ),
      ),
    );
  }
  
}