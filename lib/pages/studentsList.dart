import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iitg_idcard_scanner/globals/myColors.dart';
import 'package:iitg_idcard_scanner/globals/myFonts.dart';
import 'package:iitg_idcard_scanner/pages/pastTimings.dart';

class StudentsList extends StatefulWidget {
  static String id = 'students-list';

  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  List<String> _data = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey(); // backing data

  Widget _buildItem(String item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PastTimings(rollNumber: item)));
            },
            tileColor: MyColors.white,
            contentPadding: EdgeInsets.all(10),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MyFonts().heading1(item, MyColors.black),
            ),
            trailing: Icon(Icons.arrow_right),
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
                  .title1('Database of all students', MyColors.blueLighter),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Past Timings')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        var document = snapshot.data.docs[i];
                        _data.add(document.id);
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
