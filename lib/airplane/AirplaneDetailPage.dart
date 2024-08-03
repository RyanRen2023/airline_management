import 'package:airline_management/airplane/AirplaneDetailView.dart';
import 'package:flutter/material.dart';

import 'Airplane.dart';

class AirplaneDetailPage extends StatefulWidget {
  Airplane airplane;
  final String title;
  Function(Airplane) updateAirplane;
  Function(Airplane) deleteAirplane;

  AirplaneDetailPage({
    super.key,
    required this.title,
    required this.airplane,
    required this.updateAirplane,
    required this.deleteAirplane});

  @override
  State<StatefulWidget> createState() => _AirplaneDetailPageState();
}

class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  void updateAirplane(Airplane airplane){
    widget.updateAirplane(airplane);
    Navigator.of(context).pop();
  }

  void deleteAirplane(Airplane airplane){
    widget.deleteAirplane(airplane);
    Navigator.of(context).pop();
  }

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


