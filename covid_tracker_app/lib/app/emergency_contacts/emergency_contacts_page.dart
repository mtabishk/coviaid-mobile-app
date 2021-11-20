import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    try {
      print(url);
      await launch(url);
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency"),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Emergency Contacts",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: () {}),
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/father.png"),
              ),
              title: Text("Father"),
              subtitle: Text("+91 8491 993 091"),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/mother.png"),
              ),
              title: Text("Mother"),
              subtitle: Text("+91 9871 993 009"),
            ),
            Text(
              "Health Centers",
              style: TextStyle(fontSize: 18.0),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/health.png"),
              ),
              title: Text("Healthline Multispeciality Clinic"),
              subtitle: Text("0191 252 0816"),
              onTap: () =>
                  _launchUrl('https://maps.app.goo.gl/4tAE77GS3i7j7SYi9'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/health.png"),
              ),
              title: Text("Mattoo Health Care"),
              subtitle: Text("0191 252 3322"),
              onTap: () => _launchUrl('https://goo.gl/maps/tnvRGSftPZHkNg3D6'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/health.png"),
              ),
              title: Text("Swasthya Healthcare"),
              subtitle: Text("084940 73757"),
              onTap: () =>
                  _launchUrl('https://maps.app.goo.gl/r8nDmfmWrw9DeBcY7'),
            ),
            Text(
              "College Helplines",
              style: TextStyle(fontSize: 18.0),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/dispensary.jpg"),
              ),
              title: Text("Dispensary"),
              subtitle: Text("0191 2233116"),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/reception.png"),
              ),
              title: Text("Reception"),
              subtitle: Text("0191 2623116"),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Image.asset("assets/incharge.png"),
              ),
              title: Text("Teacher Incharge"),
              subtitle: Text("0191 2623116"),
            ),
          ],
        ),
      ),
    );
  }
}
