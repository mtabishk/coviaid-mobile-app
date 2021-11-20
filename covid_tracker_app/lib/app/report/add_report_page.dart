import 'package:covid_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:covid_tracker_app/models/report_model.dart';
import 'package:covid_tracker_app/services/auth.dart';
import 'package:covid_tracker_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({Key? key, required this.database}) : super(key: key);
  final Database database;

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _title;
  String? _description;

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
    if (_validateAndSaveForm()) {
      print("$_title $_description");
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);

        await widget.database.addReport(ReportModel(
          email: auth.currentuser?.email,
          title: _title,
          description: _description,
          location: "null",
          attachment1: "null",
          attachment2: "null",
          attachment3: "null",
        ));
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
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Report"),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          TextButton(
            child: Text("Submit"),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  enabled: false,
                  initialValue: auth.currentuser?.email,
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
                    labelText: 'Email',
                    hintText: "Enter your email",
                    hintStyle: TextStyle(fontSize: 12, height: 0.3),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  onSaved: (value) => _email = value,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
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
                    labelText: 'Title',
                    hintText: "Enter the Title",
                    hintStyle: TextStyle(fontSize: 12, height: 0.3),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  onSaved: (value) => _title = value,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  maxLines: 10,
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
                    labelText: 'Description',
                    hintText: "Enter the description",
                    hintStyle: TextStyle(fontSize: 12, height: 0.3),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  onSaved: (value) => _description = value,
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Location", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.my_location, color: Colors.blue),
                    SizedBox(width: 8),
                    TextButton(
                        child: Text("Current Location",
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {}),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Attachments", style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    TextButton(
                        child: Text("Select",
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {}),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    TextButton(
                        child: Text("Select",
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {}),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    TextButton(
                        child: Text("Select",
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {}),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
