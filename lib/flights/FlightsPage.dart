import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:airline_management/database/DatabaseOperator.dart';
import 'FlightDao.dart';
import 'FlightItem.dart';

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
        const SnackBar(content: Text('Flight added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
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
        const SnackBar(content: Text('Flight updated successfully')),
      );
      _savePreferences();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  // Add a delete alert dialog
  void _confirmDeleteFlight() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Flight"),
            content: const Text("Are u sure to delete this flight?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("Cancel")
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteFlight();
                  }, child: const Text("Delete"))
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
        const SnackBar(content: Text('Flight deleted successfully')),
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
          decoration: const InputDecoration(
            labelText: 'Flight Code',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _departureCityController,
          decoration: const InputDecoration(
            labelText: 'Departure City',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _destinationCityController,
          decoration: const InputDecoration(
            labelText: 'Destination City',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _departureTimeController,
          decoration: const InputDecoration(
            labelText: 'Departure Time',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _arrivalTimeController,
          decoration: const InputDecoration(
            labelText: 'Arrival Time',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedFlight == null)
          ElevatedButton(
            onPressed: _addFlight,
            child: const Text('Add Flight'),
          )
        else
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _updateFlight,
                  child: const Text('Update Flight'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirmDeleteFlight,
                  child: const Text('Delete Flight'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _cancelEditing,
                  child: const Text('Cancel'),
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
          ? const Center(
        child: Text('There are no flights in the list'),
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
      return const Center(child: Text("No flight selected"));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Flight Code: ${_selectedFlight!.flightCode}',
              style: const TextStyle(fontSize: 18)),
          Text('Departure City: ${_selectedFlight!.departureCity}',
              style: const TextStyle(fontSize: 18)),
          Text('Destination City: ${_selectedFlight!.destinationCity}',
              style: const TextStyle(fontSize: 18)),
          Text('Departure Time: ${_selectedFlight!.departureTime}',
              style: const TextStyle(fontSize: 18)),
          Text('Arrival Time: ${_selectedFlight!.arrivalTime}',
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
          title: const Text('Flights List'),
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
                  ? const Center(child: Text('No flight selected'))
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
          title: const Text('Flights List'),
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