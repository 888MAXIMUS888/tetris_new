import 'package:flutter/material.dart';

class StatusPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("points",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          // Number(number: GameState.of(context).points),
          SizedBox(height: 10),
          Text("cleans",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          // Number(number: GameState.of(context).cleared),
          SizedBox(height: 10),
          Text("level",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          // Number(number: GameState.of(context).level),
          SizedBox(height: 10),
          Text("next",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          // _NextBlock(),
          Spacer(),
          // _GameStatus(),
        ],
      ),
    );
  }
}