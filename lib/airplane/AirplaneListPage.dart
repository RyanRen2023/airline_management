import 'package:flutter/material.dart';
import 'package:airline_management/airplane/Airplane.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';

///Stateless widget for airplane list page
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

  ///build widget ListView to display saved airplanes
  @override
  Widget build(BuildContext context) {
    final String message = AppLocalizations.of(context)!
        .translate(Const.MESSAGE_NO_AIRPLANE_ON_LIST)!;
    return Container(
        height: double.infinity, // Ensure the ListView takes the full height
        child: airplanes.isEmpty
            ? Center(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: airplanes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${airplanes[index].id}. '
                        '${airplanes[index].airplaneType}, '
                        '${airplanes[index].numberOfPassengers}, '
                        '${airplanes[index].maxSpeed}, '
                        '${airplanes[index].rangeToFly}'),
                    selected: selectedAirplane == airplanes[index],
                    onTap: () {
                      onAirplaneSelected(airplanes[index]);
                    },
                  );
                },
              ));
  }
}
