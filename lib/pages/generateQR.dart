import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
                color: Colors.indigoAccent,
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
      String month = now.month.toString().length == 1
          ? "0" + now.month.toString()
          : now.month.toString();
      String day = now.day.toString().length == 1
          ? "0" + now.day.toString()
          : now.day.toString();
      String second = now.second.toString().length == 1
          ? "0" + now.second.toString()
          : now.second.toString();
      String hour = now.hour.toString().length == 1
          ? "0" + now.hour.toString()
          : now.hour.toString();
      String minute = now.minute.toString().length == 1
          ? "0" + now.minute.toString()
          : now.minute.toString();
      String date =
          now.year.toString() + month + day + "T" + hour + minute + second;
      qrData = rollNumber + "," + date + "," + email + "," + userId;
      print("here");
      print(DateTime.now());
      print(qrData);
      return SafeArea(
        child: Scaffold(
          backgroundColor: MyColors.backgroundColor,
          body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Row(
                        children: [
                          Text(
                            "Name: ",
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Container(
                            child: Text(
                              name,
                              style: GoogleFonts.rubik(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 130),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Row(
                        children: [
                          Text(
                            "Roll Number: ",
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Text(
                            rollNumber,
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Row(
                        children: [
                          Text(
                            "Course: ",
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Text(
                            degree,
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40 > 280
                          ? 280
                          : MediaQuery.of(context).size.width - 40,
                      child: qrFutureBuilder,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2.0,
                          primary: Colors.indigo,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 30,
                              color: MyColors.white,
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              "Generate Now",
                              style: GoogleFonts.rubik(
                                  color: MyColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: TextButton(
                        onPressed: () {
                          loginStore.signOut(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2.0,
                          primary: Colors.redAccent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 30,
                              color: MyColors.white,
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              "Log Out",
                              style: GoogleFonts.rubik(
                                  color: MyColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    });
  }
}
