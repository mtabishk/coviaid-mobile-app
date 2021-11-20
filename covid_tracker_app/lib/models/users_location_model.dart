class UsersLocationModel {
  UsersLocationModel({required this.latitude, required this.longitude});
  final latitude;
  final longitude;

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
