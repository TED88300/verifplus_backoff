

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static late File file;
  static bool gIsIntroPass = false;
  static bool gIsRememberLogin = false;


  static Future<String> get _localPath async {

    Directory directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    else
    {
      directory = (await getExternalStorageDirectory())!;
    }

    return directory.path;
  }


  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/bichicapp.txt');
  }

  static initFLS()  async{
    print("initFLS");
    file = await _localFile;
    print("initFLS path ${file.path}");
    if (!file.existsSync())
      {
        print("!existsSync $file");
        SaveFLS();
      }
    print("$file");



  }


  static SaveFLS()  async{

    String toSave ="$gIsIntroPass,$gIsRememberLogin";

    print("$toSave");

    file.writeAsString(toSave);
  }

  static bool parseBool(String wbool) {
    return wbool.toLowerCase() == 'true';
  }

  static ReadFLS()  async{
    String toRead;
    toRead = await file.readAsString();
    List<String> Reads = toRead.split(",");

    gIsIntroPass = parseBool(Reads[0]);
    gIsRememberLogin = parseBool(Reads[0]);

    print("$Reads");


  }


  static setStrKey(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static getStrKey(String key, String defvalue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stringValue =  prefs.get(key);
    return stringValue ?? defvalue;
  }

  static setBoolKey(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static getBoolKey(String key, bool defvalue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var boolValue =  prefs.getBool(key);
    return boolValue ?? defvalue;
  }

  static setIntKey(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static getIntKey(String key, int defvalue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var intValue =  prefs.getInt(key);
    return intValue ?? defvalue;
  }


  static setStrLstKey(String key, List<String> listvalues) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, listvalues);
  }

  static getStrLstKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listvalues =  prefs.getStringList(key);

    return listvalues ?? ["", "","","","","","","","","","","","","","","","","","","",""];
  }






}