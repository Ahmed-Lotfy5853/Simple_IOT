import 'package:flutter/material.dart';
import 'package:simplestepsiot/resources/colors.dart';

import 'newprojectscreen.dart';
import 'resources/strings.dart';
import 'resources/textstyles.dart';
import 'resources/widgets.dart';

class ConfigurationScreen extends StatefulWidget {
   ConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
TextEditingController Servo1Controller = TextEditingController();

TextEditingController Servo2Controller = TextEditingController();

TextEditingController Servo3Controller = TextEditingController();

TextEditingController Servo4Controller = TextEditingController();
var ConfKey = GlobalKey<FormState>();
@override
  void initState() {
  Servo1Controller.text = ServoCharacter1;
  Servo2Controller.text = ServoCharacter2;
  Servo3Controller.text = ServoCharacter3;
  Servo4Controller.text = ServoCharacter4;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondaryColor,
      appBar: AppBar(
        title: Text(Configuration),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: ConfKey,
              child: Column(
                children: [

                  CustomConfigureItem(itemController: Servo1Controller, text: "Servo 1 : ", content: ServoCharacter1) ,
                  CustomSizedBoxSeparated(),
                  CustomConfigureItem(itemController: Servo2Controller, text: "Servo 2 : ", content: ServoCharacter2) ,
                  CustomSizedBoxSeparated(),
                  CustomConfigureItem(itemController: Servo3Controller, text: "Servo 3 : ", content: ServoCharacter3) ,
                  CustomSizedBoxSeparated(),
                  CustomConfigureItem(itemController: Servo4Controller, text: "Servo 4 : ", content: ServoCharacter4) ,
                  CustomSizedBoxSeparated(),
                  CustomMaterialButton(text: "Save",mission: (){
                      if(ConfKey.currentState!.validate()){
                      setState(() {
                        ServoCharacter1 = Servo1Controller.text;
                        ServoCharacter2 = Servo2Controller.text;
                        ServoCharacter3 = Servo3Controller.text;
                        ServoCharacter4 = Servo4Controller.text;
                      });
                    }
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("All copy rights reversed ©Simple Steps academy  @Kafr El-Sheikh",style: MainTextStyle(size: 18.0),)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
CustomConfigureItem({
  required TextEditingController itemController,
  required String text,
  required String content,
}) {

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: MainTextStyle(),
      ),
      SizedBox(
        width: 30,
        height: 30,
        child: TextFormField(
          controller: itemController,
          keyboardType: TextInputType.name,
          validator: (str) {
            if (str!.isEmpty) return "Empty Field";
            return null;
          },
          style: MainTextStyle(size: 18),

          textAlign: TextAlign.center,
          cursorColor: MainTextColor,
          onFieldSubmitted: (str){
            content = str;
          },
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              counterText: ""),
          maxLength: 1,
        ),
      )
    ],
  );
}