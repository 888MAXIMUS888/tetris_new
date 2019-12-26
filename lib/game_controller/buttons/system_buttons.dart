import 'package:flutter/material.dart';
import 'package:new_tetris/game_controller/widgets/button.dart';
import 'package:new_tetris/game_controller/widgets/description.dart';

class SystemButtonGroup extends StatelessWidget {
  final Size systemButtonSize = const Size(24, 24);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Description(
          text: "sounds",
          child: Button(
              size: systemButtonSize,
              color: Theme.of(context).indicatorColor,
              enableLongPress: false,
              onTap: () {}),
        ),
        Description(
          text: "pause/resume",
          child: Button(
              size: systemButtonSize,
              color: Theme.of(context).indicatorColor,
              enableLongPress: false,
              onTap: () {}),
        ),
        Description(
          text: "reset",
          child: Button(
              size: systemButtonSize,
              enableLongPress: false,
              color: Theme.of(context).indicatorColor,
              onTap: () {}),
        )
      ],
    );
  }
}
