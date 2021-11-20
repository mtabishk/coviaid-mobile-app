import 'package:covid_tracker_app/landing_page.dart';
import 'package:covid_tracker_app/services/auth.dart';
import 'package:covid_tracker_app/services/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthBase>(create: (context) => Auth()),
          ChangeNotifierProvider<UnlockProvider>(
              create: (_) => UnlockProvider()),
        ],
        child: MaterialApp(
          title: 'CoviAid',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: MyFirebaseApp(),
        ));
  }
}
