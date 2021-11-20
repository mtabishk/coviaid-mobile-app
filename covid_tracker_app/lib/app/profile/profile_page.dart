import 'package:covid_tracker_app/app/profile/edit_profile_page.dart';
import 'package:covid_tracker_app/common_widgets/avatar.dart';
import 'package:covid_tracker_app/common_widgets/empty_content.dart';
import 'package:covid_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:covid_tracker_app/services/auth.dart';
import 'package:covid_tracker_app/services/database.dart';
import 'package:covid_tracker_app/services/location_service.dart';
import 'package:covid_tracker_app/services/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.database}) : super(key: key);
  final Database database;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Cancel',
      cancelActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    try {
      await auth.signOut();
      Provider.of<UnlockProvider>(context, listen: false).faceIsDetected();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _launchUrl(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    try {
      print(googleUrl);
      await launch(googleUrl);
    } catch (e) {
      throw e;
    }
  }

  String? _latitude;
  String? _longitude;

  Future<void> getCurrentLocation() async {
    final locationService = await LocationService().currentLocation();
    if (mounted) {
      setState(() {
        _latitude = locationService.latitude;
        _longitude = locationService.longitude;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  String userName = "";
  String contact = "";
  String vaccinationStatus = "";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc('${auth.currentuser?.uid}')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                        auth: auth,
                        database: widget.database,
                        userName: userName,
                        contact: contact,
                        vaccinationStatus: vaccinationStatus,
                        currentLocation: "$_latitude $_longitude",
                      ),
                  fullscreenDialog: true),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('Logout'),
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Please try again later',
              );
            }
            if (snapshot.hasData) {
              userName = (snapshot.data as dynamic)['username'];
              contact = (snapshot.data as dynamic)['contact'];
              vaccinationStatus =
                  (snapshot.data as dynamic)['vaccinationDetails'];
              return ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text("Email"),
                    subtitle: Text(auth.currentuser?.email ?? ""),
                  ),
                  Divider(thickness: 1.0),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Current location"),
                    subtitle: _latitude != null
                        ? Text("lat: $_latitude \t long: $_longitude",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600))
                        : LinearProgressIndicator(),
                    onTap: () async {
                      setState(() {
                        _latitude = null;
                      });
                      await getCurrentLocation();
                      try {
                        if (_latitude != null && _longitude != null) {
                          await _launchUrl(
                              _latitude as String, _longitude as String);
                        }
                      } catch (e) {
                        print("Cannot open the maps $e");
                      }
                    },
                  ),
                  Divider(thickness: 1.0),
                  ListTile(
                    leading: Icon(Icons.badge),
                    title: Text("Display Name"),
                    subtitle: Text(auth.currentuser?.displayName ?? ""),
                  ),
                  Divider(thickness: 1.0),
                  ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text("Username"),
                    subtitle: Text((snapshot.data as dynamic)['username']),
                  ),
                  Divider(thickness: 1.0),
                  ListTile(
                    leading: Icon(Icons.contact_phone),
                    title: Text("Contact"),
                    subtitle: Text((snapshot.data as dynamic)['contact']),
                  ),
                  Divider(thickness: 1.0),
                  ListTile(
                    leading: Icon(Icons.medical_services),
                    title: Text("Vaccination Status"),
                    subtitle: Text(
                      (snapshot.data as dynamic)['vaccinationDetails'],
                      // style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _buildUserInfo() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar(
          photoUrl: auth.currentuser?.photoURL ?? null,
          radius: 50,
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
