import 'package:flutter/material.dart';

class CustomReportTile extends StatelessWidget {
  CustomReportTile({Key? key, required this.title, required this.subtitle})
      : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
        ),
        Divider(thickness: 1.0),
      ],
    );
  }
}
