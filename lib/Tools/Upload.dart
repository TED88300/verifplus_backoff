import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/stub_file_picking/platform_file_picker.dart';
import 'package:verifplus_backoff/stub_file_picking/web_file_picker.dart';
import 'package:image/image.dart' as IMG;

class Upload {

  static Future<void> UploadFilePicker(String imagepath, VoidCallback onSetState) async {
    print("UploadFilePicker $imagepath");

    String wImgPath = DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    PlatformFilePicker().startWebFilePicker((files) async {
      DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      List<int> stream = file.fileBytes;
      Uint8List bytes = Uint8List.fromList(stream);
      IMG.Image? img = await IMG.decodeImage(bytes);
      IMG.Image resized = await IMG.copyResize(img!, width: 940, maintainAspect: true);
      List<int> stream2 = await IMG.encodeJpg(resized);

      String wPath = DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': DbTools.SrvToken,
        'zasq': 'uploadphoto',
        'imagepath': imagepath,
      });
      print("stream ${stream.length} stream2 ${stream2.length} " );
      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream2, filename: basename("xxx.jpg"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("value " + value);
        print("Fin");

        DbTools.notif.BroadCast();
        onSetState();
      });
    });
  }

  static Future<void> UploadDocPicker(String imagepath, VoidCallback onSetState) async {
    print("UploadDocPicker $imagepath");

    String wImgPath = DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    PlatformFilePicker().startWebDocPicker((files) async {
      DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      var stream = file.fileBytes;
      String wPath = DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': DbTools.SrvToken,
        'zasq': 'uploadphoto',
        'imagepath': imagepath,
      });

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.jpg"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("value " + value);
        print("Fin");

        DbTools.notif.BroadCast();
        onSetState();
      });
    });
  }

  static Future<void> UploadCsvPicker(String tableName, VoidCallback onSetStateOn, VoidCallback onSetStateOff) async {
    print("UploadSrvCsvPicker >>>>>>");


    String imagepath = tableName + ".csv";
    await PlatformFilePicker().startWebCsvPicker((files) async {
      onSetStateOn();

      print("uploadcsv ${files.length}");


      });








    print("UploadSrvCsvPicker <<<<<<");


  }












  static Future<void> UploadSrvCsvPickerNF74(String tableName, VoidCallback onSetStateOn, VoidCallback onSetStateOff) async {
    print("UploadSrvCsvPicker >>>>>>");


    String imagepath = tableName + ".csv";
    await PlatformFilePicker().startWebCsvPicker((files) async {
      onSetStateOn();

      print("uploadcsv");

      DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      var stream = file.fileBytes;

      String wPath = DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': DbTools.SrvToken,
        'zasq': 'uploadcsv',
        'imagepath': imagepath,
      });

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.csv"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) async{
        print("uploadcsv OK " + value);
        print("importcsv");

        var request2 = new http.MultipartRequest("POST", uri);
        request2.fields.addAll({
          'tic12z': DbTools.SrvToken,
          'zasq': 'importcsvNF74',
          'tableName': tableName,
        });

        print("importcsv A ${request2.fields}");
        http.StreamedResponse response2 = await request2.send();
        print("importcsv B ${response2.statusCode}");

        if (response2.statusCode == 200) {
          response2.stream.transform(utf8.decoder).listen((value) async{
            print("importcsv OK " + value);
          });
        } else {
          print("importcsv error  ${response2.statusCode}");
        }
        onSetStateOff();


      });

//      onSetStateOff();



    });

    print("UploadSrvCsvPicker <<<<<<");


  }


  static Future<void> UploadSrvCsvPicker(String tableName, VoidCallback onSetStateOn, VoidCallback onSetStateOff) async {
    print("UploadSrvCsvPicker >>>>>>");


    String imagepath = tableName + ".csv";
    await PlatformFilePicker().startWebCsvPicker((files) async {
      onSetStateOn();

      print("uploadcsv");

      DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      var stream = file.fileBytes;

      String wPath = DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': DbTools.SrvToken,
        'zasq': 'uploadcsv',
        'imagepath': imagepath,
      });

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.csv"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) async{
        print("uploadcsv OK " + value);

        print("importcsv");

        var request2 = new http.MultipartRequest("POST", uri);
        request2.fields.addAll({
          'tic12z': DbTools.SrvToken,
          'zasq': 'importcsv',
          'tableName': tableName,
        });

        print("importcsv A ${request2.fields}");
        http.StreamedResponse response2 = await request2.send();
        print("importcsv B ${response2.statusCode}");

        if (response2.statusCode == 200) {
          response2.stream.transform(utf8.decoder).listen((value) async{
            print("importcsv OK " + value);
          });
        } else {
          print("importcsv error  ${response2.statusCode}");
        }


        onSetStateOff();


      });

//      onSetStateOff();



    });

    print("UploadSrvCsvPicker <<<<<<");


  }



  static Future<void> UploadCSVPicker(String wTable, VoidCallback onSetState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      print("file CSV " + file.name);

      final formater = String.fromCharCodes(file.bytes!);

      if (wTable.compareTo("Gammes") == 0) {
        DbTools.ListNF074_Gammes.clear();

        final Lines = formater.split('\r\n');
        for (int i = 1; i < Lines.length - 1; i++) {
          final LinesData = Lines[i].split(';');
          DbTools.ListNF074_Gammes.add(NF074_Gammes(
            0,
            LinesData[0],
            LinesData[1],
            LinesData[2],
            LinesData[3],
            LinesData[4],
            LinesData[5],
            LinesData[6],
            LinesData[7],
            LinesData[8],
            LinesData[9],
            LinesData[10],
            LinesData[11],
            LinesData[12],
            LinesData[13],
          ));
        }
      }
      onSetState();

    }
  }



/*
wImage.length 100421
Deb
wInterMission 13 DbTools.gInterMission 13
200
SaveFile Intervention_130_13_4.jpg
value {"success":1,"name":"Intervention_130_13_3.jpg","uploadfilename":"\/tmp\/phpOcKOF0","is_uploaded_file":"OK","size":100421,"werror":"Move  OK = '1'"}

* */

  static Future<void> SaveFile(String imagepath, Uint8List wImage) async {
    print("SaveFile $imagepath");

    String wImgPath = DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    print("wImage.length ${wImage.length}");


    DbTools.setSrvToken();
    print("Deb");
    var stream = wImage;
    String wPath = DbTools.SrvUrl;
    var uri = Uri.parse(wPath.toString());
    var request = new http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'tic12z': DbTools.SrvToken,
      'zasq': 'uploadphoto',
      'imagepath': imagepath,
    });

    var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.jpg"));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print("value " + value);
      print("Fin");


    });

  }



  static Future<void> SaveDoc(String imagepath, Uint8List wImage) async {
    print("SaveFile $imagepath");

    String wImgPath = DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    print("wImage.length ${wImage.length}");


    DbTools.setSrvToken();
    print("Deb");
    var stream = wImage;
    String wPath = DbTools.SrvUrl;
    var uri = Uri.parse(wPath.toString());
    var request = new http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'tic12z': DbTools.SrvToken,
      'zasq': 'uploaddoc',
      'imagepath': imagepath,
    });

    var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.jpg"));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print("value " + value);
      print("Fin");


    });

  }




}
