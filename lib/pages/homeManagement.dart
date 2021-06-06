import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
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
            bottomNavigationBar: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Row(
                      children: [
                        Text("Generate now"),
                        Icon(
                          Icons.create,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  MySpaces.hMediumGapInBetween,
                  SafeArea(
                    child: TextButton(
                        onPressed: () {
                          loginStore.signOut(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Log Out    ",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            Icon(
                              logout,
                              size: 30,
                              color: Colors.red,
                            )
                          ],
                        )),
                  )
                ],
              ),
            )),
      );
    });
  }
}
