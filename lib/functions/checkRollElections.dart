import 'package:gsheets_get/gsheets_get.dart';

Future<bool> checkRollElections(String roll) async {
  final GSheetsGet sheet = GSheetsGet(
      sheetId: "1o93Avp3qsbKVo-tmCKQqlquxtHhOJcE18HEzkbE-W0M",
      page: 1,
      skipRows: 0);

  GSheetsResult result = await sheet.getSheet();
  List<String> allowedRollList = [];
  result.sheet.rows.forEach((row) {
    StringBuffer buffer = new StringBuffer();
    if (row != null) {
      row.cells.forEach((cell) {
        buffer.write(cell?.text.toString() + "|");
      });
    }
    allowedRollList.add(buffer.toString().split('|')[2]);
  });

  print(allowedRollList);
  if (allowedRollList.contains(roll)) return true;
  return false;
}
