import 'package:flutter/foundation.dart';
import 'package:smart_home_app/core/app_data.dart';

class BedroomArProvider extends ChangeNotifier {
  int selectedRoomIndex = 1;

  String get selectedRoom => AppData.arRooms[selectedRoomIndex];

  void selectRoom(int index) {
    selectedRoomIndex = index.clamp(0, AppData.arRooms.length - 1);
    notifyListeners();
  }

  void selectNextRoom() {
    if (selectedRoomIndex >= AppData.arRooms.length - 1) return;
    selectedRoomIndex++;
    notifyListeners();
  }

  void selectPreviousRoom() {
    if (selectedRoomIndex <= 0) return;
    selectedRoomIndex--;
    notifyListeners();
  }
}
