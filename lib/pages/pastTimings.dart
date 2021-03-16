import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/globals/mySpaces.dart';

class PastTimings extends StatefulWidget {
  static String id = 'past-timings';

  String rollNumber;
  PastTimings({@required this.rollNumber});


  @override
  _PastTimingsState createState() => _PastTimingsState(rollNumber: rollNumber);
}

class _PastTimingsState extends State<PastTimings> {
  String rollNumber;
  _PastTimingsState({@required this.rollNumber});

  List<dynamic> _data = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey(); // backing data

  Widget _buildItem(var item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Column(
        children: [
          ListTile(
            tileColor: MyColors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyFonts().heading1('Exit Time: ', MyColors.blue),
                    MyFonts().heading2(item['leave time'].toDate().toString(), MyColors.gray)
                  ],
                ),
                MySpaces.vSmallestGapInBetween,
                Row(
                  children: [
                    MyFonts().heading1('Entry Time: ', MyColors.blue),
                    MyFonts().heading2(item['entry time'].toDate().toString(), MyColors.gray)
                  ],
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              MyFonts()
                  .title1('Timing details of $rollNumber', MyColors.blueLighter),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Past Timings').doc(rollNumber)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data.data()['timings'].length; i++) {
                        var document = snapshot.data.data()['timings'];
                        _data.add(document[i]);
                      }

                      return Container(
                        padding: EdgeInsets.only(top: 50),
                        child: AnimatedList(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          key: _listKey,
                          initialItemCount: _data.length,
                          itemBuilder: (context, index, animation) {
                            if (index < _data.length)
                              return _buildItem(_data[index], animation, index);
                            else
                              return Container();
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
