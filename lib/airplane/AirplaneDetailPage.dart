import 'package:airline_management/airplane/AirplaneDetailView.dart';
import 'package:flutter/material.dart';

import 'Airplane.dart';

class AirplaneDetailPage extends StatefulWidget {
  Airplane airplane;
  final String title;

  AirplaneDetailPage({super.key, required this.title, required this.airplane});

  @override
  State<StatefulWidget> createState() => _AirplaneDetailPageState();
}

class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  @override
  Widget build(BuildContext context) {
    return AirplaneDetailView(airplane: widget.airplane);
  }
}
