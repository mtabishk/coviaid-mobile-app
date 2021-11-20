import 'package:covid_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:covid_tracker_app/app/navigation_bar_page.dart';
import 'package:covid_tracker_app/app/face_unlock/face_unlock_page.dart';
import 'package:covid_tracker_app/services/auth.dart';
import 'package:covid_tracker_app/services/database.dart';
import 'package:covid_tracker_app/services/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:covid_tracker_app/common_widgets/empty_content.dart';
import 'package:firebase_core/firebase_core.dart';

class MyFirebaseApp extends StatefulWidget {
  
  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
 
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Please try again later',
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return LandingPage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    bool faceDetected =
        Provider.of<UnlockProvider>(context, listen: true).faceDetected;

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      //initialData: null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }

          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: faceDetected ? AppPage() : FaceUnlockPage(),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
