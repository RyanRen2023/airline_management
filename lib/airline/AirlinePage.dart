import 'package:flutter/material.dart';

class AirlinePage extends StatefulWidget{
  const AirlinePage({super.key,required this.title});
  
  final String title;

  @override
  State<StatefulWidget> createState() => _AirlinePageState();

}

class _AirlinePageState extends State<AirlinePage>{
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
           Text("Airline"),
          ],
        ),
      ),
    );
  }
  
}