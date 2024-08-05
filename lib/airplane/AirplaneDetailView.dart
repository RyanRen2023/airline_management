import 'package:flutter/material.dart';
import 'package:airline_management/airplane/Airplane.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';

///airplane detail statelessWidget with [airplane],[updateAirplane],[deleteAirplane]
class AirplaneDetailView extends StatelessWidget {
  Airplane airplane;
  Function(Airplane) updateAirplane;
  Function(Airplane) deleteAirplane;
  ///global key [_formKey] validates field value
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///detail constructor
  AirplaneDetailView(
      {super.key,
        required this.airplane,
        required this.updateAirplane,
        required this.deleteAirplane});

  ///controller for each airplane field
  final TextEditingController _airplaneTypeController = TextEditingController();
  final TextEditingController _numberOfPassengersController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeToFlyController = TextEditingController();

  ///update airplane and store change to database
  void updateAirplanes() {

    Airplane oldAirplane = this.airplane;
    String airplaneType = _airplaneTypeController.value.text;
    int numberOfPassengers = int.parse(_numberOfPassengersController.value.text);
    int maxSpeed = int.parse(_maxSpeedController.value.text);
    int rangeToFly = int.parse(_rangeToFlyController.value.text);

    ///updated airplane with old airplane id and new values of other fields
    Airplane newAirplane = Airplane(
        id: oldAirplane.id,
        airplaneType: airplaneType,
        numberOfPassengers: numberOfPassengers,
        maxSpeed: maxSpeed,
        rangeToFly: rangeToFly);

    ///database update
    updateAirplane(newAirplane);
  }

  ///confirm a delete action
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

  ///delete old airplane from database
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

  ///build widget to display selected airplane detail with update and delete functions
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
            child: Form(
            key: _formKey,
            child: Column(
            children: <Widget>[
          TextFormField(
            controller: _airplaneTypeController,
            decoration: InputDecoration(
                hintText: 'Boeing 737',
                labelText: AppLocalizations.of(context)!.translate(Const.AIRPLANE_TYPE)!),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.translate(Const.MESSAGE_ERROR_EMPTY)!;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _numberOfPassengersController,
            decoration: InputDecoration(
                hintText: 'usually between 100 and 200',
                labelText: AppLocalizations.of(context)!.translate(Const.NUMBER_OF_PASSENGERS)!),
            validator: (value) {
              if (value!.isEmpty || int.tryParse(value) == null) {
                return AppLocalizations.of(context)!.translate(Const.MESSAGE_ERROR_NOT_INT)!;
              }
              return null;
            },
          ),

          TextFormField(
            controller: _maxSpeedController,
            decoration: InputDecoration(
                hintText: 'usually around 1000',
                labelText: AppLocalizations.of(context)!.translate(Const.MAX_SPEED)!),
            validator: (value) {
              if (value!.isEmpty || int.tryParse(value) == null) {
                return AppLocalizations.of(context)!.translate(Const.MESSAGE_ERROR_NOT_INT)!;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _rangeToFlyController,
            decoration: InputDecoration(
                hintText: 'usually between 5500 and 6500',
                labelText: AppLocalizations.of(context)!.translate(Const.RANGE_TO_FLY)!),
            validator: (value) {
              if (value!.isEmpty || int.tryParse(value) == null) {
                return AppLocalizations.of(context)!.translate(Const.MESSAGE_ERROR_NOT_INT)!;
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  updateAirplanes();}
                },
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
    ))));
  }
}
