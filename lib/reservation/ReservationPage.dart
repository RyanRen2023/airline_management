import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget{
  const ReservationPage({super.key,required this.title});
  
  final String title;

  @override
  State<StatefulWidget> createState() => _ReservationPageState();

}

class _ReservationPageState extends State<ReservationPage>{
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
            Text("Reservation"),
          ],
        ),
      ),
    );
  }
  
}