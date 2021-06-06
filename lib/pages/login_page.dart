import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:iitg_idcard_scanner/stores/otp_login_store.dart';
import 'package:iitg_idcard_scanner/widgets/loader_hud.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  static String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<otpLoginStore>(
      builder: (_, otploginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: otploginStore.isLoginLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: otploginStore.loginScaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text('Enter Your Phone Number',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800))),
                                    Container(
                                      height: 50,
                                    ),
                                    Center(
                                      child: Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 350),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Image.asset(
                                              'assets/icons/iitg.png')),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: 'We will send you an ',
                                          style: TextStyle(color: Colors.blue)),
                                      TextSpan(
                                          text: 'One Time Password ',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: 'on this mobile number',
                                          style: TextStyle(color: Colors.blue)),
                                    ]),
                                  )),
                              Container(
                                height: 40,
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: CupertinoTextField(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4))),
                                  controller: phoneController,
                                  clearButtonMode:
                                      OverlayVisibilityMode.editing,
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  placeholder: '+919876543210',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: RaisedButton(
                                  onPressed: () {
                                    if (phoneController.text.isNotEmpty) {
                                      print(
                                          "\n\n\n\nGoing to login store\n\n\n\n");
                                      otploginStore.getCodeWithPhoneNumber(
                                          context,
                                          phoneController.text.toString());
                                    } else {
                                      otploginStore
                                          .loginScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'Please enter a phone number',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ));
                                    }
                                  },
                                  color: Colors.blue,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14))),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Next',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: Colors.lightBlue,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
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
