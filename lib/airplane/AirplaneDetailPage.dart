import 'package:airline_management/airplane/AirplaneDetailView.dart';
import 'package:flutter/material.dart';

import 'Airplane.dart';

///widget to construct selected airplane detail page
class AirplaneDetailPage extends StatefulWidget {
  Airplane airplane;
  final String title;
  Function(Airplane) updateAirplane;
  Function(Airplane) deleteAirplane;

  ///airplane constructor
  AirplaneDetailPage({
    super.key,
    required this.title,
    required this.airplane,
    required this.updateAirplane,
    required this.deleteAirplane});

  ///AirplaneDetailPageState widget
  @override
  State<StatefulWidget> createState() => _AirplaneDetailPageState();
}

///updates airplane detail
class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  /// updates [airplane]
  void updateAirplane(Airplane airplane){
    widget.updateAirplane(airplane);
    Navigator.of(context).pop();
  }

  /// deletes [airplane]
  void deleteAirplane(Airplane airplane){
    widget.deleteAirplane(airplane);
    Navigator.of(context).pop();
  }

  ///builds update page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: AirplaneDetailView(
        airplane: widget.airplane,
        updateAirplane: updateAirplane,
        deleteAirplane: deleteAirplane,
      ),
    );
  }
}


