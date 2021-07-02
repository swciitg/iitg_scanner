import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/pages/showScanDetails.dart';

class Approved extends StatefulWidget {
  static String id = 'approved-elections';

  final String rollNumber;

  Approved({@required this.rollNumber});

  @override
  createState() => _ApprovedState(rollNumber: rollNumber);
}

class _ApprovedState extends State<Approved> {
  String rollNumber;
  _ApprovedState({@required this.rollNumber});

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                color: Colors.green,
                size: 100,
              ),
              MySpaces.vSmallGapInBetween,
              MyFonts().largeTitle('Allowed', MyColors.gray)
            ],
          ),
        ),
      ),
    );
  }
}
