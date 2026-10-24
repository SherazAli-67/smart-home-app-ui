import 'package:flutter/foundation.dart';
import 'package:smart_home_app/core/app_data.dart';

class BedroomArProvider extends ChangeNotifier {
  int selectedRoomIndex = 1;

  /// 1 = next/forward, -1 = previous/back — drives room selector slide.
  int slideDirection = 1;

  String get selectedRoom => AppData.arRooms[selectedRoomIndex];

  void selectRoom(int index) {
    final clamped = index.clamp(0, AppData.arRooms.length - 1);
    if (clamped == selectedRoomIndex) return;
    slideDirection = clamped > selectedRoomIndex ? 1 : -1;
    selectedRoomIndex = clamped;
    notifyListeners();
  }

  void selectNextRoom() {
    if (selectedRoomIndex >= AppData.arRooms.length - 1) return;
    slideDirection = 1;
    selectedRoomIndex++;
    notifyListeners();
  }

  void selectPreviousRoom() {
    if (selectedRoomIndex <= 0) return;
    slideDirection = -1;
    selectedRoomIndex--;
    notifyListeners();
  }
}
