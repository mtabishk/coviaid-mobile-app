class UserAccountInfoModel {
  UserAccountInfoModel({
    required this.email,
    required this.currentLocation,
    required this.displayName,
    required this.username,
    required this.contact,
    required this.vaccinationDetails,
  });

  final email;
  final currentLocation;
  final displayName;
  final username;
  final contact;
  final vaccinationDetails;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'currentLocation': currentLocation,
      'displayName': displayName,
      'username': username,
      'contact': contact,
      'vaccinationDetails': vaccinationDetails,
    };
  }
}
