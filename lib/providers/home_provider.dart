import 'package:flutter/material.dart';
import 'package:smart_home_app/constants/number_constant.dart';
import 'package:smart_home_app/core/app_data.dart';
import 'package:smart_home_app/core/models/device_model.dart';

class HomeProvider extends ChangeNotifier {
  List<DeviceModel> devices = List.from(AppData.devices);

  final roomPageController = PageController(viewportFraction: NumberConstant.roomCarouselViewportFraction, initialPage: 1);

  List<DeviceModel> get gridDevices => devices.where((d) => d.layout == .grid).toList();

  List<DeviceModel> get wideDevices => devices.where((d) => d.layout == .wide).toList();

  void toggleDevice(int index) {
    devices[index] = devices[index].copyWith(isOn: !devices[index].isOn);
    notifyListeners();
  }

  void toggleDeviceByName(String name) {
    final index = devices.indexWhere((d) => d.name == name);
    if (index == -1) return;
    toggleDevice(index);
  }

  @override
  void dispose() {
    roomPageController.dispose();
    super.dispose();
  }
}

