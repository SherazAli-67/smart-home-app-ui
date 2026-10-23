import 'package:smart_home_app/constants/string_const.dart';
import 'package:smart_home_app/core/app_colors.dart';
import 'package:smart_home_app/core/asset_res.dart';
import 'package:smart_home_app/core/models/ac_mood_model.dart';
import 'package:smart_home_app/core/models/ar_hotspot_model.dart';
import 'package:smart_home_app/core/models/device_model.dart';
import 'package:smart_home_app/core/models/room_model.dart';

class AppData {
  static const rooms = [
    RoomModel(name: StringConst.kitchen, image: AssetRes.kitchenRoom, deviceCount: 5, temperature: 23, humidity: 40),
    RoomModel(name: StringConst.livingRoom, image: AssetRes.livingRoom, deviceCount: 8, temperature: 25, humidity: 35),
    RoomModel(name: StringConst.bathroom, image: AssetRes.bathroomRoom, deviceCount: 3, temperature: 24, humidity: 55),
  ];

  static const devices = [
    DeviceModel(name: StringConst.homepodMini, image: AssetRes.homepodMini, deviceCount: 2, isOn: true, layout: .grid, badgeColorValue: 0xFF00CC9A),
    DeviceModel(name: StringConst.smartLight, image: AssetRes.smartLight, deviceCount: 3, isOn: false, layout: .grid, badgeColorValue: 0xFFFFC107),
    DeviceModel(name: StringConst.vacuumCleaner, image: AssetRes.vacuumCleaner, deviceCount: 1, isOn: true, layout: .wide, badgeColorValue: 0xFFFF8A00),
  ];

  static const acRoomTabs = [StringConst.livingRoom, StringConst.kitchen, StringConst.bathroom, StringConst.lastEdit];

  static const acMoods = [
    AcMoodModel(label: StringConst.cool, icon: AssetRes.icCool),
    AcMoodModel(label: StringConst.dry, icon: AssetRes.icDry),
    AcMoodModel(label: StringConst.heat, icon: AssetRes.icHeat),
    AcMoodModel(label: StringConst.warm, icon: AssetRes.icWarm),
  ];

  static const arRooms = [StringConst.livingRoom, StringConst.bedroom, StringConst.kitchen];

  static const arHotspots = [
    ArHotspotModel(label: StringConst.airConditions, icon: AssetRes.icAirCondition, top: 163, left: 36, labelTop: 159, labelLeft: 166, labelOnRight: true),
    ArHotspotModel(label: StringConst.lamp, icon: AssetRes.icLamp, top: 321, left: 151, labelTop: 414, labelLeft: 72, labelOnRight: false),
  ];

  static const primaryGradientColors = [AppColors.primary, AppColors.primaryLight];
}
