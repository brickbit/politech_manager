
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final light = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black54,
        fontFamily: GoogleFonts.montserrat().fontFamily),
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: Colors.transparent,
        titleTextStyle:
        GoogleFonts.montserrat(fontSize: 18.0, color: Colors.black54),
        actionsIconTheme: const IconThemeData(color: Colors.black54),
        iconTheme: const IconThemeData(color: Colors.black54),
        elevation: 0.0),
    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(foregroundColor: Colors.black),
    colorScheme: ThemeData.light()
        .colorScheme
        .copyWith(primary: Colors.green, secondary: Colors.amber),
  );
  static final dark = ThemeData.dark().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.white,
        fontFamily: GoogleFonts.montserrat().fontFamily),
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: Colors.transparent,
        titleTextStyle:
        GoogleFonts.montserrat(fontSize: 18.0, color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0),
    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(foregroundColor: Colors.white),
    colorScheme: ThemeData.light()
        .colorScheme
        .copyWith(primary: Colors.green, secondary: Colors.amber),
  );
}
