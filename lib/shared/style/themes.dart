import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/shared/style/colors.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Poppins',
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.black,),
    color: Colors.white,
    elevation: 0.0,
  ),
  scaffoldBackgroundColor: superBabyBlue,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Colors.grey,
    elevation: 15.0,
    selectedItemColor: Colors.black,
  ),

);

ThemeData DarkTheme = ThemeData(
  fontFamily: 'Poppins',
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: DarkSurface,
    ),
    iconTheme: IconThemeData(color: Colors.white,),
    color: DarkSurface,
    elevation: 0.0,
  ),
  scaffoldBackgroundColor: DarkBackground,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: DarkSurface,
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Colors.grey,
    elevation: 15.0,
    selectedItemColor: Colors.grey.shade100,
  ),

);