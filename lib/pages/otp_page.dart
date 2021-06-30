import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iitg_idcard_scanner/stores/otp_login_store.dart';
import 'package:iitg_idcard_scanner/widgets/loader_hud.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key key}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<otpLoginStore>(
      builder: (_, otploginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: otploginStore.isOtpLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: otploginStore.otpScaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigoAccent.withAlpha(20),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.indigo,
                      size: 16,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                brightness: Brightness.light,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                            'Enter 6 digits verification code sent to your number',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w500))),
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 500),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          otpNumberWidget(0),
                                          otpNumberWidget(1),
                                          otpNumberWidget(2),
                                          otpNumberWidget(3),
                                          otpNumberWidget(4),
                                          otpNumberWidget(5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: TextButton(
                                  onPressed: () async {
                                    otploginStore.validateOtpAndLogin(
                                        context, text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 2.0,
                                      primary: Colors.indigo,
                                      padding: EdgeInsets.all(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Next",
                                        style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                //  RaisedButton(
                                //   onPressed: () {
                                //     otploginStore.validateOtpAndLogin(
                                //         context, text);
                                //   },
                                //   color: Colors.indigo,
                                //   shape: const RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(14))),
                                //   child: Container(
                                //     padding: const EdgeInsets.symmetric(
                                //         vertical: 8, horizontal: 8),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: <Widget>[

                                //         Text(
                                //           'Confirm',
                                //           style: TextStyle(color: Colors.white),
                                //         ),
                                //         Container(
                                //           padding: const EdgeInsets.all(8),
                                //           decoration: BoxDecoration(
                                //             borderRadius:
                                //                 const BorderRadius.all(
                                //                     Radius.circular(20)),
                                //             color: Colors.lightBlue,
                                //           ),
                                //           child: Icon(
                                //             Icons.arrow_forward_ios,
                                //             color: Colors.white,
                                //             size: 16,
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ),
                              NumericKeyboard(
                                onKeyboardTap: _onKeyboardTap,
                                textColor: Colors.indigo,
                                rightIcon: Icon(
                                  Icons.backspace,
                                  color: Colors.indigoAccent,
                                ),
                                rightButtonFn: () {
                                  setState(() {
                                    text = text.substring(0, text.length - 1);
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
