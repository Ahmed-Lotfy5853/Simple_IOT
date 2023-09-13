import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplestepsiot/resources/strings.dart';
import 'package:simplestepsiot/resources/widgets.dart';


import 'bluetooth/ChatPage.dart';
import 'configuration_screen.dart';
import 'mainscreen.dart';
import 'resources/colors.dart';
BluetoothDevice? SelectedDevice;

class NewProjectScreen extends StatefulWidget {

  BluetoothDevice? selectedDevice;
   NewProjectScreen({Key? key, required this.selectedDevice}) ;

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
double val1 =75;
double val2 =75;
double val3 =75;
double val4 =75;
bool isConnecting = true;
BluetoothConnection? connection;
bool get isConnected => (connection?.isConnected ?? false);

bool isDisconnecting = false;
@override
  void initState() {
  if(!bluetoothState.isEnabled) FlutterBluetoothSerial.instance.requestEnable();

  BluetoothConnection.toAddress(widget.selectedDevice!.address).then((_connection) {
    print('Connected to the device');
    Fluttertoast.showToast(msg: "The device is connected",textColor: MainTextColor,backgroundColor: PrimaryColor);
    SelectedDevice = widget.selectedDevice;

    print(connection?.isConnected);
    connection = _connection;
    print(connection?.isConnected);
    setState(() {
      isConnecting = false;
      isDisconnecting = false;

    });}).catchError((e)=>Fluttertoast.showToast(msg: "The device can't be connected",textColor: MainTextColor,backgroundColor: PrimaryColor));
  super.initState();
  }
@override
void dispose() {
  // Avoid memory leak (`setState` after dispose) and disconnect
  print(connection?.isConnected);
  if (isConnected) {
    isDisconnecting = true;
    connection?.dispose();
    connection = null;
  }

  super.dispose();
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("$Project"),centerTitle: true,elevation: 0,actions: [Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(onPressed: () {
          // context.pushTransparentRoute(ConfigurationScreen());
          CustomAddScreen(context: context, Screen: ConfigurationScreen(),);
        }, icon: Icon(Icons.info),

        ),
      )],),
      backgroundColor: SecondaryColor,
      body: Center(child:
      ListView(children: [
        Slider(min:0,max:180,value: val1,divisions: 180, label:val1.round().toString(),onChanged: (v){
          setState(() {
            val1=v;

          });
        },onChangeEnd: (value) async {
          connection?.isConnected??false ?  _sendMessage(val1.toInt().toString()+ServoCharacter1): Fluttertoast.showToast(msg: "The device is disconnected",textColor: MainTextColor,backgroundColor: PrimaryColor);;

        },),
        Slider(min:0,max:180,value: val2,divisions: 180, label:val2.round().toString(), onChanged: (v){
          setState(() {
            val2=v;

          });
        },onChangeEnd: (value) async {
          connection?.isConnected??false ?  _sendMessage(val2.toInt().toString()+ServoCharacter2): Fluttertoast.showToast(msg: "The device is disconnected",textColor: MainTextColor,backgroundColor: PrimaryColor);;

        },),
        Slider(min:0,max:180,value: val3,divisions: 180, label:val3.round().toString(), onChanged: (v){
          setState(() {
            val3=v;

          });
        },onChangeEnd: (value) async {
          connection?.isConnected??false ?  _sendMessage(val3.toInt().toString()+ServoCharacter3): Fluttertoast.showToast(msg: "The device is disconnected",textColor: MainTextColor,backgroundColor: PrimaryColor);;

        },),
        Slider(min:0,max:180,value: val4,divisions: 180, label:val4.round().toString(), onChanged: (v){
          setState(() {
            val4=v;

          });
        },onChangeEnd: (value) async {
          connection?.isConnected??false ?  _sendMessage(val4.toInt().toString()+ServoCharacter4): Fluttertoast.showToast(msg: "The device is disconnected",textColor: MainTextColor,backgroundColor: PrimaryColor);;

        },),
      ],)),
    );
  }
void _startChat(BuildContext context, BluetoothDevice server,String valu) {
  BluetoothConnection.toAddress(server.address).then((_connection) {
    print('Connected to the device');
    connection = _connection;
    setState(() {
      isConnecting = false;
      isDisconnecting = false;
    });
    _sendMessage(valu);
    connection!.input!.listen(_onDataReceived).onDone(() {
      // Example: Detect which side closed the connection
      // There should be `isDisconnecting` flag to show are we are (locally)
      // in middle of disconnecting process, should be set before calling
      // `dispose`, `finish` or `close`, which all causes to disconnect.
      // If we except the disconnection, `onDone` should be fired as result.
      // If we didn't except this (no flag set), it means closing by remote.
      if (isDisconnecting) {
        print('Disconnecting locally!');
      } else {
        print('Disconnected remotely!');
      }
      if (this.mounted) {
        setState(() {});
      }
    });
  }).catchError((error) {
    print('Cannot connect, exception occured');
    print(error);
  });
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return ChatPage(server: server);
      },
    ),
  );
}
void _onDataReceived(Uint8List data) {
  // Allocate buffer for parsed data
  int backspacesCounter = 0;
  data.forEach((byte) {
    if (byte == 8 || byte == 127) {
      backspacesCounter++;
    }
  });
  Uint8List buffer = Uint8List(data.length - backspacesCounter);
  int bufferIndex = buffer.length;

  // Apply backspace control character
  backspacesCounter = 0;
  for (int i = data.length - 1; i >= 0; i--) {
    if (data[i] == 8 || data[i] == 127) {
      backspacesCounter++;
    } else {
      if (backspacesCounter > 0) {
        backspacesCounter--;
      } else {
        buffer[--bufferIndex] = data[i];
      }
    }
  }

  // Create message if there is new line character
  String dataString = String.fromCharCodes(buffer);
  int index = buffer.indexOf(13);
  /*
  if (~index != 0) {
    setState(() {
      messages.add(
        _Message(
          1,
          backspacesCounter > 0
              ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        ),
      );
      _messageBuffer = dataString.substring(index);
    });
  } else {
    _messageBuffer = (backspacesCounter > 0
        ? _messageBuffer.substring(
        0, _messageBuffer.length - backspacesCounter)
        : _messageBuffer + dataString);
  }*/
}

void _sendMessage(String text) async {
  text = text.trim();


  if (text.length > 0) {
    try {

      connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r")));
      await connection!.output.allSent;

      setState(() {
        // messages.add(_Message(clientID, text));
      });

      // Future.delayed(Duration(milliseconds: 333)).then((_) {
      //   // listScrollController.animateTo(
      //   //     listScrollController.position.maxScrollExtent,
      //   //     duration: Duration(milliseconds: 333),
      //   //     curve: Curves.easeOut);
      // });
    } catch (e) {
      // Ignore error, but notify state
      setState(() {});
    }
  }
}
}
