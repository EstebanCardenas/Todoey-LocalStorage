import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesProvider = Provider((ref) => SharedPreferencesClient());

class SharedPreferencesClient {
  static const String _colorKey = 'PRIMARY_COLOR';

  Future<String> getPrimaryColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_colorKey) ?? 'Light Blue';
  }

  Future<void> setPrimaryColor(String colorName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_colorKey, colorName);
  }
}
