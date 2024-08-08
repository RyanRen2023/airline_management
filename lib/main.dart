import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/customer/CustomerPage.dart';
import 'package:airline_management/airplane/AirplanePage.dart';
import 'package:airline_management/flights/FlightsPage.dart';
import 'package:airline_management/reservation/ReservationPage.dart';
import 'package:airline_management/Properties.dart';

import 'AppLocalizations.dart';
import 'const/Const.dart';
import 'database/DatabaseOperator.dart';
import 'dart:ui';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flag/flag.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseOperator.deleteOldDatabase();
  await DatabaseOperator.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
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
  Locale defaultLocale = Locale("en", "CA"); //default is english from Canada

  void changeLanguage(Locale newLanguage) {
    setState(() {
      defaultLocale = newLanguage; //set app language to new
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: defaultLocale, //少了这一行会点击无法显示语言
      supportedLocales: const [
        Locale("en", "CA"),
        Locale("fr", "CA"),
        Locale("zh", "ZH"),
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
      home: MyHomePage(
        title: "Airline Management Homepage",
        locale: defaultLocale,
      ),
      initialRoute: '/home',
      routes: {
        Properties.NAV_HOME: (context) => MyHomePage(
              title: "Airline Management Homepage",
              locale: defaultLocale,
            ),
        // Properties.NAV_CUSTOMER: (context) => const CustomerPage(title: "Customer"),
        // Properties.NAV_AIRLINE: (context) => const AirplanePage(title: "Airplane"),
        // Properties.NAV_FLIGHTS: (context) => const FlightsPage(title: "Flights"),
        // Properties.NAV_RESERVATION: (context) => const ReservationPage(title: "Reservation"),
        Properties.NAV_CUSTOMER: (context) => CustomerPage(
            title: AppLocalizations.of(context)!
                .translate(Const.MAIN_BUTTON_CUSTOMER)!),
        Properties.NAV_AIRLINE: (context) => AirplanePage(
            title: AppLocalizations.of(context)!
                .translate(Const.MAIN_BUTTON_AIRPLANE)!),
        Properties.NAV_FLIGHTS: (context) => FlightsPage(
            title: AppLocalizations.of(context)!
                .translate(Const.MAIN_BUTTON_FLIGHTS)!),
        Properties.NAV_RESERVATION: (context) => ReservationPage(
            title: AppLocalizations.of(context)!
                .translate(Const.MAIN_BUTTON_RESERVATION)!)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.locale});

  final String title;
  final Locale locale;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale _currentLocale = Locale("en", "CA");
  @override
  void initState() {
    super.initState();
    _currentLocale = widget.locale;
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
    MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: flagAppBar(context, widget.title),
      appBar:
          flagAppBar(context, widget.title, _currentLocale, _changeLanguage),
      body: responsiveLayout(),
    );
  }

  /// Builds the responsive layout for the Customer Page.
  Widget responsiveLayout() {
    final size = MediaQuery.of(context).size;
    return size.width > size.height && size.width > 360
        ? showWideScreen()
        : showNormalScreen();
  }

  Widget showWideScreen() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            icon: Icons.route,
            label: AppLocalizations.of(context)!
                .translate('MAIN_BUTTON_AIRPLANE')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_AIRLINE),
          ),
          _buildButton(
            icon: Icons.flight,
            label:
                AppLocalizations.of(context)!.translate('MAIN_BUTTON_FLIGHTS')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_FLIGHTS),
          ),
          _buildButton(
            icon: Icons.person,
            label: AppLocalizations.of(context)!
                .translate('MAIN_BUTTON_CUSTOMER')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_CUSTOMER),
          ),
          _buildButton(
            icon: Icons.calendar_today,
            label: AppLocalizations.of(context)!
                .translate('MAIN_BUTTON_RESERVATION')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_RESERVATION),
          ),
        ],
      ),
    );
  }

  Widget showNormalScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            icon: Icons.route,
            label: AppLocalizations.of(context)!
                .translate('MAIN_BUTTON_AIRPLANE')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_AIRLINE),
          ),
          _buildButton(
            icon: Icons.flight,
            label:
                AppLocalizations.of(context)!.translate('MAIN_BUTTON_FLIGHTS')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_FLIGHTS),
          ),
          _buildButton(
            icon: Icons.person,
            label: AppLocalizations.of(context)!
                .translate('MAIN_BUTTON_CUSTOMER')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_CUSTOMER),
          ),
          _buildButton(
            icon: Icons.calendar_today,
            label: AppLocalizations.of(context)!
                .translate('MAIN_BUTTON_RESERVATION')!,
            onPressed: () =>
                Navigator.pushNamed(context, Properties.NAV_RESERVATION),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            child: Column(
              children: [
                Icon(icon, size: 48),
                SizedBox(height: 8),
                Text(label),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar flagAppBar(BuildContext context, String title, Locale currentLocale,
      void Function(Locale) changeLanguage) {
    double sizeboxWidth = 2;
    double paddingWidth = 2.0;
    double fontSize = 14;
    List<double> flagSize = [16, 24];
    String getLanguageName(Locale locale) {
      switch (locale.languageCode) {
        case 'fr':
          return 'Français';
        case 'zh':
          return '中文';
        case 'en':
        default:
          return 'English';
      }
    }

    Widget getFlagIcon(Locale locale) {
      switch (locale.languageCode) {
        case 'fr':
          return Flag.fromString('CA', height: flagSize[0], width: flagSize[1]);
        case 'zh':
          return Flag.fromString('CN', height: flagSize[0], width: flagSize[1]);
        case 'en':
        default:
          return Flag.fromString('CA', height: flagSize[0], width: flagSize[1]);
      }
    }

    return AppBar(
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              changeLanguage(locale);
            },
            icon: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingWidth),
                  child: getFlagIcon(currentLocale),
                ),
                Text(
                  getLanguageName(currentLocale),
                  style: TextStyle(fontSize: fontSize),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              PopupMenuItem<Locale>(
                value: Locale("fr", "CA"),
                child: Row(
                  children: [
                    Flag.fromString('CA',
                        height: flagSize[0], width: flagSize[1]),
                    SizedBox(width: sizeboxWidth),
                    Text("Français", style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: Locale("en", "CA"),
                child: Row(
                  children: [
                    Flag.fromString('CA',
                        height: flagSize[0], width: flagSize[1]),
                    SizedBox(width: sizeboxWidth),
                    Text("English", style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: Locale("zh", "ZH"),
                child: Row(
                  children: [
                    Flag.fromString('CN',
                        height: flagSize[0], width: flagSize[1]),
                    SizedBox(width: sizeboxWidth),
                    Text("中文", style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
    );
  }
}
