import 'package:flutter/cupertino.dart';
import 'package:new_tetris/bloc/bloc_provider.dart';
import 'package:new_tetris/resourses/repository.dart';
import 'package:new_tetris/themes/custom_themes.dart';
import 'package:new_tetris/themes/themes.dart';
import 'package:rxdart/rxdart.dart';

bool openSettingsScreen = false;

class SettingsBloc extends BlocBase {
  final repository = Repository();
  int index;
  

  final themeIndex = BehaviorSubject();

  Observable get outThemeIndex => themeIndex.stream;

  changeRightThem() {
    index += 1;
    if (index > 4) {
      index = 0;
    }
    themeIndex.add(index);
    print("index ===>>> $index");
  }

  changeLeftThem() {
    index -= 1;
    if (index < 0) {
      index = 4;
    }
    themeIndex.add(index);
    print("index ===>>> $index");
  }

  setThemeIndex() => repository.setThemeIndex(index);

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  getIndexTheme() async {
    index = await repository.getThemeIndex();
    print(
        "indexindexindexindexindexindexindexindexindexindexindexindex => $index");
    if (index == null) {
      index = 0;
      themeIndex.add(index);
    }
    themeIndex.add(index);
  }

  initialThem(context) async {
    index = await repository.getThemeIndex();
    print("index =========>>>> $index");
    switch (index) {
      case 0:
        return _changeTheme(context, MyThemeKeys.grey);
        break;
      case 1:
        return _changeTheme(context, MyThemeKeys.red);
        break;
      case 2:
        return _changeTheme(context, MyThemeKeys.yellow);
        break;
      case 3:
        return _changeTheme(context, MyThemeKeys.pink);
        break;
      case 4:
        return _changeTheme(context, MyThemeKeys.lightBlue);
        break;
      default:
    }
    if (index == null) {
      index = 1;
      themeIndex.add(index);
    }
    themeIndex.add(index);
  }

  // @override
  void dispose() {
    themeIndex.close();
  }
}
