import 'package:flutter/material.dart';

import 'Airplane.dart';

class AddAirplanePage extends StatefulWidget {
  AddAirplanePage({super.key,required this.title,required this.addNewAirplane});
  final Function(Airplane) addNewAirplane;
  final String title;

  @override
  State<StatefulWidget> createState() => _AddAirplanePageState();

}


class _AddAirplanePageState extends State<AddAirplanePage>{
  final TextEditingController _airplaneTypeController = TextEditingController();
  final TextEditingController _numberOfPassengersController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeToFlyController = TextEditingController();
  void submitNewCustomer()async {
    var airplaneType = _airplaneTypeController.text;
    var numberOfPassengers = _numberOfPassengersController.text;
    var maxSpeed = _maxSpeedController.text;
    var rangeToFly = _rangeToFlyController.text;
    widget.addNewAirplane(Airplane(airplaneType: airplaneType,numberOfPassengers: int.parse(numberOfPassengers),maxSpeed: int.parse(maxSpeed),rangeToFly: int.parse(rangeToFly)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _airplaneTypeController,
              decoration: InputDecoration(labelText: 'Airplane Type'),
            ),
            TextField(
              controller: _numberOfPassengersController,
              decoration: InputDecoration(labelText: 'Number Of Passengers'),
            ),
            TextField(
              controller: _maxSpeedController,
              decoration: InputDecoration(labelText: 'Max Speed'),
            ),
            TextField(
              controller: _rangeToFlyController,
              decoration: InputDecoration(labelText: 'Range To Fly'),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              ElevatedButton(
                onPressed: () async{
                  submitNewCustomer();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],)
          ],
        ),
      ),
    );
  }
}

