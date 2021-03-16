import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:iitg_idcard_scanner/functions/checkRoll.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/pages/showScanDetails.dart';

class ScanNow extends StatefulWidget {
  static String id = 'scan-now';

  @override
  _ScanNowState createState() => _ScanNowState();
}

class _ScanNowState extends State<ScanNow> {
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#2568d8', "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    return barcodeScanRes;
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
              MyFonts().title1('Scan your IITG ID-Card', MyColors.blueLighter),
              MySpaces.vGapInBetween,
              Center(
                child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image(
                        image: AssetImage('assets/icons/barcode.png'),
                        width: 250,
                        height: 360,
                      ),
                    )),
              ),
              MySpaces.vLargeGapInBetween,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String rollNumber = await scanBarcodeNormal();
                        if (!checkRoll(rollNumber)) {
                          final badReadSnackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: MyColors.black,
                              content: MyFonts().body(
                                  'Bad read! Please try again',
                                  MyColors.white));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(badReadSnackBar);
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowScanDetails(
                                        rollNumber: rollNumber,
                                      )));
                      },
                      child: MyFonts().heading1('Scan Now', MyColors.white),
                      style: ElevatedButton.styleFrom(
                          primary: MyColors.blueLighter,
                          padding: EdgeInsets.all(15)),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
