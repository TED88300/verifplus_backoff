import 'dart:html' as htmlfile;
import 'platform_file_picker.dart';

PlatformFilePicker createPickerObject() => WebFilePicker();

class WebFilePicker implements PlatformFilePicker {
  @override
  String getFileName(file) {
    return file.file.name;
  }

  @override
  void startWebFilePicker(pickerCallBack) {
    print("startWebFilePicker");

    htmlfile.FileUploadInputElement uploadInput = htmlfile.FileUploadInputElement();
    uploadInput.accept = '.pdf,.png,.jpg,.webp';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      //just checking for single file here you can for multiple files
      if (files!.length == 1) {
        final htmlfile.File file = files[0];
        final reader = htmlfile.FileReader();

        reader.onLoadEnd.listen((event) {
          String wTmp = reader.result.toString();
          print("wTmp1");

          wTmp = wTmp.replaceAll("[", "");
          wTmp = wTmp.replaceAll("]", "");
          print("wTmp2");

          List<String> wTmpSplitf = wTmp.split(",");
          print("wTmpSplitf");

          List<int> wTmpSplitINT = wTmpSplitf.map((data) => int.parse(data)).toList();
          pickerCallBack([FlutterWebFile(file, wTmpSplitINT)]);
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  //***************

  @override
  void startWebDocPicker(pickerCallBack) {
    print("startWebFilePicker");

    htmlfile.FileUploadInputElement uploadInput = htmlfile.FileUploadInputElement();
    uploadInput.accept = '.pdf,.png,.jpg,.webp';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      //just checking for single file here you can for multiple files
      if (files!.length == 1) {
        final htmlfile.File file = files[0];
        final reader = htmlfile.FileReader();

        reader.onLoadEnd.listen((event) {
          String wTmp = reader.result.toString();
          print("wTmp1");

          wTmp = wTmp.replaceAll("[", "");
          wTmp = wTmp.replaceAll("]", "");
          print("wTmp2");

          List<String> wTmpSplitf = wTmp.split(",");
          print("wTmpSplitf");

          List<int> wTmpSplitINT = wTmpSplitf.map((data) => int.parse(data)).toList();
          pickerCallBack([FlutterWebFile(file, wTmpSplitINT)]);
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  //***************

  @override
  Future startWebCsvPicker(pickerCallBack) async {
    print("startWebFilePicker A");

    htmlfile.FileUploadInputElement uploadInput =  htmlfile.FileUploadInputElement();
    uploadInput.accept = '.csv';
    uploadInput.click();

    print("startWebFilePicker B");


    await uploadInput.onChange.listen(     (e)  {
      final files = uploadInput.files;
      if (files!.length == 1) {
        final htmlfile.File file = files[0];
        final reader = htmlfile.FileReader();

         reader.onLoadEnd.listen((event) {
          String wTmp = reader.result.toString();
          print("wTmp1");

          wTmp = wTmp.replaceAll("[", "");
          wTmp = wTmp.replaceAll("]", "");
          print("wTmp2");

          List<String> wTmpSplitf = wTmp.split(",");
          print("wTmpSplitf");

          List<int> wTmpSplitINT = wTmpSplitf.map((data) => int.parse(data)).toList();
          pickerCallBack([FlutterWebFile(file, wTmpSplitINT)]);
        });
        reader.readAsArrayBuffer(file);
      }
    });

    print("startWebFilePicker Fin");

  }
}

class FlutterWebFile {
  htmlfile.File file;
  List<int> fileBytes;

  FlutterWebFile(this.file, this.fileBytes);
}
