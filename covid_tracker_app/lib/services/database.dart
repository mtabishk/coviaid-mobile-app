import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker_app/models/report_model.dart';
import 'package:covid_tracker_app/models/user_account_info_model.dart';
import 'package:covid_tracker_app/models/users_location_model.dart';

abstract class Database {
  Future<void> setUserAccountInfoData(UserAccountInfoModel data);
  Future<void> addReport(ReportModel data);
  Future<void> addUsersLocation(UsersLocationModel data);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> setUserAccountInfoData(UserAccountInfoModel data) async {
    String path = 'users/$uid';
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data.toMap());
  }

  @override
  Future<void> addReport(ReportModel data) async {
    String path = 'reports/$uid';

    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data.toMap());
  }

  @override
  Future<void> addUsersLocation(UsersLocationModel data) async {
    String path = 'users_location/$uid';

    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data.toMap());
  }
}
