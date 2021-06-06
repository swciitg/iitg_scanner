import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:provider/provider.dart';
import 'package:iitg_idcard_scanner/stores/login_store.dart';
import 'package:iitg_idcard_scanner/pages/otp_page.dart';
import 'package:iitg_idcard_scanner/stores/otp_login_store.dart';
import 'package:iitg_idcard_scanner/pages/login_page.dart';

class MicrosoftLogin extends StatefulWidget {
  static String id = 'google-login';
  @override
  _MicrosoftLoginState createState() => _MicrosoftLoginState();
}

class _MicrosoftLoginState extends State<MicrosoftLogin> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Scaffold(
          backgroundColor: Color(0xFFF8F8F8),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Log In',
                    style: GoogleFonts.poppins(
                        color: Colors.indigo,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                ),
                Image(
                  image: AssetImage("assets/icons/iitg.png"),
                  height: 300,
                ),
                MySpaces.vMediumGapInBetween,
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          loginStore.signInWithMicrosoft(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: MyColors.blueLighter,
                            padding: EdgeInsets.all(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: NetworkImage(
                                  'https://image.flaticon.com/icons/png/512/732/732221.png'),
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Login with Microsoft',
                              style: GoogleFonts.rubik(
                                  color: MyColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      MySpaces.vMediumGapInBetween,
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('login_page');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: MyColors.blueLighter,
                            padding: EdgeInsets.all(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/icons/otp.png'),
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Login with OTP',
                              style: GoogleFonts.rubik(
                                  color: MyColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
