enum DeviceLayout { grid, wide }

class DeviceModel {
  final String name;
  final String image;
  final int deviceCount;
  final bool isOn;
  final DeviceLayout layout;
  final int badgeColorValue;

  const DeviceModel({
    required this.name,
    required this.image,
    required this.deviceCount,
    required this.isOn,
    required this.layout,
    required this.badgeColorValue,
  });

  DeviceModel copyWith({bool? isOn}) => DeviceModel(
        name: name,
        image: image,
        deviceCount: deviceCount,
        isOn: isOn ?? this.isOn,
        layout: layout,
        badgeColorValue: badgeColorValue,
      );
}
