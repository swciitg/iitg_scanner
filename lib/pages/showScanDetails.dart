import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';
import 'package:iitg_idcard_scanner/widgets/getRowDetails.dart';

// ignore: must_be_immutable
class ShowScanDetails extends StatefulWidget {
  static String id = 'show-scan-details';
  String rollNumber = '';

  ShowScanDetails({@required this.rollNumber});

  @override
  _ShowScanDetailsState createState() =>
      _ShowScanDetailsState(rollNumber: rollNumber);
}

class _ShowScanDetailsState extends State<ShowScanDetails> {
  String rollNumber = '';

  _ShowScanDetailsState({@required this.rollNumber});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Current Status')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else {
                    String currentStatus;
                    DateTime lastCheckoutTime = DateTime.now();
                    int len = (snapshot.data.docs.length);
                    bool exists = false;
                    for (int i = 0; i < len; i++) {
                      var v = snapshot.data.docs[i];
                      if (v.id == rollNumber) {
                        exists = true;
                        currentStatus = v.data()['currentStatus'];
                        if (v.data()['lastCheckoutTime'] != null)
                          lastCheckoutTime =
                              v.data()['lastCheckoutTime'].toDate();
                      }
                    }
                    if (!exists) {
                      currentStatus = 'In Campus';
                      final firestoreInstance = FirebaseFirestore.instance;
                      firestoreInstance
                          .collection('Past Timings')
                          .doc(rollNumber)
                          .set({'timings': []}, SetOptions(merge: true));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyFonts().largeTitle('Student details', MyColors.black),
                        MySpaces.vMediumGapInBetween,
                        getRowDetails('Roll number', rollNumber),
                        getRowDetails('Scan date',
                            DateTime.now().toString().split(' ')[0]),
                        getRowDetails(
                            'Scan time',
                            DateTime.now()
                                .toString()
                                .split(' ')[1]
                                .split('.')[0]),
                        getRowDetails('Current Status', currentStatus),
                        Visibility(
                          visible: currentStatus != 'In campus',
                          child: Column(
                            children: [
                              getRowDetails(
                                  'Last Checkout Time',
                                  lastCheckoutTime
                                      .toString()
                                      .split(' ')[1]
                                      .split('.')[0]),
                              Visibility(
                                visible: DateTime.now().difference(lastCheckoutTime).inHours>1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.warning, color:  MyColors.red,),
                                    MySpaces.hSmallestGapInBetween,
                                    MyFonts().heading1('You are late', MyColors.red),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        MySpaces.vLargeGapInBetween,
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (currentStatus == 'In campus') {
                                    final firestoreInstance =
                                        FirebaseFirestore.instance;
                                    firestoreInstance
                                        .collection('Current Status')
                                        .doc(rollNumber)
                                        .set({
                                      'currentStatus': 'Not In campus',
                                      'lastCheckoutTime': DateTime.now(),
                                    });
                                  } else {
                                    final firestoreInstance =
                                        FirebaseFirestore.instance;
                                    firestoreInstance
                                        .collection('Current Status')
                                        .doc(rollNumber)
                                        .set({
                                      'currentStatus': 'In campus',
                                    });
                                    firestoreInstance
                                        .collection('Past Timings')
                                        .doc(rollNumber)
                                        .update({
                                      'timings': FieldValue.arrayUnion([
                                        {
                                          'leave time': lastCheckoutTime,
                                          'entry time': DateTime.now()
                                        }
                                      ]),
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                                child: MyFonts().heading1(
                                    (currentStatus == 'In campus')
                                        ? 'Check out of campus'
                                        : 'Check into campus',
                                    MyColors.white),
                                style: ElevatedButton.styleFrom(
                                    primary: MyColors.blueLighter,
                                    padding: EdgeInsets.all(15)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
