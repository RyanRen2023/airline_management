import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
import 'Airplane.dart';

///a stateful widget to add a new airplane
class AddAirplanePage extends StatefulWidget {
  AddAirplanePage({
    super.key,
    required this.title,
    required this.addNewAirplane});
  final Function(Airplane) addNewAirplane;
  final String title;

  @override
  State<StatefulWidget> createState() => _AddAirplanePageState();

}

///state for [AddAirplanePageState]
class _AddAirplanePageState extends State<AddAirplanePage>{
  ///Controllers for textFields with airplane fields
  final TextEditingController _airplaneTypeController = TextEditingController();
  final TextEditingController _numberOfPassengersController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeToFlyController = TextEditingController();

  ///global key [_formKey] validates field value
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///creates and submits new airplane
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

  ///builds form of adding new airplane
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(widget.title),
    ),
      body: SafeArea( // control overflow with scrolling in landscape view
        child: SingleChildScrollView(
        child: Padding(
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                  submitNewAirplane();
                  Navigator.pop(context); }
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
    ))));
  }
}

