import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.deepPurple;
  static const Color darkPrimary = Colors.cyan;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    //primary color
    primaryColor: primary,
    //appbar theme
    appBarTheme: const AppBarTheme(
        color: primary,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    //Scaffolds
    scaffoldBackgroundColor: Colors.grey[300],
    //TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(primary.withOpacity(0.1)),
        shape: MaterialStateProperty.all(const StadiumBorder()),
      ),
    ),
    //floatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary, elevation: 10),
    //ElevatedButtontheme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            shape: const StadiumBorder(),
            elevation: 5)),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    //primary color
    useMaterial3: true,
    primaryColor: darkPrimary,
    //appbar theme
    appBarTheme: const AppBarTheme(
      color: darkPrimary,
      elevation: 0,
    ),
    //TextButton theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: darkPrimary),
    ),
    //floatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary, elevation: 10),
    //ElevatedButtontheme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: darkPrimary,
            shape: const StadiumBorder(),
            elevation: 5)),
  );
}
