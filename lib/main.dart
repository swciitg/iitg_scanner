import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/pages/homeManagement.dart';
import 'package:iitg_idcard_scanner/pages/scanNow.dart';
import 'package:iitg_idcard_scanner/pages/showScanDetails.dart';
import 'package:iitg_idcard_scanner/pages/splash.dart';
import 'package:iitg_idcard_scanner/pages/studentsList.dart';

import 'globals/myColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Something has gone wrong!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            supportedLocales: [
              Locale('en'),
            ],
            title: 'IITG Scanner',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: Splash(),
            routes: {
              Splash.id: (context) => Splash(),
              HomeManagement.id: (context) => HomeManagement(),
              ScanNow.id: (context) => ScanNow(),
              StudentsList.id: (context) => StudentsList(),
              ShowScanDetails.id:(context) => ShowScanDetails(),
            },
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'IITG Scanner',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: Material(
            color: MyColors.white,
          ),
        );
      },
    );
  }
}
