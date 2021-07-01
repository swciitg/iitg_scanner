import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iitg_idcard_scanner/functions/checkRoll.dart';
import 'package:iitg_idcard_scanner/functions/checkRollMess.dart';
import 'package:iitg_idcard_scanner/pages/generateQR.dart';
import 'package:iitg_idcard_scanner/pages/login_page.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:iitg_idcard_scanner/pages/microsoft.dart';
import 'package:iitg_idcard_scanner/pages/homeManagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static Config config = Config(
      tenant: '850aa78d-94e1-4bc6-9cf3-8c11b530701c',
      clientId: '56c7200f-8aea-42e8-960a-0d4d23c258c8',
      redirectUri: 'https://login.live.com/oauth20_desktop.srf',
      scope: 'user.read openid profile offline_access');
  final AadOAuth oauth = AadOAuth(config);

  @observable
  User firebaseUser;

  @observable
  Map<String, String> userData;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (firebaseUser.phoneNumber != null && firebaseUser.phoneNumber != "") return false;
      final prefs = await SharedPreferences.getInstance();
      print("Got Here");
      userData = {};
      userData.addAll({
        'displayName': prefs.getString('displayName') ?? '0',
        'jobTitle': prefs.getString('jobTitle') ?? '0',
        'rollNumber': prefs.getString('rollNumber') ?? '0',
      });
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<void> signInWithMicrosoft(BuildContext context) async {
    oauth.setWebViewScreenSize(Rect.fromLTWH(
        0,
        25,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - 25));
    try{
      await oauth.login();
    }catch(exception){
      Fluttertoast.showToast(msg: "Something went wrong!");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => MicrosoftLogin()),
              (Route<dynamic> route) => false);
    }
    String accessToken = await oauth.getAccessToken();
    if (accessToken != null) {
      var response = await http.get('https://graph.microsoft.com/v1.0/me',
          headers: {HttpHeaders.authorizationHeader: accessToken});
      print(response.statusCode);
      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: "Something went wrong!");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MicrosoftLogin()),
            (Route<dynamic> route) => false);
        return;
      }
      var data = jsonDecode(response.body);
      print(data);
      print("data was printed");
      //check and compare mail and roll number in google sheet and assign hostel to shared prefs
      Map checkedResult = await checkRollMess(data['surname'], data['mail']);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('displayName', data['displayName']);
      prefs.setString('jobTitle', data['jobTitle']);
      prefs.setString('rollNumber', checkedResult['roll']);
      print("\n\n\n\nSetting data complete\n\n\n\n");
      final _auth = FirebaseAuth.instance;

      await _auth
          .createUserWithEmailAndPassword(
              email: data['mail'], password: '123456')
          .then((UserCredential value) => {
                // send home
                print('Authentication successful'),
                onAuthenticationSuccessful(context, value, data),
              })
          .catchError((err) {
        print(err);
        _auth
            .signInWithEmailAndPassword(email: data['mail'], password: '123456')
            .then((UserCredential value) {
          print('Authentication successful');
          onAuthenticationSuccessful(context, value, data);
        }).catchError((err) {
          print(err);
          Fluttertoast.showToast(
              msg: "Could not authenticate please try later");
          //show an error toast
        });
      });
    } else
      print('Something is wrong!');
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, UserCredential result, var data) async {
    firebaseUser = result.user;
    final prefs = await SharedPreferences.getInstance();
    userData = {};
    userData.addAll({
      'displayName': prefs.getString('displayName') ?? '0',
      'jobTitle': prefs.getString('jobTitle') ?? '0',
      'rollNumber': prefs.getString('rollNumber') ?? '0',
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeManagement()),
        (Route<dynamic> route) => false);
  }

  @action
  Future<void> signOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await _auth.signOut().then((value) async {
      oauth.logout();
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => MicrosoftLogin()),
          (Route<dynamic> route) => false);
      firebaseUser = null;
      userData = null;
    });
  }
}
