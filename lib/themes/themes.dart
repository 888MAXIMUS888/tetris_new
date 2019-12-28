import 'package:flutter/material.dart';

enum MyThemeKeys { grey, red, yellow, pink, lightBlue }

class MyThemes {
  static final ThemeData greyTheme = ThemeData(
      primaryColor: Colors.grey,
      accentColor: Colors.grey[300],
      backgroundColor: Colors.grey[400],
      buttonColor: Colors.yellow,
      indicatorColor: Colors.green,
      focusColor: Colors.red);

  static final ThemeData redTheme = ThemeData(
      primaryColor: Colors.red,
      accentColor: Colors.red[200],
      backgroundColor: Colors.red[600],
      buttonColor: Colors.yellow,
      indicatorColor: Colors.green,
      focusColor: Colors.white);

  static final ThemeData yellowTheme = ThemeData(
      primaryColor: Colors.yellow,
      accentColor: Colors.yellow[200],
      backgroundColor: Colors.yellow[600],
      buttonColor: Colors.blueGrey,
      indicatorColor: Colors.green,
      focusColor: Colors.red);

  static final ThemeData pinkTheme = ThemeData(
      primaryColor: Colors.pink[200],
      accentColor: Colors.pink[300],
      backgroundColor: Colors.pink[400],
      buttonColor: Colors.yellow[200],
      indicatorColor: Colors.green,
      focusColor: Colors.purple);

  static final ThemeData lightBlueTheme = ThemeData(
      primaryColor: Colors.teal,
      accentColor: Colors.teal[300],
      backgroundColor: Colors.teal[400],
      buttonColor: Colors.amber,
      indicatorColor: Colors.orange,
      focusColor: Colors.red);

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.grey:
        return greyTheme;
      case MyThemeKeys.red:
        return redTheme;
      case MyThemeKeys.yellow:
        return yellowTheme;
      case MyThemeKeys.pink:
        return pinkTheme;
      case MyThemeKeys.lightBlue:
        return lightBlueTheme;
      default:
        return greyTheme;
    }
  }
}
