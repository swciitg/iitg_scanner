import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/pages/validateElections/approved.dart';
import 'package:iitg_idcard_scanner/pages/validateElections/rejected.dart';

//The number of minutes upto which the QR would be considered valid
int maxMinutes = 5;

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
                        // '200101038,20210531T010455'
                        //Note that the date string is formatted with a T separator
                        //between the date and time
                        String datewithT = qrScanRes.split(",")[1];
                        DateTime timeScanned = DateTime.parse(datewithT);
                        Duration difference =
                            DateTime.now().difference(timeScanned);
                        int minutes = difference.inMinutes;

                        if (minutes > maxMinutes) {
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

                          //TODO: Implement roll number check from database
                          int flag = 1;
                          if (flag == 1) {
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
