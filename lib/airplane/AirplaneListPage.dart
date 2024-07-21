import 'package:flutter/material.dart';
import 'package:airline_management/airplane/AirplaneDetailPage.dart';
import 'package:airline_management/airplane/Airplane.dart';

class AirplaneListPage extends StatelessWidget {

  final List<Airplane> airplanes;
  final Function(Airplane) onAirplaneSelected;
  final Airplane? selectedAirplane;
  const AirplaneListPage({
    super.key,
    required this.airplanes,
    required this.onAirplaneSelected,
    required this.selectedAirplane,
  });

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: airplanes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${airplanes[index].airplaneType} ${airplanes[index].numberOfPassengers} ${airplanes[index].maxSpeed} ${airplanes[index].rangeToFly}'),
          selected: selectedAirplane == airplanes[index],
          onTap: () {
            onAirplaneSelected(airplanes[index]);
          },
        );
      },
    );
  }
}