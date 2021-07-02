import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/pages/generateQR.dart';
import 'package:iitg_idcard_scanner/pages/scanQR.dart';
import 'package:iitg_idcard_scanner/stores/login_store.dart';
import 'package:provider/provider.dart';

class HomeManagement extends StatefulWidget {
  static String id = 'home-management';

  @override
  _HomeManagementState createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  int _selectedIndex = 0;
  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      QRGenerator(),
    ];
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return SafeArea(
        child: Scaffold(
            body: pages[_selectedIndex],
           /* bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2.0,
                        primary: Colors.indigo,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Generate now",
                            style: GoogleFonts.rubik(
                                color: MyColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.refresh,
                            size: 30,
                            color: MyColors.white,
                          ),
                        ],
                      ),
                    ),
                    MySpaces.hMediumGapInBetween,
                    TextButton(
                      onPressed: () {
                        loginStore.signOut(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2.0,
                        primary: Colors.redAccent,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Log Out",
                            style: GoogleFonts.rubik(
                                color: MyColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.cancel,
                            size: 30,
                            color: MyColors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )*/
        ),
      );
    });
  }
}
