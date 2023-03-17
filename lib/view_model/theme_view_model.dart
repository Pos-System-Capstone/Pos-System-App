import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_constants.dart';
import '../util/share_pref.dart';

class ThemeViewModel extends BaseViewModel {
  SharedPreferences? sharedPreferences;
  ThemeViewModel() {
    _loadCurrentTheme();
  }
  bool _darkTheme = false;
  int _colorIndex = 0;
  bool get darkTheme => _darkTheme;
  int get colorIndex => _colorIndex;
  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences?.setBool(AppConstants.THEME, _darkTheme);
    notifyListeners();
  }

  void _loadCurrentTheme() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _colorIndex = await getThemeColor() ?? 0;
    _darkTheme = sharedPreferences?.getBool(AppConstants.THEME) ?? false;
  }

  void handleColorSelect(int value) {
    setThemeColor(value);
    _colorIndex = value;
    showAlertDialog(
      title: 'Change Theme',
      content: 'Please restart app to apply new theme',
    );
    notifyListeners();
  }
}
