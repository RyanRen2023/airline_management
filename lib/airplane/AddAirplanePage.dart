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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(widget.title),
    ),
      body: Padding(
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
                  return 'Airplane Type cannot be empty';
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
                      return 'Please enter a valid integer';
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
                      return 'Please enter a valid integer';
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
                      return 'Please enter a valid integer';
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
    ));
  }
}

