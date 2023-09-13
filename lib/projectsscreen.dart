import 'package:flutter/material.dart';

import 'bluetooth/SelectBondedDevicePage.dart';
import 'helper.dart';
import 'newprojectscreen.dart';
import 'resources/colors.dart';
import 'resources/strings.dart';
import 'resources/widgets.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {

  TextEditingController NameController = TextEditingController();
  String path="";
  final dbHelper = DatabaseHelper.instance;

  var FormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(noProjects,style: TextStyle(
              color: MainTextColor,
              fontSize: 25
            ),),
            CustomSizedBoxSeparated(),
            CustomMaterialButton(text: AddNewProject, mission: ()=>_AddNewProjectMission(context)),
          ],
        ),
      ),
    );
  }

  _AddNewProjectMission(BuildContext context) {
    showDialog(
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
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("add"),
              onPressed: ()async {
                if (FormKey.currentState!.validate()) {

                  setState(() {
                    Project = NameController.text;
                  });
                 await  _insert(name:Project );
                  CustomReplaceScreen(
                      context: context,
                      Screen: SelectBondedDevicePage(checkAvailability: false));
                }
              },
            ),

          ],
        );
      },
    );
  }

   _insert({required String name}) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : name,

    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }
}
