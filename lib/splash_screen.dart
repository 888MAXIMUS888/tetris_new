import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    startTimer();
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1700));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScaleTransition(
            scale: controller,
            child: Center(
              child: Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Image.asset("assets/a5.png"),
              ),
            )));
  }

  startTimer() async {
    return Timer(Duration(seconds: 2), navigationPage);
  }

  navigationPage() {
    Navigator.of(context).pushReplacementNamed('/tetris');
  }
}
