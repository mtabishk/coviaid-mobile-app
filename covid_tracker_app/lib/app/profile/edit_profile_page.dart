import 'package:covid_tracker_app/common_widgets/avatar.dart';
import 'package:covid_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:covid_tracker_app/models/user_account_info_model.dart';
import 'package:covid_tracker_app/services/auth.dart';
import 'package:covid_tracker_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.auth,
    required this.database,
    required this.userName,
    required this.contact,
    required this.vaccinationStatus,
    required this.currentLocation,
  }) : super(key: key);
  final AuthBase auth;
  final Database database;
  final String userName;
  final String contact;
  final String vaccinationStatus;
  final String currentLocation;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? username;
  String? contact;
  String? vaccinationDetails;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  Future<void> _submit() async {
    print(
        "$username $contact ${widget.vaccinationStatus} ${widget.auth.currentuser?.email} ${widget.auth.currentuser?.displayName} ${widget.currentLocation}");
    if (_validateAndSaveForm()) {
      try {
        // TODO: implement unique username
        await widget.database.setUserAccountInfoData(UserAccountInfoModel(
            email: widget.auth.currentuser?.email,
            currentLocation: widget.currentLocation,
            displayName: widget.auth.currentuser?.displayName,
            username: username,
            contact: contact,
            vaccinationDetails: vaccinationDetails));
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation Failed', exception: e);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(),
        ),
        actions: [
          TextButton(
            child: Text("Save"),
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              _submit();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  maxLength: 30,
                  initialValue: widget.userName,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    labelText: 'Username',
                    hintText: "Enter the username",
                    hintStyle: TextStyle(fontSize: 12, height: 0.3),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  onSaved: (value) => username = value,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  maxLength: 10,
                  initialValue: widget.contact,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    labelText: 'Contact',
                    hintText: "Enter the contact number",
                    hintStyle: TextStyle(fontSize: 12, height: 0.3),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  autofocus: false,
                  onSaved: (value) => contact = value,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vaccination status",
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      value: vaccinationDetails == null
                          ? widget.vaccinationStatus
                          : vaccinationDetails,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'Not vaccinated',
                        'Partially vaccinated',
                        'Fully vaccinated',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Select",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          vaccinationDetails = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
