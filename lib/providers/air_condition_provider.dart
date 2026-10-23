import 'package:flutter/foundation.dart';
import 'package:smart_home_app/constants/number_constant.dart';
import 'package:smart_home_app/core/app_data.dart';

class AirConditionProvider extends ChangeNotifier {
  int selectedRoomIndex = 0;
  int selectedMoodIndex = 0;
  double temperature = 32;
  double timerHours = 8;
  bool isPowerOn = true;

  void selectRoom(int index) {
    selectedRoomIndex = index;
    notifyListeners();
  }

  void selectMood(int index) {
    selectedMoodIndex = index;
    notifyListeners();
  }

  void setTemperature(double value) {
    temperature = value.clamp(16, 32);
    notifyListeners();
  }

  void setTimerHours(double value) {
    timerHours = value.clamp(NumberConstant.timerMin, NumberConstant.timerMax);
    notifyListeners();
  }

  void togglePower() {
    isPowerOn = !isPowerOn;
    notifyListeners();
  }

  String get selectedRoom => AppData.acRoomTabs[selectedRoomIndex];

  String get selectedMood => AppData.acMoods[selectedMoodIndex].label;
}
