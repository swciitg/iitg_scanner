import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iitg_idcard_scanner/stores/login_store.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:provider/provider.dart';

class QRGenerator extends StatefulWidget {
  static String id = 'generate-qr';
  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

Widget loadingDialog(BuildContext context) {
  return new AlertDialog(
      title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      MySpaces.hLargeGapInBetween,
      MyFonts().body('Loading', MyColors.black),
    ],
  ));
}

Future<ui.Image> _loadOverlayImage() async {
  final completer = Completer<ui.Image>();
  final bytedata = await rootBundle.load('assets/icons/iitg.png');

  ui.decodeImageFromList(bytedata.buffer.asUint8List(), completer.complete);
  return completer.future;
}

class _QRGeneratorState extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {
    String qrData;

    final qrFutureBuilder = FutureBuilder<ui.Image>(
        future: _loadOverlayImage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loadingDialog(context);
          }

          return CustomPaint(
            size: Size.square(280),
            painter: QrPainter(
              data: qrData,
              version: QrVersions.auto,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: MyColors.blueLighter,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: MyColors.blue,
              ),
              embeddedImage: snapshot.data,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size.square(60),
              ),
            ),
          );
        });
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      User currentUser = loginStore.firebaseUser;
      print(loginStore.userData);
      String userId = currentUser.uid;
      String email = currentUser.email;
      String name = loginStore.userData['displayName'];
      String degree = loginStore.userData['jobTitle'];
      String rollNumber = loginStore.userData['rollNumber'];
      DateTime now = DateTime.now();
      String date = now.year.toString() +
          now.month.toString() +
          now.day.toString() +
          "T" +
          now.hour.toString() +
          now.minute.toString() +
          now.second.toString();
      qrData = rollNumber + "," + date + "," + email + "," + userId;
      print(qrData);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    loginStore.signOut(context);
                  })
            ],
          ),
          backgroundColor: MyColors.backgroundColor,
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: qrFutureBuilder,
                  ),
                ),
              ),
              MyFonts().body(
                  name + "\n" + degree + "\n" + rollNumber, MyColors.black),
            ],
          ),
        ),
      );
    });
  }
}
