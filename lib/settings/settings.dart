import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/bloc_provider.dart';
import 'package:new_tetris/bloc/settings_bloc.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  List<Color> colorsPalette = [
    Colors.grey,
    Colors.red,
    Colors.yellow,
    Colors.pink[200],
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    settingsBloc.getIndexTheme();
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: <Widget>[
          Text("Themes"),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                crossAxisCount: 5,
              ),
              itemCount: colorsPalette.length,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder(
                  stream: settingsBloc.outThemeIndex,
                  builder: (context, snapshot) {
                    if (index == snapshot.data) {
                      return Container(
                        decoration: BoxDecoration(
                            color: colorsPalette[index],
                            border: Border.all(color: Colors.black, width: 3)),
                        width: 10,
                        height: 10,
                      );
                    } else {
                      return Container(
                        width: 10,
                        height: 10,
                        color: colorsPalette[index],
                      );
                    }
                  },
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
