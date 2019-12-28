import 'package:new_tetris/resourses/shared_preferences.dart';

class Repository {
  final sharedPref = SharedPrefs();

  setThemeIndex(index) => sharedPref.setThemeIndex(index);
  getThemeIndex() => sharedPref.getThemeIndex();
}
