import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/briks.dart';
import 'package:new_tetris/material.dart';
import 'package:new_tetris/player_panel.dart';
import 'package:new_tetris/settings/settings.dart';
import 'package:new_tetris/status_panel.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'dart:math';

class Display extends StatefulWidget {

  final ScreenBloc screenBloc;
  final double width;
  final gameState;

  Display({@required this.width, this.screenBloc, this.gameState});

  @override
  State<StatefulWidget> createState() {
    return DisplayState();
  }
}

class DisplayState extends State<Display> {
  
  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = widget.width * 0.6;
    return 
    // Shake(
    //   shake: GameState.of(context).states == GameStates.drop,
    //   child:
    Stack(children: <Widget>[
    Container(
        width: widget.width,
        height: (playerPanelWidth - 6) * 2 + 6,
        child: GameMaterial(
          child: BrikSize(
            size: getBrikSizeForScreenWidth(playerPanelWidth),
            child: Row(
              children: <Widget>[
                PlayerPanel(width: playerPanelWidth, screenBloc: widget.screenBloc, gameState: widget.gameState,)
                ,
                SizedBox(
                  width: widget.width - playerPanelWidth,
                  child: StatusPanel(),
                )
              ],
            ),
          ),
        )),
        StreamBuilder(
        stream: widget.screenBloc.outSettingsScreen,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              width: widget.width,
              height: (playerPanelWidth - 6) * 2 + 6,
              child: Settings(),
            );
          } else {
            return Container(
              width: widget.width,
              height: (playerPanelWidth - 6) * 2 + 6,
            );
          }
        },
      )
        ]);
  }
}

// class Shake extends StatefulWidget {
//   final Widget child;

//   ///true to shake screen vertically
//   final bool shake;

//   const Shake({Key key, @required this.child, @required this.shake})
//       : super(key: key);

//   @override
//   _ShakeState createState() => _ShakeState();
// }

// ///摇晃屏幕
// class _ShakeState extends State<Shake> with TickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   void initState() {
//     _controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 150))
//           ..addListener(() {
//             setState(() {});
//           });
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(Shake oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.shake) {
//       _controller.forward(from: 0);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   v.Vector3 _getTranslation() {
//     double progress = _controller.value;
//     double offset = sin(progress * pi) * 1.5;
//     return v.Vector3(0, offset, 0.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Transform(
//       transform: Matrix4.translation(_getTranslation()),
//       child: widget.child,
//     );
//   }
// }

