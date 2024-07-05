import 'package:flutter/material.dart';

class FlightsPage extends StatefulWidget{
  const FlightsPage({super.key,required this.title});
  
  final String title;

  @override
  State<StatefulWidget> createState() => _FlightsPageState();

}

class _FlightsPageState extends State<FlightsPage>{
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
            Text("Flight"),
        ],
      ),
    ),
    );
  }
  
}