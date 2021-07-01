import 'package:gsheets_get/gsheets_get.dart';

Future<Map<dynamic, dynamic>> checkRollMess(String roll, String email) async {
  final GSheetsGet sheet = GSheetsGet(
      sheetId: "1-nE8Cb_p3pcFGr4osgTjq26UZdm0NLRUqcM4Yxfv2oM",
      page: 1,
      skipRows: 1);

  GSheetsResult result = await sheet.getSheet();
  List<String> allowedRollList = [];
  List<String> allowedEmailList = [];
  result.sheet.rows.forEach((row) {
    StringBuffer buffer = new StringBuffer();

    if (row != null) {
      row.cells.forEach((cell) {
        buffer.write(cell?.text.toString() + "|");
      });
    }
    allowedRollList.add(buffer.toString().split("|")[3]);
    allowedEmailList.add(buffer.toString().split("|")[4]);
  });

  print(allowedRollList);
  print(allowedEmailList);
  Map map = {'isPresent': true, 'roll': roll};
  if (allowedEmailList.contains(email)) {
    //update the roll number from the GSheet incase the Azure API didn't return the roll for this user.
    String rollNew = allowedRollList[allowedEmailList.indexOf(email)];
    if (rollNew != "null") {
      print('*******New Roll Number: ' + rollNew + '******');
      map['roll'] = rollNew;
    }
    return map;
  } else if (allowedRollList.contains(roll)) {
    return map;
  } else {
    map['isPresent'] = false;
    return map;
  }
}
