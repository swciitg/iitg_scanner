import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/pages/generateQR.dart';
import 'package:iitg_idcard_scanner/pages/homeManagement.dart';
import 'package:iitg_idcard_scanner/pages/login_page.dart';
import 'package:iitg_idcard_scanner/pages/microsoft.dart';
import 'package:iitg_idcard_scanner/pages/otp_page.dart';
import 'package:iitg_idcard_scanner/pages/scanQR.dart';
import 'package:iitg_idcard_scanner/pages/showScanDetails.dart';
import 'package:iitg_idcard_scanner/pages/splash.dart';
import 'package:iitg_idcard_scanner/pages/studentsList.dart';
import 'package:iitg_idcard_scanner/pages/validateElections/approved.dart';
import 'package:iitg_idcard_scanner/pages/validateElections/rejected.dart';
import 'package:iitg_idcard_scanner/stores/login_store.dart';
import 'package:iitg_idcard_scanner/stores/otp_login_store.dart';
import 'package:provider/provider.dart';

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
          return MultiProvider(
            providers: [
              Provider<LoginStore>(
                create: (_) => LoginStore(),
              ),
              Provider<otpLoginStore>(
                create: (_) => otpLoginStore(),
              )
            ],
            child: MaterialApp(
              supportedLocales: [
                Locale('en'),
              ],
              title: 'IITG Scanner',
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              home: Splash(),
              routes: {
                MicrosoftLogin.id: (context) => MicrosoftLogin(),
                Splash.id: (context) => Splash(),
                HomeManagement.id: (context) => HomeManagement(),
                ScanQR.id: (context) => ScanQR(),
                QRGenerator.id: (context) => QRGenerator(),
                StudentsList.id: (context) => StudentsList(),
                ShowScanDetails.id: (context) => ShowScanDetails(),
                Approved.id: (context) => Approved(),
                Rejected.id: (context) => Rejected(),
                LoginPage.id: (context) => LoginPage(),
              },
            ),
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
