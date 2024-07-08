import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js' as js;
import 'dart:html' as html;

class FileSaveHelper {
  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    AnchorElement(
        href:
        'data:application/octet-stream;charset=UTF-8;base64,${base64.encode(bytes)}')
      ..setAttribute('download', fileName)
      ..click();
  }

  static Future<void> saveAsFile(List<int> bytes, String fileName) async {


    final text = 'this is the text file';
    final bytes = utf8.encode(text);

    final script = html.document.createElement('script') as html.ScriptElement;
    script.src = "http://cdn.jsdelivr.net/g/filesaver.js";

    html.document.body?.nodes.add(script);

// calls the "saveAs" method from the FileSaver.js libray
    js.context.callMethod("saveAs", [
      html.Blob([bytes]),
      fileName,            //File Name (optional) defaults to "download"
      "text/plain;charset=utf-8" //File Type (optional)
    ]);

    // cleanup
    html.document.body?.nodes.remove(script);

  }

}