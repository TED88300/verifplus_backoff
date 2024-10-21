
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:verifplus_backoff/Tools/save_file_web.dart';

class Excel {


  static Future<void> CrtExcelPat(String filepath, ) async {
    final Workbook workbook = Workbook();

    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];

    // Assigning text to cells
    final Range range = sheet.getRangeByName('A1');
    range.setText('WorkBook Protected');

    final bool isProtectWindow = true;
    final bool isProtectContent = true;


    final List<int> bytes = workbook.saveAsStream();

    await FileSaveHelper.saveAndLaunchFile(bytes, filepath);

    try {
      workbook.dispose();
    } catch (e) {
    }

    return;
  }
}
