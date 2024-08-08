
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:airline_management/database/DatabaseOperator.dart';
import 'FlightDao.dart';
import 'FlightItem.dart';
// Localization
import '../AppLocalizations.dart';
import '../const/Const.dart';

// Version 3 Flight Page
class FlightsPage extends StatefulWidget{
  const FlightsPage({super.key,required this.title});

  // set the title in main
  final String title;

  @override
  State<StatefulWidget> createState() => _FlightsPageState();

}

class _FlightsPageState extends State<FlightsPage> {
  // init the variables for control the input fields.
  final List<FlightItem> _flightsList = [];
  final TextEditingController _flightCodeController = TextEditingController();
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  late FlightDao _flightDao;
  final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();

  FlightItem? _selectedFlight;
  int _idCounter = 0;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadPreferences();
  }

  // init the database
  Future<void> _initDatabase() async {
    _flightDao = (await DatabaseOperator.getFlightsDAO())!;
    _loadFlights();
  }

  // load all flights from database
  Future<void> _loadFlights() async {
    final items = await _flightDao.findAllFlights();
    setState(() {
      _flightsList.addAll(items);
      _idCounter = items.isEmpty ? 0 : items.map((e) => e.id).reduce((a, b) =>
      a > b
          ? a
          : b) + 1;
    });
  }

  // load the record in device
  Future<void> _loadPreferences() async {
    _flightCodeController.text =
        await _preferences.getString('flightCode') ?? '';
    _departureCityController.text =
        await _preferences.getString('departureCity') ?? '';
    _destinationCityController.text =
        await _preferences.getString('destinationCity') ?? '';
    _departureTimeController.text =
        await _preferences.getString('departureTime') ?? '';
    _arrivalTimeController.text =
        await _preferences.getString('arrivalTime') ?? '';
  }

  // save the data in device
  Future<void> _savePreferences() async {
    await _preferences.setString('flightCode', _flightCodeController.text);
    await _preferences.setString(
        'departureCity', _departureCityController.text);
    await _preferences.setString(
        'destinationCity', _destinationCityController.text);
    await _preferences.setString(
        'departureTime', _departureTimeController.text);
    await _preferences.setString('arrivalTime', _arrivalTimeController.text);
  }

  // add flight item function
  void _addFlight() async {
    if (_flightCodeController.text.isNotEmpty &&
        _departureCityController.text.isNotEmpty &&
        _destinationCityController.text.isNotEmpty &&
        _departureTimeController.text.isNotEmpty &&
        _arrivalTimeController.text.isNotEmpty) {
      final flight = FlightItem(
        _idCounter++,
        _flightCodeController.text,
        _departureCityController.text,
        _destinationCityController.text,
        _departureTimeController.text,
        _arrivalTimeController.text,
      );
      await _flightDao.insertFlight(flight);
      setState(() {
        _flightsList.add(flight);
        _clearTextFields();
      });
      _savePreferences();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate(Const.FP_FLIGHT_ADDED)!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate(Const.FP_PLEASE_FILL_ALL_FIELDS)!)),
      );
    }
  }

  void _updateFlight() async {
    if (_selectedFlight != null &&
        _flightCodeController.text.isNotEmpty &&
        _departureCityController.text.isNotEmpty &&
        _destinationCityController.text.isNotEmpty &&
        _departureTimeController.text.isNotEmpty &&
        _arrivalTimeController.text.isNotEmpty) {
      final updatedFlight = FlightItem(
        _selectedFlight!.id,
        _flightCodeController.text,
        _departureCityController.text,
        _destinationCityController.text,
        _departureTimeController.text,
        _arrivalTimeController.text,
      );
      await _flightDao.updateFlight(updatedFlight);
      setState(() {
        final index = _flightsList.indexWhere((flight) =>
        flight.id == _selectedFlight!.id);
        _flightsList[index] = updatedFlight;
        _clearTextFields();
        _selectedFlight = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate(Const.FP_FLIGHT_UPDATED)!)),
      );
      _savePreferences();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate(Const.FP_PLEASE_FILL_ALL_FIELDS)!)),
      );
    }
  }

  // Add a delete alert dialog
  void _confirmDeleteFlight() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.translate(Const.FP_DELETE_FLIGHT)!),
            content: Text(AppLocalizations.of(context)!.translate(Const.FP_DELETE_FLIGHT_CONFIRMATION)!),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text(AppLocalizations.of(context)!.translate(Const.FP_CANCEL)!)
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteFlight();
                  }, child: Text(AppLocalizations.of(context)!.translate(Const.FP_DELETE_FLIGHT)!)
              ),
            ],
          );
        }
    );
  }

  void _deleteFlight() async {
    if (_selectedFlight != null) {
      await _flightDao.deleteFlight(_selectedFlight!);
      setState(() {
        _flightsList.remove(_selectedFlight);
        _selectedFlight = null;
        _clearTextFields();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate(Const.FP_FLIGHT_DELETED)!)
        ),
      );
    }
  }

  void _onFlightTapped(FlightItem flight) {
    setState(() {
      _selectedFlight = flight;
      _flightCodeController.text = flight.flightCode;
      _departureCityController.text = flight.departureCity;
      _destinationCityController.text = flight.destinationCity;
      _departureTimeController.text = flight.departureTime;
      _arrivalTimeController.text = flight.arrivalTime;
    });
  }

  void _clearTextFields() {
    _flightCodeController.clear();
    _departureCityController.clear();
    _destinationCityController.clear();
    _departureTimeController.clear();
    _arrivalTimeController.clear();
  }

  void _cancelEditing() {
    setState(() {
      _selectedFlight = null;
      _clearTextFields();
    });
  }

  Widget _buildFlightForm() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _flightCodeController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate(Const.FP_FLIGHT_CODE),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _departureCityController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate(Const.FP_DEPARTURE_CITY),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _destinationCityController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate(Const.FP_DESTINATION_CITY),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _departureTimeController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate(Const.FP_DEPARTURE_TIME),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _arrivalTimeController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate(Const.FP_ARRIVAL_TIME),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedFlight == null)
          ElevatedButton(
            onPressed: _addFlight,
            child: Text(AppLocalizations.of(context)!.translate(Const.FP_ADD_FLIGHT)!),
          )
        else
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _updateFlight,
                  child: Text(AppLocalizations.of(context)!.translate(Const.FP_UPDATE_FLIGHT)!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirmDeleteFlight,
                  child: Text(AppLocalizations.of(context)!.translate(Const.FP_DELETE_FLIGHT)!),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _cancelEditing,
                  child: Text(AppLocalizations.of(context)!.translate(Const.FP_CANCEL)!),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFlightList() {
    return Expanded(
      child: _flightsList.isEmpty
          ? Center(
        child: Text(AppLocalizations.of(context)!.translate(Const.FP_NO_FLIGHTS_IN_LIST)!),
      )
          : ListView.builder(
        itemCount: _flightsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(
                '${_flightsList[index].flightCode} - ${_flightsList[index]
                    .departureCity} to ${_flightsList[index].destinationCity}'),
            subtitle: Text(
                '${_flightsList[index].departureTime} - ${_flightsList[index]
                    .arrivalTime}'),
            onTap: () => _onFlightTapped(_flightsList[index]),
          );
        },
      ),
    );
  }

  // Add details page
  Widget _buildFlightDetails() {
    if (_selectedFlight == null) {
      return Center(child: Text(AppLocalizations.of(context)!.translate(Const.FP_NO_FLIGHT_SELECTED)!));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${AppLocalizations.of(context)!.translate(Const.FP_FLIGHT_CODE)}: ${_selectedFlight!.flightCode}',
              style: const TextStyle(fontSize: 18)),
          Text('${AppLocalizations.of(context)!.translate(Const.FP_DEPARTURE_CITY)}: ${_selectedFlight!.departureCity}',
              style: const TextStyle(fontSize: 18)),
          Text('${AppLocalizations.of(context)!.translate(Const.FP_DESTINATION_CITY)}: ${_selectedFlight!.destinationCity}',
              style: const TextStyle(fontSize: 18)),
          Text('${AppLocalizations.of(context)!.translate(Const.FP_DEPARTURE_TIME)}: ${_selectedFlight!.departureTime}',
              style: const TextStyle(fontSize: 18)),
          Text('${AppLocalizations.of(context)!.translate(Const.FP_ARRIVAL_TIME)}: ${_selectedFlight!.arrivalTime}',
              style: const TextStyle(fontSize: 18)),
          // const SizedBox(height: 20),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: _updateFlight,
          //         child: const Text('Updated Flight'),
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     Expanded(
          //         child: ElevatedButton(
          //          onPressed: _confirmDeleteFlight,
          //          child: const Text('Delete Flight'),
          //         )
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      // Tablet in landscape mode
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(AppLocalizations.of(context)!.translate(Const.FP_TITLE)!),
        ),
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildFlightForm(),
                  const SizedBox(height: 20),
                  _buildFlightList(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: _selectedFlight == null
                  ? Center(child: Text(AppLocalizations.of(context)!.translate(Const.FP_NO_FLIGHT_SELECTED)!))
                  : _buildFlightDetails(), // Updated with details page
            ),
          ],
        ),
      );
    } else {
      // Phone or device in portrait mode, show form and list
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(AppLocalizations.of(context)!.translate(Const.FP_TITLE)!),
        ),
        body: Column(
          children: [
            _buildFlightForm(),
            const SizedBox(height: 20),
            _buildFlightList(),
          ],
        ),
      );
    }
  }
}
// else {
//   // show details
//   return Scaffold(
//
//     appBar: AppBar(
//       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       title: const Text('Flights List'),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: () {
//           setState(() {
//             _selectedFlight = null;
//           });
//         },
//       ),
//     ),
//     body: _buildFlightDetails(), // Updated to use the new details page function
//     );
// }
