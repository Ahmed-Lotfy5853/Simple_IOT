import 'package:flutter/material.dart';

MaterialColor myColor = const MaterialColor(0xffbc1c4c,
    const {
      50 : const Color(0xffbc1c4c),
      100 : const Color(0xffa91944),
      200 : const Color(0xff96163d),
      300 : const Color(0xff841435),
      400 : const Color(0xff71112e),
      500 : const Color(0xff5e0e26),
      600 : const Color(0xff4b0b1e),
      700 : const Color(0xff380817),
      800 : const Color(0xff26060f),
      900 : const Color(0xff130308)});
// use MaterialColor: myGreen.shade100,myGreen.shade500 ...
// myGreen.shade50 // Color === 0xFFAAD401
Color PrimaryColor = myColor;
Color SecondaryColor = Color(0xff145454) ;
 Color MainTextColor = Colors.white ;