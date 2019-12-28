import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  Future setThemeIndex(int indexThem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("themeIndex", indexThem);
    print("indexThem========== >>>>>>>> $indexThem");
  }

  Future getThemeIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("themeIndex");
  }
}
