import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iitg_idcard_scanner/stores/login_store.dart';

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
                    'Sign In!',
                    style: GoogleFonts.poppins(
                        color: Colors.blueAccent,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Image(
                  image: AssetImage("assets/icons/iitg.png"),
                ),
                Spacer(),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          loginStore.signInWithMicrosoft(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white70,
                            padding: EdgeInsets.all(25),
                            elevation: 5),
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
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
