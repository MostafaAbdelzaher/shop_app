import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';

ThemeData lightThem = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 25,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
      bodyText2: TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
      caption: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
);
ThemeData darkThem = ThemeData(
    primarySwatch: defaultColor,
    textTheme: TextTheme(
        caption: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        bodyText2: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
    scaffoldBackgroundColor: HexColor('333739'),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HexColor('333739'),
        elevation: 25,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey),
    appBarTheme: AppBarTheme(
      titleSpacing: 20,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ));
