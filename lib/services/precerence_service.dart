import 'package:shared_preferences/shared_preferences.dart';

class PrecerenceService {
  static const String _savingGoalKey = "saving_goal";

  static Future<void> saveGoal(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_savingGoalKey, amount);
  }

  static Future<double> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_savingGoalKey) ?? .0;
  }
}
