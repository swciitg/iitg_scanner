import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitg_idcard_scanner/functions/checkRoll.dart';
import 'package:iitg_idcard_scanner/functions/checkRollElections.dart';
import 'package:iitg_idcard_scanner/functions/checkRollMess.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/pages/login_page.dart';
import 'package:iitg_idcard_scanner/pages/validateElections/approved.dart';
import 'package:iitg_idcard_scanner/pages/validateElections/rejected.dart';
import 'package:iitg_idcard_scanner/stores/otp_login_store.dart';
import 'package:provider/provider.dart';

//The number of minutes upto which the QR would be considered valid
int maxMinutes = 1;
final _firestore = FirebaseFirestore.instance;

class ScanQR extends StatefulWidget {
  static String id = 'scan-qr';
  @override
  _ScanQRState createState() => _ScanQRState();
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

class _ScanQRState extends State<ScanQR> {
  String qrScanRes = "";
  String rollNumber = "";
  String email = "";
  String hostel = "subansiri";
  bool scanResult = false;

  Future<String> scanQRNormal() async {
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#2568d8', "Cancel", true, ScanMode.QR);
    } on PlatformException {
      qrScanRes = 'Failed to get platform version.';
    }

    return qrScanRes;
  }

  // void checkPhoneFirebase(String phoneNumber) async {
  //   bool foundRoll = false;
  //   await for (var snapshot
  //       in _firestore.collection('mess_managers').snapshots()) {
  //     for (var phone in snapshot.docs) {
  //       print(phone.data());
  //       if (phoneNumber == phone.data()[0]) {
  //         print(phone.data());
  //         foundRoll = true;
  //         break;
  //       }
  //     }
  //   }

  //   if (foundRoll == false) {
  //     showDialog(context: context, builder: (BuildContext context) => ,)
  //     Navigator.pushNamed(context, LoginPage.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<otpLoginStore>(builder: (_, otpStore, __) {
      return SafeArea(
          child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //         icon: Icon(Icons.exit_to_app),
        //         onPressed: () {
        //           otpStore.signOut(context);
        //         })
        //   ],
        // ),
        backgroundColor: MyColors.backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyFonts().title1('Scan QR Code', Colors.indigoAccent),
                MySpaces.vGapInBetween,
                Center(
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image(
                        image: AssetImage('assets/icons/qr-scan.png'),
                        width: 125,
                        height: 180,
                      ),
                    ),
                  ),
                ),
                MySpaces.vMediumGapInBetween,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PREVIOUS SCAN DETAILS:",
                        style: GoogleFonts.rubik(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      // Expanded(
                      //   child: SizedBox(),
                      // ),
                      // Text(
                      //   email,
                      //   style: GoogleFonts.rubik(
                      //       fontSize: 20, fontWeight: FontWeight.w500),
                      // ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Row(
                      children: [
                        Text(
                          "Email-id: ",
                          style: GoogleFonts.rubik(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          child: Text(
                            scanResult ? email : "--❌--",
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 150),
                        ),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Row(
                      children: [
                        Text(
                          "Roll Number: ",
                          style: GoogleFonts.rubik(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          child: Text(
                            scanResult ? rollNumber : "--❌--",
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 150),
                        ),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Row(
                      children: [
                        Text(
                          "Hostel: ",
                          style: GoogleFonts.rubik(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          child: Text(
                            scanResult ? hostel : "--❌--",
                            style: GoogleFonts.rubik(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 150),
                        ),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              String _qrScanResult = await scanQRNormal();
                              setState(() {
                                qrScanRes = _qrScanResult;
                              });

                              rollNumber = qrScanRes?.split(",")[0];
                              //Here the string received from the QRCode is in
                              //the format :
                              // '200101038,20210531T010455,d.gunjan@iitg.ac.in,cwJIBDg5s3UGmWmY1i8LAfLYoin1'
                              //Note that the date string is formatted with a T separator
                              //between the date and time
                              String datewithT = qrScanRes?.split(",")[1];
                              email = qrScanRes?.split(",")[2];
                              String userId = qrScanRes?.split(",")[3];
                              DateTime timeScanned = DateTime.parse(datewithT);
                              Duration difference =
                                  DateTime.now().difference(timeScanned);
                              int minutes = difference.inMinutes;

                              if (minutes > maxMinutes ||
                                  !checkRoll(rollNumber)) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 100.0,
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: SimpleDialog(
                                            title: Text(
                                              "Wrong QR code",
                                              style: GoogleFonts.rubik(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                            children: <Widget>[
                                              SizedBox(
                                                height: 7.0,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Please regenerate!",
                                                    style: GoogleFonts.rubik(
                                                        color: Colors.indigo,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  RaisedButton(
                                                    // color: Colors.green,
                                                    // shape: RoundedRectangleBorder(
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(25.0),

                                                    color: Colors.indigo,
                                                    padding: EdgeInsets.all(20),
                                                    elevation: 2.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),

                                                    child: Text(
                                                      "OK",
                                                      style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        scanResult = false;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        //),
                                      );
                                    });
                              } else {
                                // Send to a Loader Widget temporarily

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        loadingDialog(context));
                                Map checkedResult =
                                    await checkRollMess(rollNumber, email);
                                if (checkedResult['isPresent']) {
                                  _firestore.collection('entries').add({
                                    "email": email,
                                    "time": timeScanned.toString(),
                                    "hostel": "subansiri"
                                  });
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Approved(
                                                rollNumber: rollNumber,
                                              )));
                                  setState(() {
                                    scanResult = true;
                                  });
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, Rejected.id);
                                  setState(() {
                                    scanResult=false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              padding: EdgeInsets.all(20),
                              elevation: 2.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Scan Now',
                                  style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          MySpaces.vMediumGapInBetween,
                          TextButton(
                            onPressed: () {
                              otpStore.signOut(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                padding: EdgeInsets.all(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Logout',
                                  style: GoogleFonts.rubik(
                                      color: MyColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     String _qrScanResult = await scanQRNormal();
                      //     setState(() {
                      //       qrScanRes = _qrScanResult;
                      //     });
                      //     String rollNumber = qrScanRes.split(",")[0];
                      //     //Here the string received from the QRCode is in
                      //     //the format :
                      //     // '200101038,20210531T010455,d.gunjan@iitg.ac.in,cwJIBDg5s3UGmWmY1i8LAfLYoin1'
                      //     //Note that the date string is formatted with a T separator
                      //     //between the date and time
                      //     String datewithT = qrScanRes.split(",")[1];
                      //     String email = qrScanRes.split(",")[2];
                      //     String userId = qrScanRes.split(",")[3];
                      //     DateTime timeScanned = DateTime.parse(datewithT);
                      //     Duration difference =
                      //         DateTime.now().difference(timeScanned);
                      //     int minutes = difference.inMinutes;

                      //     if (minutes > maxMinutes || !checkRoll(rollNumber)) {
                      //       final badReadSnackBar = SnackBar(
                      //           behavior: SnackBarBehavior.floating,
                      //           backgroundColor: MyColors.black,
                      //           content: MyFonts().body(
                      //               'Bad read! Please try again or re-generate the QR Code.',
                      //               MyColors.white));
                      //       ScaffoldMessenger.of(context)
                      //           .showSnackBar(badReadSnackBar);
                      //     } else {
                      //       // Send to a Loader Widget temporarily
                      //       showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) =>
                      //               loadingDialog(context));

                      //       if (await checkRollMess(rollNumber, email)) {
                      //         _firestore.collection('entries').add({
                      //           "email": email,
                      //           "time": timeScanned.toString(),
                      //           "hostel": "subansiri"
                      //         });
                      //         Navigator.pop(context);
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (BuildContext context) =>
                      //                     Approved(
                      //                       rollNumber: rollNumber,
                      //                     )));
                      //       } else
                      //         Navigator.pushNamed(context, Rejected.id);
                      //     }
                      //   },
                      //   child: MyFonts().heading1('Scan Now', MyColors.white),
                      //   style: ElevatedButton.styleFrom(
                      //       primary: MyColors.blueLighter,
                      //       padding: EdgeInsets.all(15)),
                      // ),
                    ),
                  ],
                ),
                MySpaces.vLargeGapInBetween,
                // MyFonts().heading1(qrScanRes, MyColors.black)
              ],
            ),
          ),
        ),
      ));
    });
  }
}
