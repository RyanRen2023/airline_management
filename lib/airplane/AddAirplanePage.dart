import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
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

  void submitNewAirplane()async {
    var airplaneType = _airplaneTypeController.text;
    var numberOfPassengers = _numberOfPassengersController.text;
    var maxSpeed = _maxSpeedController.text;
    var rangeToFly = _rangeToFlyController.text;
    widget.addNewAirplane(
        Airplane(
            airplaneType: airplaneType,
            numberOfPassengers: int.parse(numberOfPassengers),
            maxSpeed: int.parse(maxSpeed),
            rangeToFly: int.parse(rangeToFly)));
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
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(Const.AIRPLANE_TYPE)!),
            ),
            TextField(
              controller: _numberOfPassengersController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(Const.NUMBER_OF_PASSENGERS)!),
            ),
            TextField(
              controller: _maxSpeedController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(Const.MAX_SPEED)!),
            ),
            TextField(
              controller: _rangeToFlyController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(Const.RANGE_TO_FLY)!),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              ElevatedButton(
                onPressed: () async{
                  submitNewAirplane();
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.translate(Const.BUTTON_SUBMIT)!),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.translate(Const.GO_BACK)!),
              ),
            ],)
          ],
        ),
      ),
    );
  }
}

