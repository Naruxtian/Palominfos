import 'package:flutter/material.dart';

class AppTheme{
  
  static final ThemeData christmasThemeDark = ThemeData.dark().copyWith(
    primaryColor: Colors.red,
    
    appBarTheme: const AppBarTheme(
      color: Colors.red,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.green[900],
  );
}