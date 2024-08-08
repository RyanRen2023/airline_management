import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:airline_management/airplane/AddAirplanePage.dart';
import 'package:airline_management/airplane/AirplaneListPage.dart';
import 'package:airline_management/airplane/Airplane.dart';
import 'package:airline_management/airplane/AirplaneDetailView.dart';
import 'package:airline_management/airplane/AirplaneDetailPage.dart';
import 'package:airline_management/airplane/AirplaneDAO.dart';



import '../AppLocalizations.dart';
import '../const/Const.dart';
import '../database/DatabaseOperator.dart';

///airplane main class
class AirplanePage extends StatefulWidget {
  const AirplanePage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _AirplanePageState();
}

///airplane state page
class _AirplanePageState extends State<AirplanePage> {
  //int _selectedIndex = 0;
  Airplane? _selectedAirplane;
  late AirplaneDAO? airplaneDAO;
  var airplanes = <Airplane>[];

  final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();
  void savePreviousAirplaneToPreference(Airplane airplane) {
    _preferences.setString("airplaneType", airplane.airplaneType);
  }

  Future<Airplane?> loadPreviousAirplaneFromPreference() async {
    // Retrieve Airplane information from preferences
    String? airplaneType = await _preferences.getString('airplaneType');

    // Create a template Airplane
    Airplane preAirplane = Airplane(
      airplaneType: "Boeing 737-800",
      numberOfPassengers: 162,
      maxSpeed: 839,
      rangeToFly: 5765,
    );
    return preAirplane;
  }

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

  @override
  void dispose() {
    super.dispose();
  }

  ///show snackBar with [message]
  void showSnackBar(String message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///find selected [airplane] and update in database
  void onUpdateAirplane(Airplane airplane) {
    for (int i = 0; i < airplanes.length; i++) {
      if (airplane.id == airplanes[i].id) {
        setState(() {
          airplanes[i] = airplane;
          _selectedAirplane = airplane;
        });
        break;
      }
    }
    airplaneDAO?.updateAirplane(airplane);
    ///show message if update successfully
    showSnackBar(AppLocalizations.of(context)!
        .translate(Const.SNACKBAR_UPDATE_AIRPLANE_SUCCESS)!);
  }

  ///find selected [airplane] and delete in database
  void onDeleteAirplane(Airplane airplane) {
    for (int i = 0; i < airplanes.length; i++) {
      if (airplane.id == airplanes[i].id) {
        setState(() {
          airplanes.removeAt(i);
          _selectedAirplane = null;
        });
        break;
      }
    }
    airplaneDAO?.deleteAirplaneById(airplane.id!);
    setState(() {
      _selectedAirplane = null;
    });

    ///show message if delete successfully
    showSnackBar(AppLocalizations.of(context)!
        .translate(Const.SNACKBAR_DELETE_AIRPLANE_SUCCESS)!);
  }

  /// set state of selected [airplane]Airplane airplane
  void _onAirplaneSelectedWide(Airplane airplane) {
    setState(() {
      _selectedAirplane = airplane;
    });
  }

  ///load detail page when [airplane] is selected on the list page
  void _onAirplaneSelected(Airplane airplane) {
    _selectedAirplane = airplane;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AirplaneDetailPage(
            title: AppLocalizations.of(context)!.translate(Const.AIRPLANE_DETAIL)!,
            airplane: airplane,
          updateAirplane: onUpdateAirplane,
          deleteAirplane: onDeleteAirplane);
      }),
    );
  }

  ///show landscape screen for Ipad or Desktop with list and detail on the same page
    Widget showWideScreen() {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: AirplaneListPage(
              airplanes: airplanes,
              onAirplaneSelected: _onAirplaneSelectedWide,
              selectedAirplane: _selectedAirplane,
            ),
          ),
          Expanded(
            flex: 3,
            child: _selectedAirplane != null ? AirplaneDetailView(
                airplane: _selectedAirplane!,
                updateAirplane: onUpdateAirplane,
                deleteAirplane: onDeleteAirplane)
                : Center(
                child: Text(AppLocalizations.of(context)!.translate(Const.VIEW_AIRPLANE_DETAIL)!)),
          ),
        ],
      );
    }

  ///show portrait screen for phone with list and detail on separated pages
  Widget showNormalScreen() {
    return Column(
      children: [
        Expanded(
          child: AirplaneListPage(
            airplanes: airplanes,
            onAirplaneSelected: _onAirplaneSelected,
            selectedAirplane: _selectedAirplane,
          ),
        )
        /*if (_selectedAirplane != null)
          Expanded(
            child: AirplaneDetailView(
              airplane: _selectedAirplane!,
                updateAirplane: onUpdateAirplane,
                deleteAirplane: onDeleteAirplane),
          ),
      ,
    );*/]);
  }

///build responsive layouts for landscape or portrait mode
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


    void createBlankAirplane(){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAirplanePage(
              title: AppLocalizations.of(context)!.translate(Const.ADD_AIRPLANE)!,
              addNewAirplane: onAddNewAirplane,
              createFromLast: false,
            )),
      );

    }
    ///add new [airplane] async with snackBar showing execute result
  void onAddNewAirplane(Airplane airplane) async {
    int? airplaneId = await airplaneDAO?.insertAirplane(airplane);
    Airplane newAirplane = Airplane(
        id:airplaneId,
        airplaneType: airplane.airplaneType,
        numberOfPassengers: airplane.numberOfPassengers,
        maxSpeed: airplane.maxSpeed,
        rangeToFly: airplane.rangeToFly);

    if (airplaneId != null) {
      setState(() {
        airplanes.add(newAirplane);
      });
      //_fetchAirplanes();
      print('New airplane ID: $airplaneId');
      showSnackBar(
          AppLocalizations.of(context)!.translate(Const.ADD_AIRPLANE_SUCCESS)!);
    }else{
      print('Add airplane failed.');
      showSnackBar(
          AppLocalizations.of(context)!.translate(Const.ADD_AIRPLANE_FAIL)!);
    }
  }
  Future<void> NavigateToAddAirplanePage() async {
    Airplane? preAirplane = await loadPreviousAirplaneFromPreference();
    if (preAirplane != null) {
      showDialogForAddAirplane(context, preAirplane);
    } else {
      createBlankAirplane();
    }
  }


///build widget float button for adding new airplane
  Widget showAddAirplaneButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            NavigateToAddAirplanePage();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// [preAirplane] - The previous Airplane data to prefill.
  void createPreviousAirplane(Airplane preAirplane) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddAirplanePage(
              title: AppLocalizations.of(context)!
                  .translate(Const.ADD_AIRPLANE)!,
              addNewAirplane: onAddNewAirplane,
              createFromLast: true,
              preAirplane: preAirplane)),
    );
  }

  /// [preAirplane] - The previous Airplane data to prefill.
  void showDialogForAddAirplane(BuildContext context, Airplane preAirplane) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .translate(Const.ADD_AIRPLANE)!),
          content: Text(AppLocalizations.of(context)!
              .translate(Const.CHOOSE_TTEMPLATE_AIRPLANE)!),
          actions: <Widget>[
            TextButton(
              child: Text(
                  AppLocalizations.of(context)!.translate(Const.BUTTON_OK)!),
              onPressed: () {
                // when choose ok ,build Airplane from previous Airplane
                Navigator.of(context).pop();
                createPreviousAirplane(preAirplane);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate(Const.NO)!),
              onPressed: () {
                // when choose No ,build a blank Airplane
                Navigator.of(context).pop();
                createBlankAirplane();
              },
            )
          ],
        );
      },
    );
  }



///build widget for main page of airplane
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          responsiveLayout(),
          showAddAirplaneButton(),
        ],
      ),
    );
  }

}