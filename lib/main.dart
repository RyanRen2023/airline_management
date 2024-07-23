import 'package:flutter/material.dart';
import 'package:airline_management/customer/CustomerPage.dart';
//import 'package:airline_management/airline/AirlinePage.dart';
import 'package:airline_management/airplane/AirplanePage.dart';
import 'package:airline_management/flights/FlightsPage.dart';
import 'package:airline_management/reservation/ReservationPage.dart';
import 'package:airline_management/Properties.dart';

import 'database/DatabaseOperator.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseOperator.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airline Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Airline Management Homepage'),
      initialRoute: '/home',
      routes: {
        Properties.NAV_HOME: (context) =>
            const MyHomePage(title: 'Airline Management Homepage'),
        Properties.NAV_CUSTOMER: (context) => const CustomerPage(title: "Customer"),
        Properties.NAV_AIRPLANE: (context) => const AirplanePage(title: "Airplane"),
        Properties.NAV_FLIGHTS: (context) => const FlightsPage(title: "Flights"),
        Properties.NAV_RESERVATION: (context) => const ReservationPage(title: "Reservation"),
      },
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_AIRPLANE);
                },
                child: const Text("Airplane")),
            SizedBox(
              height: Properties.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_FLIGHTS);
                },
                child: const Text("Flights")),
            SizedBox(
              height: Properties.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_CUSTOMER);
                },
                child: const Text("Customer")),
            SizedBox(
              height: Properties.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_RESERVATION);
                },
                child: const Text("Reservation")),
          ],
        ),
      ),
    );
  }
}
