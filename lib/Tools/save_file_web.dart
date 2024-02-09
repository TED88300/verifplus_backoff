import 'dart:async';
import 'dart:convert';
import 'dart:html';


class FileSaveHelper {
  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    AnchorElement(
        href:
        'data:application/octet-stream;charset=UTF-8;base64,${base64.encode(bytes)}')
      ..setAttribute('download', fileName)
      ..click();
  }
}