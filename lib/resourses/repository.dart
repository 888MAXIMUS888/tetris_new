import 'package:new_tetris/resourses/ads_banner.dart';
import 'package:new_tetris/resourses/shared_preferences.dart';

class Repository {
  final sharedPref = SharedPrefs();
  final ads = Ads();

  setThemeIndex(index) => sharedPref.setThemeIndex(index);
  getThemeIndex() => sharedPref.getThemeIndex();
  adsBanner() => ads.showBanner();
}
