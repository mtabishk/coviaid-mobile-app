import 'package:flutter/material.dart';

class CustomListCard extends StatelessWidget {
  const CustomListCard({Key? key, required this.data, required this.title})
      : super(key: key);
  final data;
  final title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            leading: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600)),
            trailing: Text(
              data,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            )),
      ),
    );
  }
}
