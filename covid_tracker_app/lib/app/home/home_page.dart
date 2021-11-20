import 'package:covid_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:covid_tracker_app/models/users_location_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final webViewKey = GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.database}) : super(key: key);
  final database;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mapUrl =
      "http://ec2-52-66-199-153.ap-south-1.compute.amazonaws.com/map.html";
  WebViewController? _webViewController;

  String? _latitude;
  String? _longitude;

  // Future<void> _sendUsersLocation() async {
  //   try {
  //     await _currentLocation();
  //     await widget.database.addUsersLocation(UsersLocationModel(
  //       latitude: _latitude,
  //       longitude: _longitude,
  //     ));
  //     Navigator.of(context).pop();
  //   } on FirebaseException catch (e) {
  //     showExceptionAlertDialog(context,
  //         title: 'Operation Failed', exception: e);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CoviAid"),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              _reloadWebView();
              // await _sendUsersLocation();
            },
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: WebView(
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        initialUrl: mapUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  void _reloadWebView() {
    _webViewController?.reload();
  }
}
