import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
import '../const/Const.dart';
import '../database/database.dart';
import 'Reservation.dart';
import 'ReservationDAO.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key, required this.title});

  final String title;

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _flightCodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<Reservation> reservations = [];
  late ReservationDAO reservationDAO;
  Reservation? selectedReservation;
  final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();
  @override
  void initState() {
    super.initState();
    _initDb();
    //load data with encrypted
    // _loadEncryptedData();
    _clearInputs();
  }

  //load encrypted data
  Future<void> _loadEncryptedData() async {
    _firstNameController.text = await _preferences.getString('firstName');
    _lastNameController.text = await _preferences.getString('lastName');
    _emailController.text = await _preferences.getString('email');
    _flightCodeController.text = await _preferences.getString('flightCode') ;
    _dateController.text = await _preferences.getString('date');
  }

  //save encrypted data
  Future<void> _saveEncryptedData() async {
    await _preferences.setString('firstName', _firstNameController.text);
    await _preferences.setString('lastName', _lastNameController.text);
    await _preferences.setString('email', _emailController.text);
    await _preferences.setString('flightCode', _flightCodeController.text);
    await _preferences.setString('date', _dateController.text);
  }

  Future<void> _initDb() async {
    final database = await $FloorAppDatabase.databaseBuilder(Const.APP_DATABASE_DB).build();
    reservationDAO = database.reservationDao;
    _loadReservations();
  }

  /**
   * get All Reservation data from database and load to Reservation List.
   */
  Future<void> _loadReservations() async {
    final loadedReservations = await reservationDAO.getAllReservations();
    setState(() {
      reservations = loadedReservations;
    });
  }

  /**
   * method for prompt DiaLog when delete Reservation Items
   */
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

  /**
   * method for validate fields are not empty, and add Reservation Item
   */
  void _addReservation() async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String email = _emailController.text;
    final String flightCode = _flightCodeController.text;
    final String date = _dateController.text;

    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && flightCode.isNotEmpty && date.isNotEmpty) {
      final newReservation = Reservation(
        id: null,
        firstName: firstName,
        lastName: lastName,
        email: email,
        flightCode: flightCode,
        date: date,
      );

      await reservationDAO.insertReservation(newReservation);
      _loadReservations();
      // Save encrypted data after adding reservation
      await _saveEncryptedData();
      _clearInputs();
      _showSnackBar(Const.RESERVATION_ADDED_SUCCESSFULLY);
    } else {
      _showAlertDialog(Const.PLEASE_FILL_ALL_FIELDS);
    }
  }

  /**
   * Clear the content of input fields
   */
  void _clearInputs() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _flightCodeController.clear();
    _dateController.clear();
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
  Widget ReservationList() {
    return Scrollbar(
      thickness: 9.0,
      radius: Radius.circular(10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate(Const.FIRST_NAME)!),
                //save as encrypted data when on change
                onChanged: (value) => _saveEncryptedData(),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate(Const.LAST_NAME)),
                //save as encrypted data when on change
                onChanged: (value) => _saveEncryptedData(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate(Const.EMAIL)),
                onChanged: (value) => _saveEncryptedData(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _flightCodeController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate(Const.FLIGHT_CODE)),
                onChanged: (value) => _saveEncryptedData(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate(Const.DATE)),
                onChanged: (value) => _saveEncryptedData(),
              ),
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.ADD_RESERVATION)!),
              onPressed: _addReservation,
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return Card(
                    child: ListTile(
                      title: Text('${AppLocalizations.of(context)!.translate(Const.FULL_NAME)}: ${reservation.firstName} ${reservation.lastName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppLocalizations.of(context)!.translate(Const.FLIGHT_CODE)}: ${reservation.flightCode} '),
                          Text('${AppLocalizations.of(context)!.translate(Const.DATE)}: ${reservation.date} '),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        setState(() {
                          selectedReservation = reservation;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * show more details or Landscape Screen
   */
  Widget DetailsPage() {
    if (selectedReservation == null) {
      return Center(child: Text(AppLocalizations.of(context)!.translate(Const.NO_RESERVATION_SELECTED)!));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text('${AppLocalizations.of(context)!.translate(Const.RESERVATION_ID)}: ${selectedReservation!.id} '),
              Text('${AppLocalizations.of(context)!.translate(Const.FULL_NAME)}: ${selectedReservation!.firstName} ${selectedReservation!.lastName}'),
              Text('${AppLocalizations.of(context)!.translate(Const.EMAIL)}: ${selectedReservation!.email}'),
              Text('${AppLocalizations.of(context)!.translate(Const.FLIGHT_CODE)}: ${selectedReservation!.flightCode}'),
              Text('${AppLocalizations.of(context)!.translate(Const.DATE)}: ${selectedReservation!.date}'),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedReservation = null;
                  });
                },
                child: Text(AppLocalizations.of(context)!.translate(Const.GO_BACK)!),
              ),
              OutlinedButton(
                onPressed: () {
                  if (selectedReservation != null) {
                    _deleteTodoItem(selectedReservation!);
                  }
                },
                child: Text(AppLocalizations.of(context)!.translate(Const.DELETE)!),
              ),
            ],
          )
        ],
      );
    }
  }


  /**
   * Method for determination by different screen directions(Landscape or Portrait)
   */
  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    if (width > height && width > 720) {
      return Row(
        children: [
          Expanded(flex: 1, child: ReservationList()),
          Expanded(flex: 2, child: DetailsPage()),
        ],
      );
    } else {
      if (selectedReservation == null) {
        return ReservationList();
      } else {
        return DetailsPage();
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _flightCodeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (selectedReservation != null)
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
      body: responsiveLayout(),
    );
  }
}