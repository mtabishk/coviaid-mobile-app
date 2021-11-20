import 'package:covid_tracker_app/app/emergency_contacts/emergency_contacts_page.dart';
import 'package:covid_tracker_app/app/feed/feed_page.dart';
import 'package:covid_tracker_app/app/home/home_page.dart';
import 'package:covid_tracker_app/app/profile/profile_page.dart';
import 'package:covid_tracker_app/app/report/report_page.dart';
import 'package:covid_tracker_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    Widget child = HomePage(database: database);
    switch (_index) {
      case 0:
        child = HomePage(database: database);
        break;
      case 1:
        child = FeedPage();
        break;
      case 2:
        // Emergeny Contacts
        child = EmergencyContactsPage();
        break;
      case 3:
        child = ReportPage(database: database);
        break;
      case 4:
        child = ProfilePage(database: database);
        break;
    }
    return Scaffold(
      body: SizedBox.expand(child: child),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() => _index = newIndex),
        currentIndex: _index,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _index != 0
                ? Icon(
                    Icons.home_outlined,
                  )
                : Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _index != 1
                ? Icon(
                    Icons.feed_outlined,
                  )
                : Icon(Icons.feed),
            label: "Feed",
          ),
          BottomNavigationBarItem(
            icon: _index != 2
                ? Icon(
                    Icons.health_and_safety_outlined,
                  )
                : Icon(Icons.health_and_safety),
            label: "Emergency",
          ),
          BottomNavigationBarItem(
            icon: _index != 3
                ? Icon(
                    Icons.report_outlined,
                  )
                : Icon(Icons.report),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: _index != 4
                ? Icon(
                    Icons.account_circle_outlined,
                  )
                : Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
