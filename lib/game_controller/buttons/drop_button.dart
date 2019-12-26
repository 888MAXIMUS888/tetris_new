import 'package:flutter/material.dart';
import 'package:new_tetris/game_controller/widgets/button.dart';
import 'package:new_tetris/game_controller/widgets/description.dart';

class DropButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Description(
        text: 'drop',
        child: Button(
            color: Theme.of(context).buttonColor,
            enableLongPress: false,
            size: Size(90, 90),
            onTap: () {}));
  }
}
