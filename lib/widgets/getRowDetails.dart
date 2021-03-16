import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';

Widget getRowDetails(String param, String val){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyFonts().heading1(param, MyColors.blueLighter),
          Flexible(child: MyFonts().heading1(val, MyColors.gray)),
        ],
      ),
      Divider(),
      MySpaces.vGapInBetween,
    ],
  );
}