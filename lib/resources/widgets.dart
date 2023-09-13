import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'colors.dart';
import 'constants.dart';
import 'textstyles.dart';

Widget CustomMaterialButton(
        {required String text, required Function() mission}) =>
    MaterialButton(
        shape: StadiumBorder(),
        color: PrimaryColor,
        minWidth: 192,
        padding: EdgeInsets.symmetric(vertical: 15),
        onPressed: () {
          mission();
        },
        child: Text(
          text,
          style: MainTextStyle(),
        ));

CustomReplaceScreen({
  required BuildContext context,
  required Screen,
}) =>
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Screen));

CustomAddScreen({
  required BuildContext context,
  required Screen,
}) =>
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Screen));

CustomSizedBoxSeparated() => SizedBox(
      height: s20,
    );

Widget CustomInputField({
  required String text,
  required TextEditingController textController,
}) =>
    Row(
      children: [
        Text("$text"),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextFormField(
          controller: textController,
          validator: (str) {
            if (str!.isEmpty) return "Field is Empty";
            return null;
          },
        )),
      ],
    );


int val=1;
late Database db;
Future<String> CreateOpenDataBase() async {
  // Get a location using getDatabasesPath
  var databasesPath = await getDatabasesPath();
  return databasesPath.toString() + 'demo.db';

}
Future open(String path) async {
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE ProjectTable (id INTEGER PRIMARY KEY, Projectname TEXT, value INTEGER, num REAL)');
      });
}

add()async{
  await db.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO Project(name) VALUES("some name")');
    print('inserted1: $id1');
    int id2 = await txn.rawInsert(
        'INSERT INTO Test(name) VALUES(?)',
        ['another name']);
    print('inserted2: $id2');
  });
}