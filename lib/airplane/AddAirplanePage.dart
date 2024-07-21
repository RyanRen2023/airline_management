import 'dart:ffi';

import 'package:airline_management/database/database.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/airplane/AirplaneDAO.dart';

import 'Airplane.dart';

class AddAirplanePage extends StatefulWidget {
  AddAirplanePage({super.key,required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _AddAddAirplanePageState();

}


class _AddAddAirplanePageState extends State<AddAirplanePage>{
  final TextEditingController _airplaneTypeController = TextEditingController();
  final TextEditingController _numberOfPassengersController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeToFlyController = TextEditingController();
  late AirplaneDAO airplaneDAO;
  late List<Airplane> airplanes;
  @override
  void initState() {
    super.initState();

    $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build()
        .then((database) async {
      airplaneDAO = database.airplaneDAO;
    });
  }

  Future<int> _getNewAirplaneId() async {
    final newId = await airplaneDAO.getNewAirplaneId();
    if(newId==null){
      return 0;
    }else{
      return newId;
    }
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
                  var id=await _getNewAirplaneId();
                  var airplaneType=_airplaneTypeController.value.text;
                  var numberOfPassengers=int.parse(_numberOfPassengersController.value.text);
                  var maxSpeed=int.parse(_maxSpeedController.value.text);
                  var rangeToFly=int.parse(_rangeToFlyController.value.text);
                  var newAirplane=new Airplane(id: id, airplaneType: airplaneType, numberOfPassengers: numberOfPassengers, maxSpeed: maxSpeed, rangeToFly: rangeToFly);
                  airplaneDAO.insertAirplane(newAirplane);
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

