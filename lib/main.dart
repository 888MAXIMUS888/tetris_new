import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/bloc_provider.dart';
import 'package:new_tetris/bloc/settings_bloc.dart';
import 'package:new_tetris/tetris.dart';
import 'package:new_tetris/themes/custom_themes.dart';

void main() => runApp(CustomTheme(child: MyApp()));

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: SettingsBloc(),
        child: MaterialApp(
            navigatorObservers: [routeObserver],
            theme: CustomTheme.of(context),
            home: Scaffold(body: Tetris())));
  }
}
