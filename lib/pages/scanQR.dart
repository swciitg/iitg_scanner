import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
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
int maxMinutes = 5;
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
    return SafeArea(
        child: Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyFonts().title1('Scan QR Code', MyColors.blueLighter),
              MySpaces.vGapInBetween,
              Center(
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image(
                      image: AssetImage('assets/icons/qr-scan.png'),
                      width: 250,
                      height: 360,
                    ),
                  ),
                ),
              ),
              MySpaces.vLargeGapInBetween,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String _qrScanResult = await scanQRNormal();
                        setState(() {
                          qrScanRes = _qrScanResult;
                        });
                        String rollNumber = qrScanRes.split(",")[0];
                        //Here the string received from the QRCode is in
                        //the format :
                        // '200101038,20210531T010455,d.gunjan@iitg.ac.in,cwJIBDg5s3UGmWmY1i8LAfLYoin1'
                        //Note that the date string is formatted with a T separator
                        //between the date and time
                        String datewithT = qrScanRes.split(",")[1];
                        String email = qrScanRes.split(",")[2];
                        String userId = qrScanRes.split(",")[3];
                        DateTime timeScanned = DateTime.parse(datewithT);
                        Duration difference =
                            DateTime.now().difference(timeScanned);
                        int minutes = difference.inMinutes;

                        if (minutes > maxMinutes || !checkRoll(rollNumber)) {
                          final badReadSnackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: MyColors.black,
                              content: MyFonts().body(
                                  'Bad read! Please try again or re-generate the QR Code.',
                                  MyColors.white));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(badReadSnackBar);
                        } else {
                          // Send to a Loader Widget temporarily
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  loadingDialog(context));

                          if (await checkRollMess(rollNumber, email)) {
                            _firestore.collection('entries').add({
                              "email": email,
                              "time": timeScanned.toString(),
                              "hostel": "subansiri"
                            });
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Approved(
                                          rollNumber: rollNumber,
                                        )));
                          } else
                            Navigator.pushNamed(context, Rejected.id);
                        }
                      },
                      child: MyFonts().heading1('Scan Now', MyColors.white),
                      style: ElevatedButton.styleFrom(
                          primary: MyColors.blueLighter,
                          padding: EdgeInsets.all(15)),
                    ),
                  ),
                ],
              ),
              MySpaces.vLargeGapInBetween,
              MyFonts().heading1(qrScanRes, MyColors.black)
            ],
          ),
        ),
      ),
    ));
  }
}
