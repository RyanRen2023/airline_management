import 'package:airline_management/database/database.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/airplane/Airplane.dart';
import 'package:airline_management/airplane/AirplaneDAO.dart';

import 'AirplaneDAO.dart';

class AirplaneDetailView extends StatefulWidget {
  AirplaneDetailView({super.key, required this.airplane});
  final Airplane airplane;
  //final String title;

  @override
  State<StatefulWidget> createState() => _AirplaneDetailViewState(airplane);

}


class _AirplaneDetailViewState extends State<AirplaneDetailView> {
  final Airplane airplane;
  late AirplaneDAO airplaneDAO;

  _AirplaneDetailViewState(this.airplane);

  final TextEditingController _airplaneTypeController = TextEditingController();
  final TextEditingController _numberOfPassengersController =
      TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeToFlyController = TextEditingController();

  @override
  void initState() {
    $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build()
        .then((database) async {
      airplaneDAO = database.airplaneDAO;
    });
  }

  @override
  Widget build(BuildContext context) {
    _airplaneTypeController.text = airplane.airplaneType;
    _numberOfPassengersController.text = airplane.numberOfPassengers.toString();
    _maxSpeedController.text = airplane.maxSpeed.toString();
    _rangeToFlyController.text = airplane.rangeToFly.toString();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Update airplane logic here
                  var id=airplane.id;
                  var airplaneType=_airplaneTypeController.value.text;
                  var numberOfPassengers=int.parse(_numberOfPassengersController.value.text);
                  var maxSpeed=int.parse(_maxSpeedController.value.text);
                  var rangeToFly=int.parse(_rangeToFlyController.value.text);
                  var newAirplane=new Airplane(id: id, airplaneType: airplaneType, numberOfPassengers: numberOfPassengers, maxSpeed: maxSpeed, rangeToFly: rangeToFly);
                  airplaneDAO.updateAirplane(newAirplane);
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Delete airplane logic here
                },
                child: Text('Delete'),
              ),
            ],
          ),
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
        ],
      ),
    );
  }
}
