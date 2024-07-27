import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
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
  }

  Future<void> _initDb() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    reservationDAO = database.reservationDao;
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final loadedReservations = await reservationDAO.getAllReservations();
    setState(() {
      reservations = loadedReservations;
    });
  }


  void _deleteTodoItem(Reservation item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:   Text(AppLocalizations.of(context)!.translate('WANT_TO_DELETE')!),
        content:  Text(AppLocalizations.of(context)!.translate('PRES_YES_TO_DELETE')!),
        actions: <Widget>[

          FilledButton(onPressed: (){
            // clearLoginData();
            Navigator.of(context).pop();


          }, child: Text(AppLocalizations.of(context)!.translate("NO")!)),

          FilledButton(
              onPressed: (){
                _doDeleteItem(item);
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/pageTwo')
/*                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        username: _controller_username.value.text
                    ),
                  ),
                );*/
              },
              child: Text(AppLocalizations.of(context)!.translate("YES")!)),


        ],
      ),

    );
  }

  void _doDeleteItem(Reservation item) async {
    await reservationDAO.deleteReservation(item);
    setState(() {
      reservations.remove(item);
      selectedReservation = null;
    });
  }
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
          date: date
      );

      await reservationDAO.insertReservation(newReservation);
      _loadReservations();
      _clearInputs();
      _showSnackBar('RESERVATION_ADDED_SUCCESSFULLY');
    } else {
      _showAlertDialog('PLEASE_FILL_ALL_FIELDS');
    }
  }

  void _clearInputs() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _flightCodeController.clear();
    _dateController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate(message)!)));
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          Text(AppLocalizations.of(context)!.translate('ALERT')!),

          content: Text(AppLocalizations.of(context)!.translate(message)!),
          actions: <Widget>[
            TextButton(
              child:

              Text(AppLocalizations.of(context)!.translate('OK')!),


              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget ReservationList() {
    return Scrollbar(
      thickness: 9.0,
      radius: Radius.circular(10),
      child:
      SingleChildScrollView( // Added SingleChildScrollView
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText:  AppLocalizations.of(context)!.translate('FIRST_NAME')!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('LAST_NAME')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText:  AppLocalizations.of(context)!.translate('EMAIL')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _flightCodeController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('FLIGHT_CODE')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('DATE')),
              ),
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.translate('ADD_RESERVATION')!),
              onPressed: _addReservation,
            ),
            SizedBox(  // Added SizedBox with a fixed height
              height: 300, //height for the card list
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return Card(
                    child: ListTile(
                      title:

                      Text('${AppLocalizations.of(context)!.translate('FULL_NAME')}: ${reservation!.firstName} ${reservation!.lastName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('${AppLocalizations.of(context)!.translate('FLIGHT_CODE')}: ${reservation.flightCode} '),
                          Text('${AppLocalizations.of(context)!.translate('DATE')}: ${reservation.date} '),

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
      )
      ,
    );
  }


  Widget DetailsPage() {
    if (selectedReservation == null) {
      return Center(child: Text(AppLocalizations.of(context)!.translate("NO_RESERVATION_SELECTED")!));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(

            children: [
/*

              Text('Reservation Id: ${selectedReservation!.id} '),
              Text('Name: ${selectedReservation!.firstName} ${selectedReservation!.lastName}'),
              Text('Email: ${selectedReservation!.email}'),
              Text('Flight Code: ${selectedReservation!.flightCode}'),
              Text('Date: ${selectedReservation!.date}'),
*/

              Text('${AppLocalizations.of(context)!.translate('RESERVATION_ID')}: ${selectedReservation!.id} '),
              Text('${AppLocalizations.of(context)!.translate('FULL_NAME')}: ${selectedReservation!.firstName} ${selectedReservation!.lastName}'),
              Text('${AppLocalizations.of(context)!.translate('EMAIL')}: ${selectedReservation!.email}'),
              Text('${AppLocalizations.of(context)!.translate('FLIGHT_CODE')}: ${selectedReservation!.flightCode}'),
              Text('${AppLocalizations.of(context)!.translate('DATE')}: ${selectedReservation!.date}'),


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
                child: Text(AppLocalizations.of(context)!.translate('GO_BACK')!)
              ),
              OutlinedButton(
                onPressed: () {
                  if (selectedReservation != null) {
                    _deleteTodoItem(selectedReservation!);
                  }
                },
                child: Text(AppLocalizations.of(context)!.translate('DELETE')!)
              ),

            ],


          )

        ],
      );
    }
  }

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