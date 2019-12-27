import 'package:flutter/material.dart';
import 'package:new_tetris/gamer.dart';
import 'package:new_tetris/tetris.dart';

void main() => runApp(MyApp());

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [routeObserver],
      home: Tetris()
    );
  }
}