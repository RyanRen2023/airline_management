import 'package:flutter/material.dart';
import 'package:airline_management/airplane/AddAirplanePage.dart';
import 'package:airline_management/airplane/AirplaneListPage.dart';
import 'package:airline_management/airplane/Airplane.dart';
import 'package:airline_management/airplane/AirplaneDetailView.dart';
import 'package:airline_management/airplane/AirplaneDetailPage.dart';
import 'package:airline_management/airplane/AirplaneDAO.dart';



import '../database/DatabaseOperator.dart';


class AirplanePage extends StatefulWidget {
  const AirplanePage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _AirplanePagePageState();
}

class _AirplanePagePageState extends State<AirplanePage> {
  //int _selectedIndex = 0;
  Airplane? _selectedAirplane;
  late AirplaneDAO? airplaneDAO;
  var airplanes = <Airplane>[];

  @override
  void initState() {
    super.initState();
    DatabaseOperator.getAllAirplanes().then((value) {
      setState(() {
        airplanes = value;
      });
    });

    DatabaseOperator.getAirplaneDAO().then((value) {
      airplaneDAO = value;
    });
    //_fetchAirplanes();
  }


  // void _fetchAirplanes() async {
  //   final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //   final airplaneDAO = database.airplaneDAO;
  //   final fetchedAirplanes = await airplaneDAO.findAllAirplanes();
  //   setState(() {
  //     airplanes = fetchedAirplanes;
  //   });
  // }

  void _onAirplaneSelectedWide(Airplane airplane) {
    setState(() {
      _selectedAirplane = airplane;
    });
  }

  void _onAirplaneSelected(Airplane airplane) {
    _selectedAirplane = airplane;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AirplaneDetailPage(title: 'Airplane Detail', airplane: airplane);
      }),
    );
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var width = size.width;

    if (width > heigh && width > 720) {
      // landscape
      return showWideScreen();
    } else {
      //Portrait screen
      return showNormalScreen();
    }
  }

  Widget showWideScreen() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AirplaneListPage(
            airplanes: airplanes,
            onAirplaneSelected: _onAirplaneSelectedWide,
            selectedAirplane: _selectedAirplane,
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedAirplane != null
              ? AirplaneDetailView(airplane: _selectedAirplane!)
              : Center(child: Text('Select a airplane to view details')),
        ),
      ],
    );
  }

  Widget showNormalScreen() {
    return Column(
      children: [
        Expanded(
          child: AirplaneListPage(
            airplanes: airplanes,
            onAirplaneSelected: _onAirplaneSelected,
            selectedAirplane: _selectedAirplane,
          ),
        ),
        if (_selectedAirplane != null)
          Expanded(
            child: AirplaneDetailView(airplane: _selectedAirplane!),
          ),
      ],
    );
  }

  // void _navigateToAddAirplanePage() async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AddAirplanePage(title: 'Add Airplane')),
  //   );
  //
  //   _fetchAirplanes();
  // }

  void onAddNewAirplane(Airplane airplane) async {
    int? airplaneId = await airplaneDAO?.insertAirplane(airplane);
    Airplane newAirplane = Airplane(id:airplaneId,airplaneType: airplane.airplaneType,numberOfPassengers: airplane.numberOfPassengers,maxSpeed: airplane.maxSpeed,rangeToFly: airplane.rangeToFly);

    if (airplaneId != null) {
      setState(() {
        airplanes.add(newAirplane);
      });
      //_fetchAirplanes();
      print('New airplane ID: $airplaneId');
      showSnackBar("add airplane successfully");
    }else{
      print('Add airplane failed.');
      showSnackBar("add airplane failed.");
    }
  }

  void showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget showAddAirplaneButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAirplanePage(
                    title: 'Add Airplane',
                    addNewAirplane: onAddNewAirplane,
                  )),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    //bool isWideScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          responsiveLayout(),
          showAddAirplaneButton()
        ],
      ),
    );
  }
}