import 'package:flutter/material.dart';
import 'package:airline_management/customer/CustomerPage.dart';
//import 'package:airline_management/airline/AirlinePage.dart';
import 'package:airline_management/airplane/AirplanePage.dart';
import 'package:airline_management/flights/FlightsPage.dart';
import 'package:airline_management/reservation/ReservationPage.dart';
import 'package:airline_management/Properties.dart';

import 'AppLocalizations.dart';
import 'const/Const.dart';
import 'database/DatabaseOperator.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseOperator.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget  {
  const MyApp({super.key});
  @override
  _MyAppState createState() {
    return _MyAppState();
  }

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

}



//spilite to } class _MyAppState extends State<MyApp>  {
class _MyAppState extends State<MyApp> {

  var _locale = Locale("en","CA");//default is english from Canada

  void changeLanguage(Locale newLanguage){
    setState(() {
      _locale = newLanguage;//set app language to new
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,//少了这一行会点击无法显示语言
      supportedLocales: const[
        Locale("en","CA"),
        Locale("fr","FR"),
        Locale("zh","ZH"),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 添加这行
      ],



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
        // Properties.NAV_CUSTOMER: (context) => const CustomerPage(title: "Customer"),
        // Properties.NAV_AIRLINE: (context) => const AirplanePage(title: "Airplane"),
        // Properties.NAV_FLIGHTS: (context) => const FlightsPage(title: "Flights"),
        // Properties.NAV_RESERVATION: (context) => const ReservationPage(title: "Reservation"),
        Properties.NAV_CUSTOMER: (context) => CustomerPage(
            title: AppLocalizations.of(context)!.translate(Const.MAIN_BUTTON_CUSTOMER)!),
        Properties.NAV_AIRLINE: (context) => AirplanePage(
            title: AppLocalizations.of(context)!.translate(Const.MAIN_BUTTON_AIRPLANE)!),
        Properties.NAV_FLIGHTS: (context) => FlightsPage(
            title: AppLocalizations.of(context)!.translate(Const.MAIN_BUTTON_FLIGHTS)!),
        Properties.NAV_RESERVATION: (context) => ReservationPage(
            title: AppLocalizations.of(context)!.translate(Const.MAIN_BUTTON_RESERVATION)!)

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
        actions: [
          OutlinedButton(onPressed: () {
            MyApp.setLocale(context, Locale("fr","FR"));
          }, child:Text(
              "French(Français)"
          )),
          OutlinedButton(onPressed: () {
            MyApp.setLocale(context, Locale("en","CA"));
          }, child:Text(
              "English"
          )),
          OutlinedButton(onPressed: () {
            MyApp.setLocale(context, Locale("zh","ZH"));
          }, child:Text(
              "Chinese(中文)"
          ))

        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_AIRLINE);
                },
                child: Text(AppLocalizations.of(context)!.translate('MAIN_BUTTON_AIRPLANE')!)),
            SizedBox(
              height: Properties.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_FLIGHTS);
                },
                child: Text(AppLocalizations.of(context)!.translate('MAIN_BUTTON_FLIGHTS')!)),
            SizedBox(
              height: Properties.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_CUSTOMER);
                },
                child: Text(AppLocalizations.of(context)!.translate('MAIN_BUTTON_CUSTOMER')!)),
            SizedBox(
              height: Properties.SIZEDBOX_HIGHT,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Properties.NAV_RESERVATION);
                },
                child: Text(AppLocalizations.of(context)!.translate('MAIN_BUTTON_RESERVATION')!)),
          ],
        ),
      ),
    );
  }
}
