import 'package:flutter/material.dart';
import 'package:airline_management/customer/CustomerPage.dart';
import 'package:airline_management/airline/AirlinePage.dart';
import 'package:airline_management/flights/FlightsPage.dart';
import 'package:airline_management/reservation/ReservationPage.dart';
import 'package:airline_management/Config.dart';

void main() {
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
      home: const MyHomePage(title: 'Ariline Management Homepage'),
      initialRoute: '/home',
      routes: {
        '/home': (context) =>
            const MyHomePage(title: 'Ariline Management Homepage'),
        Config.NAV_CUSTOMER: (context) => const CustomerPage(title: "Customer"),
        Config.NAV_AIRLINE: (context) => const AirlinePage(title: "Airline"),
        Config.NAV_FLIGHTS: (context) => const FlightsPage(title: "Flights"),
        Config.NAV_RESERVATION: (context) => const ReservationPage(title: "Reservation"),
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
  void _incrementCounter() {
    setState(() {});
  }

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
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, Config.NAV_AIRLINE);
            }, child: const Text("Airline")),
            SizedBox(
              height: Config.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, Config.NAV_FLIGHTS);

            }, child: const Text("Flights")),
            SizedBox(
              height: Config.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Config.NAV_CUSTOMER);
                },
                child: const Text("Customer")),
            SizedBox(
              height: Config.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, Config.NAV_RESERVATION);
            }, child: const Text("Reservation")),
          ],
        ),
      ),
    );
  }
}
