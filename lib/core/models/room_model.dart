class RoomModel {
  final String name;
  final String image;
  final int deviceCount;
  final double temperature;
  final double humidity;

  const RoomModel({
    required this.name,
    required this.image,
    required this.deviceCount,
    required this.temperature,
    required this.humidity,
  });
}
