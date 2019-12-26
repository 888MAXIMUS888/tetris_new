import 'package:flutter/material.dart';

class Display extends StatefulWidget {
  final double width;

  Display({@required this.width});

  @override
  State<StatefulWidget> createState() {
    return DisplayState();
  }
}

class DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = widget.width * 0.6;
    return Container(
      width: widget.width,
      height: (playerPanelWidth - 6) * 2 + 6,
    );
  }
}
