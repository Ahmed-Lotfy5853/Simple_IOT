import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetooth/BackgroundCollectingTask.dart';
import 'bluetooth/SelectBondedDevicePage.dart';
import 'projectsscreen.dart';
import 'resources/colors.dart';
import 'resources/strings.dart';
import 'resources/widgets.dart';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// String url = 'https://dolphin-in-biology.com/home';
// Color secondary =    Colors.black;
// Color primary =    Color(0xff235c6a);
BluetoothState bluetoothState = BluetoothState.UNKNOWN;

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;

  TextEditingController NameController = TextEditingController();

  var FormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    NameController.text = Project ;
    FlutterBluetoothSerial.instance.isEnabled.then((value) {
      
      print("blue enable ==> ${value}");
      if((value??false)){
      FlutterBluetoothSerial.instance.state.then((state) {
        setState(() {
          bluetoothState = state;
        });
      });

      Future.doWhile(() async {
        // Wait if adapter not enabled
        if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
          return false;
        }
        await Future.delayed(Duration(milliseconds: 0xDD));
        return true;
      }).then((_) {
        // Update the address field
        FlutterBluetoothSerial.instance.address.then((address) {
          setState(() {
            _address = address!;
          });
        });
      });

      FlutterBluetoothSerial.instance.name.then((name) {
        setState(() {
          _name = name!;
        });
      });

      // Listen for futher state changes
      FlutterBluetoothSerial.instance
          .onStateChanged()
          .listen((BluetoothState state) async {
        setState(() {
          bluetoothState = state;

          // Discoverable mode is disabled when Bluetooth gets disabled
          _discoverableTimeoutTimer = null;
          _discoverableTimeoutSecondsLeft = 0;
        });
      });
    }
    else{
      FlutterBluetoothSerial.instance.requestEnable();
      
    }
    }).catchError((e)=>print("blue enable error ==> ${e.toString()}"));
    // Get current state
   
    if (!bluetoothState.isEnabled)
      FlutterBluetoothSerial.instance.requestEnable();
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomMaterialButton(
                text: AddNewProject,
                mission: () => _AddNewProjectMission(context)),
         /*   CustomSizedBoxSeparated(),
            CustomMaterialButton(
                text: openProjects,
                mission: () => _openProjectsMission(context)),
         */ ],
        ),
      ),
    );
  }

  _AddNewProjectMission(BuildContext context) {
    CustomReplaceScreen(
      context: context,
      Screen: SelectBondedDevicePage(checkAvailability: false));
    /*showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // scrollable: true,
          title: Text(AddNewProject),
          content: Form(
            key: FormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                  text: ProjectName,
                  textController: NameController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("add"),
              onPressed: () {
                if (FormKey.currentState!.validate()) {
                  setState(() {

                    Project = NameController.text;
                    val++;

                  });
                  CustomReplaceScreen(
                      context: context,
                      Screen: SelectBondedDevicePage(checkAvailability: false));
                }
              },
            ),
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );*/
  }

  _openProjectsMission(BuildContext context) {
    CustomReplaceScreen(context: context, Screen: ProjectsScreen());
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
