import 'package:covid_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:covid_tracker_app/models/user_account_info_model.dart';
import 'package:covid_tracker_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      //Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _signInWithGoogle(BuildContext context, AuthBase auth) async {
    try {
      await auth.signInWithGoogle();
      bool docExists = await checkIfDocExists(auth.currentuser?.uid as String);
      if (!docExists) {
        String uid = auth.currentuser?.uid as String;
        final reference = FirebaseFirestore.instance.doc('users/$uid');
        await reference.set(UserAccountInfoModel(
                email: auth.currentuser?.email as String,
                displayName: auth.currentuser?.displayName as String,
                username: auth.currentuser?.uid as String,
                contact: "",
                vaccinationDetails: "Not vaccinated",
                currentLocation: "")
            .toMap());
      }
    } on Exception catch (e) {
      if (this.mounted) {
        _showSignInError(context, e);
      }

      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/logo.png"),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/google-logo.png'),
                    Text(
                      "Sign in with Google to continue",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () => _signInWithGoogle(context, auth),
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return null;
                          }
                          return Colors.red;
                          // Use the component's default.
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign In Failed',
      exception: exception,
    );
  }
}
