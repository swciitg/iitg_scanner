import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/pages/generateQR.dart';
import 'package:iitg_idcard_scanner/pages/scanQR.dart';
import 'package:iitg_idcard_scanner/pages/studentsList.dart';

class HomeManagement extends StatefulWidget {
  static String id = 'home-management';

  @override
  _HomeManagementState createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      QRGenerator(),
      ScanQR(),
      StudentsList(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColors.blueLighter,
        unselectedItemColor: MyColors.gray,
        selectedLabelStyle: TextStyle(fontFamily: 'poppins-semi'),
        unselectedLabelStyle: TextStyle(fontFamily: 'raleway'),
        iconSize: 30,
        backgroundColor: MyColors.white,
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.create), label: 'Generate Now'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'Scan Now'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "Student's List"),
        ],
      ),
    );
  }
}
