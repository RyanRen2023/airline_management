import 'package:airline_management/customer/CustomerDAO.dart';
import 'package:airline_management/flights/FlightDao.dart';
import 'package:flutter/material.dart';
import '../AppLocalizations.dart';
import '../const/Const.dart';
import '../customer/Customer.dart';
import '../database/DatabaseOperator.dart';
import '../database/database.dart';
import '../flights/FlightItem.dart';
import 'Reservation.dart';
import 'ReservationDAO.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key, required this.title});

  final String title;

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _dateController = TextEditingController();

  //list for store data from database
  List<Reservation> reservations = [];
  List<Customer> customers = [];
  List<FlightItem> flights = [];

  //dao
  late ReservationDAO reservationDAO;
  late CustomerDAO customerDAO;
  late FlightDao flightDao;


  final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();

  Customer? selectedCustomer;
  FlightItem? selectedFlight;
  Reservation? selectedReservation;


  @override
  void initState() {
    super.initState();
    _initDb();
    _loadEncryptedData();
    // _loadCustomersAndFlights();
  }

  Future<void> _loadEncryptedData() async {
    _dateController.text = await _preferences.getString('date');
  }

  Future<void> _saveEncryptedData() async {
    await _preferences.setString('date', _dateController.text);
  }

  Future<void> _initDb() async {
    reservationDAO = (await DatabaseOperator.getReservationDAO())!;
    customerDAO = (await DatabaseOperator.getCustomerDAO())!;
    flightDao = (await DatabaseOperator.getFlightsDAO())!;
    _loadReservations();
    _loadCustomers();
    _loadFlights();
  }

  Future<void> _loadReservations() async {
    final loadedReservations = await reservationDAO.getAllReservations();
    setState(() {
      reservations = loadedReservations;
    });
  }
  Future<void> _loadCustomers() async {
    DatabaseOperator.getAllCustomers().then((value) {
      setState(() {
        customers = value;
      });
    });

  }
  Future<void> _loadFlights() async {
    final items = await flightDao.findAllFlights();
    setState(() {
      flights.addAll(items);
    });
  }

  void _deleteTodoItem(Reservation item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate(Const.WANT_TO_DELETE)!),
        content: Text(AppLocalizations.of(context)!.translate(Const.PRES_YES_TO_DELETE)!),
        actions: <Widget>[
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.translate(Const.NO)!),
          ),
          FilledButton(
            onPressed: () {
              _doDeleteItem(item);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.translate(Const.YES)!),
          ),
        ],
      ),
    );
  }

  /**
   * method for deleting the selected Item
   */
  void _doDeleteItem(Reservation item) async {
    await reservationDAO.deleteReservation(item);
    setState(() {
      reservations.remove(item);
      selectedReservation = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _saveEncryptedData();
    }
  }

  /**
   * method for validate fields are not empty, and add Reservation Item
   */
  void _addReservation() async {
    if (selectedCustomer == null || selectedFlight == null) {
      _showAlertDialog(Const.PLEASE_SELECT_A_CUSTOMER_AND_A_FLIGHT);
      return;
    }
    if (selectedCustomer == null || selectedFlight == null || _dateController.text.isEmpty) {
      _showAlertDialog(Const.PLEASE_FILL_ALL_FIELDS);
      return;
    }

    final newReservation = Reservation(
      customerId: selectedCustomer!.id!,
      flightId: selectedFlight!.id,
      date: _dateController.text,
    );

    await reservationDAO.insertReservation(newReservation);
    _loadReservations();
    await _saveEncryptedData();
    _clearInputs();
    _showSnackBar(Const.RESERVATION_ADDED_SUCCESSFULLY);
  }

  /**
   * Clear the content of input fields
   */
  void _clearInputs() {
    setState(() {
      selectedCustomer = null;
      selectedFlight = null;
      _dateController.clear();
    });
  }


  /**
   * show snackbar by passing String
   */
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate(message)!),
      ),
    );
  }


  /**
   * show alert dialog by passing string
   */
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate(Const.ALERT)!),
          content: Text(AppLocalizations.of(context)!.translate(message)!),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.OK)!),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  /**
   * Setting the main layout for input fields.
   */
  Widget _buildReservationList() {
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return ListTile(
          title: Text('${AppLocalizations.of(context)!.translate(Const.MAIN_BUTTON_RESERVATION)} ${reservation.id}'),
          subtitle: Text('${AppLocalizations.of(context)!.translate(Const.DATE)}: ${reservation.date}'),
          onTap: () {
            setState(() {
              selectedReservation = reservation;
            });
          },
        );
      },
    );
  }




  Widget _buildReservationDetails() {
    if (selectedReservation == null) {
      return Center(child: Text(AppLocalizations.of(context)!.translate(Const.NO_RESERVATION_SELECTED)!));
    }

    final customer = customers.firstWhere((c) => c.id == selectedReservation!.customerId);
    final flight = flights.firstWhere((f) => f.id == selectedReservation!.flightId);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0), // 为按钮留出空间
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.translate(Const.RESERVATION_DETAILS)!, style: Theme.of(context).textTheme.titleLarge),
              Text('${AppLocalizations.of(context)!.translate(Const.CUSTOMER)!}: ${customer.firstName} ${customer.lastName}'),
              Text('${AppLocalizations.of(context)!.translate(Const.FLIGHT)!}: ${flight.flightCode}'),
              Text('${AppLocalizations.of(context)!.translate(Const.FROM)!}: ${flight.departureCity} ${AppLocalizations.of(context)!.translate(Const.AT)!} ${flight.departureTime}'),
              Text('${AppLocalizations.of(context)!.translate(Const.TO)!}: ${flight.destinationCity} ${AppLocalizations.of(context)!.translate(Const.AT)!} ${flight.arrivalTime}'),
              Text('${AppLocalizations.of(context)!.translate(Const.DATE)!}: ${selectedReservation!.date}'),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteTodoItem(selectedReservation!),
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedReservation = null;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }













/*
  Widget _buildReservationDetails() {
    if (selectedReservation == null) {
      return Center(child: Text(AppLocalizations.of(context)!.translate(Const.NO_RESERVATION_SELECTED)!));
    }

     final customer = customers.firstWhere((c) => c.id == selectedReservation!.customerId);
    final flight = flights.firstWhere((f) => f.id == selectedReservation!.flightId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.translate(Const.RESERVATION_DETAILS)!, style: Theme.of(context).textTheme.titleLarge),
        Text('${AppLocalizations.of(context)!.translate(Const.CUSTOMER)!}: ${customer.firstName} ${customer.lastName}'),
        Text('${AppLocalizations.of(context)!.translate(Const.FLIGHT)!}: ${flight.flightCode}'),
        Text('${AppLocalizations.of(context)!.translate(Const.FROM)!}: ${flight.departureCity} ${AppLocalizations.of(context)!.translate(Const.AT)!} ${flight.departureTime}'),
        Text('${AppLocalizations.of(context)!.translate(Const.TO)!}: ${flight.destinationCity} ${AppLocalizations.of(context)!.translate(Const.AT)!} ${flight.arrivalTime}'),
        Text('${AppLocalizations.of(context)!.translate(Const.DATE)!}: ${selectedReservation!.date}'),
      ],
    );
  }
*/

  Widget ReservationList() {
    return Scrollbar(
      thickness: 9.0,
      radius: Radius.circular(10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DropdownButton<Customer>(
              value: selectedCustomer,
              hint: Text(AppLocalizations.of(context)!.translate(Const.SELECT_CUSTOMER)!),
              items: customers.map((Customer customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: Text('${customer.firstName} ${customer.lastName}'),
                );
              }).toList(),
              onChanged: (Customer? newValue) {
                setState(() {
                  selectedCustomer = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<FlightItem>(
              value: selectedFlight,
              hint: Text(AppLocalizations.of(context)!.translate(Const.SELECT_FLIGHT)!),
              items: flights.map((FlightItem flight) {
                return DropdownMenuItem<FlightItem>(
                  value: flight,
                  child: Text('${flight.flightCode}: ${flight.departureCity} to ${flight.destinationCity}'),
                );
              }).toList(),
              onChanged: (FlightItem? newValue) {
                setState(() {
                  selectedFlight = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(Const.DATE),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                onChanged: (value) => _saveEncryptedData(),
              ),
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.ADD_RESERVATION)!),
              onPressed: _addReservation,
            ),
            SizedBox(
              height: 300,
              child: _buildReservationList(),
            ),
          ],
        ),
      ),
    );
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              children: [
                Expanded(child: ReservationList()),
                Expanded(child: _buildReservationDetails()),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(child: ReservationList()),
                Expanded(child: _buildReservationDetails()),
              ],
            );
          }
        },
      ),
    );
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              children: [
                Expanded(child: ReservationList()),
                Expanded(child: _buildReservationDetails()),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(child: ReservationList()),
                Expanded(child: _buildReservationDetails()),
              ],
            );
          }
        },
      ),
    );
  }
}









