import 'package:flutter/material.dart';
import 'Reservation.dart';
import 'ReservationDAO.dart';
import 'ReservationDatabase.dart';

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

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    final database = await $FloorReservationDatabase.databaseBuilder('reservation_database.db').build();
    reservationDAO = database.getReservationDao;
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
        title: const Text('Want to Delete?'),
        content: const Text('Press \'Yes\' to Delete'),
        actions: <Widget>[

          FilledButton(onPressed: (){
            // clearLoginData();
            Navigator.of(context).pop();


          }, child: Text("No")),

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
              child: Text("Yes")),


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
      _showSnackBar('Reservation added successfully');
    } else {
      _showAlertDialog('Please fill all fields');
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
                decoration: InputDecoration(labelText: 'First Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _flightCodeController,
                decoration: InputDecoration(labelText: 'Flight Code'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
            ),
            ElevatedButton(
              child: Text('Add Reservation'),
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
                      title: Text('Name: ${reservation.firstName} ${reservation.lastName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flight Code: ${reservation.flightCode}'),
                          Text('Date: ${reservation.date}'),
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
      return Center(child: Text("No reservation selected"));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(

            children: [

              Text('Reservation Id: ${selectedReservation!.id} '),
              Text('Name: ${selectedReservation!.firstName} ${selectedReservation!.lastName}'),
              Text('Email: ${selectedReservation!.email}'),
              Text('Flight Code: ${selectedReservation!.flightCode}'),
              Text('Date: ${selectedReservation!.date}'),

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
                child: Text("Go back"),
              ),
              OutlinedButton(
                onPressed: () {
                  if (selectedReservation != null) {
                    _deleteTodoItem(selectedReservation!);
                  }
                },
                child: Text("Delete"),
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