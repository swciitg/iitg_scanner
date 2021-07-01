import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/pages/homeManagement.dart';

class Rejected extends StatefulWidget {
  static String id = 'rejected-elections';

  @override
  createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  @override
  void initState() {
    super.initState();
  //  _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeManagement()),
        (Route<dynamic> route) => false);
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
                CupertinoIcons.xmark_seal_fill,
                color: Colors.red,
                size: 100,
              ),
              MySpaces.vSmallGapInBetween,
              MyFonts().largeTitle('Not allowed!', MyColors.gray)
            ],
          ),
        ),
      ),
    );
  }
}
