import 'package:covid_tracker_app/app/report/add_report_page.dart';
import 'package:covid_tracker_app/common_widgets/custom_report_tile.dart';
import 'package:covid_tracker_app/common_widgets/empty_content.dart';
import 'package:covid_tracker_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPage extends StatelessWidget {
  ReportPage({required this.database});
  final Database database;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddReportPage(
                          database: database,
                        ),
                    fullscreenDialog: true),
              );
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('reports').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Please try again later',
              );
            }
            if (snapshot.hasData) {
              print(snapshot.data?.docs.length);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomReportTile(
                      title: snapshot.data?.docs[index]['title'],
                      subtitle: snapshot.data?.docs[index]['description'],
                    );
                  },
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
