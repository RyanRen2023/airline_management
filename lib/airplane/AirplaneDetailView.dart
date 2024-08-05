import 'package:flutter/material.dart';
import 'package:airline_management/airplane/Airplane.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';

class AirplaneDetailView extends StatelessWidget {
  Airplane airplane;
  Function(Airplane) updateAirplane;
  Function(Airplane) deleteAirplane;

  AirplaneDetailView(
      {super.key,
        required this.airplane,
        required this.updateAirplane,
        required this.deleteAirplane});

  final TextEditingController _airplaneTypeController = TextEditingController();
  final TextEditingController _numberOfPassengersController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeToFlyController = TextEditingController();

  void updateAirplanes() {

    Airplane oldAirplane = this.airplane;
    String airplaneType = _airplaneTypeController.value.text;
    int numberOfPassengers = int.parse(_numberOfPassengersController.value.text);
    int maxSpeed = int.parse(_maxSpeedController.value.text);
    int rangeToFly = int.parse(_rangeToFlyController.value.text);

    Airplane newAirplane = Airplane(
        id: oldAirplane.id,
        airplaneType: airplaneType,
        numberOfPassengers: numberOfPassengers,
        maxSpeed: maxSpeed,
        rangeToFly: rangeToFly);

    ///database update
    updateAirplane(newAirplane);
  }

  void deleteDialogConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate(Const.DIALOG_CONFIRM_DELETE_AIRPLANE_TITLE)!),
          content: Text(AppLocalizations.of(context)!.translate(Const.DIALOG_CONFIRM_DELETE_AIRPLANE_CONTENT)!),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.BUTTON_OK)!),
              onPressed: () {
                deleteAirplanes();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.BUTTON_CANCEL)!),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void deleteAirplanes() {
    Airplane old = this.airplane;
    Airplane airplane = Airplane(

        id: old.id,
        airplaneType: old.airplaneType,
        numberOfPassengers: old.numberOfPassengers,
        maxSpeed: old.maxSpeed,
        rangeToFly: old.rangeToFly);

    deleteAirplane(airplane);
  }

  @override
  Widget build(BuildContext context) {
    Airplane selectedAirplane = airplane;

    _airplaneTypeController.text = selectedAirplane.airplaneType;
    _numberOfPassengersController.text = selectedAirplane.numberOfPassengers.toString();
    _maxSpeedController.text = selectedAirplane.maxSpeed.toString();
    _rangeToFlyController.text = selectedAirplane.rangeToFly.toString();

    return SafeArea( // control overflow with scrolling in landscape view
        child: SingleChildScrollView(
          child:Padding(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: updateAirplanes,
                child: Text(AppLocalizations.of(context)!.translate(Const.BUTTON_UPDATE)!),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteDialogConfirm(context);
                },
                child: Text(AppLocalizations.of(context)!.translate(Const.BUTTON_DELETE)!),
              ),
            ],
          ),
        ],
      ),
    )));
  }
}
