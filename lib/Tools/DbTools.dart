import "dart:async";
import 'dart:convert';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';
import 'package:verifplus_backoff/Tools/Srv_Adresses.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Link_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_Niveau_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_Niveau_Hab.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Gamme.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Hab.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Ent.dart';
import 'package:verifplus_backoff/Tools/Srv_Planning.dart';
import 'package:verifplus_backoff/Tools/Srv_Planning_Interv.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/Tools/Srv_User_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_User_Hab.dart';
import 'package:verifplus_backoff/Tools/Srv_Zones.dart';
import 'package:verifplus_backoff/Tools/save_file_web.dart';
import 'package:verifplus_backoff/Tools/shared_pref.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

enum RdvType { changedOccurrence, normal, occurrence, pattern }

class Notif with ChangeNotifier {
  Notif();
  void BroadCast() {
    print("&&&&&&&&&&&&&&&&&&&& Notif BroadCast");
    notifyListeners();
  }
}

class DbTools {
  DbTools();
  static var gVersion = "v1.0.82";
  static bool gTED = true;

  static var notif = Notif();
  static bool EdtTicket = false;

  static bool gIsIntroPass = false;
  static bool gIsRememberLogin = true;
  static int gCurrentIndex = 0;
  static var database;

  static String gViewAdr = "";
  static String gViewCtact = "";

  static var gUsername = "";
  static var gPassword = "";
  static var gUser_AuthID = "";
  static var gUser_DateCrt = "";
  static String? gImagePath;
  static Image? gimage;
  static var gUserId = 0;

  static String OrgLib = "";
  static String ParamTypeOg = "";

  static bool gDemndeReload = false;

  static List<String> List_TypeInter = [];
  static List<String> List_TypeInterID = [];
  static List<String> List_ParcTypeInter = [];
  static List<String> List_ParcTypeInterID = [];
  static List<String> List_StatusInter = [];
  static List<String> List_StatusInterID = [];
  static List<String> List_FactInter = [];
  static List<String> List_FactInterID = [];
  static List<String> List_UserInter = [];
  static List<String> List_UserInterID = [];

  static PackageInfo packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  static Future<bool> ApiSrv_User_Info(String id, String password) async {
    return (password.isNotEmpty);
  }

  static Future<bool> ApiSrv_Login(String aUtilisateur, String aMotdepasse) async {
    return true;
  }

  static Future<bool> ApiSrv_User_setNotification_Token(String id, String password, String token) async {
    return true;
  }

  static int gLastID = 0;
  static int gLastIDObj = 0;
/*
  static String Url = "217.160.250.97";
  static String SrvUrl = "http://$Url/API_VERIFPLUS.php";
  static String SrvImg = "http://$Url/Img/";
*/

  static String Url = "verifplus.net";
  static String SrvUrl = "https://$Url/API_VERIFPLUS.php";
  static String SrvImg = "http://217.160.250.97/Img/";
  static String SrvCsv = "http://217.160.250.97/CSV/";

  static String SrvTokenKey = "WqXs35Xs";
  static String SrvToken = "";
  static String Token_FBM = "";
  static String wImgPathAvatar = "";
  static String simCountryCode = "";

  static Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  static Future<bool> Login(String user, String pw, String userAuthid, bool gIsRememberLogin) async {
    print('Login: $user $pw');

    String username = user;
    String password = pw;

    await SharedPref.setStrKey("username", username);
    await SharedPref.setStrKey("password", password);
    await SharedPref.setStrKey("User_AuthID", userAuthid);
    await SharedPref.setBoolKey("IsRememberLogin", gIsRememberLogin);
    await SharedPref.setStrKey("User_AuthID", userAuthid);
    DbTools.gUsername = username;
    DbTools.gPassword = password;
    DbTools.gUser_AuthID = userAuthid;
    DbTools.gIsRememberLogin = gIsRememberLogin;

    return true;
  }

  //****************************************************
  //************************  USERS  *******************
  //****************************************************

  static List<User> ListUser = [];
  static List<User> ListUsersearchresult = [];
  static User gUser = User.UserInit();
  static User gUserLogin = User.UserInit();
  static int gLoginID = -1;

  //****************************************************
  //****************************************************
  //****************************************************

  static Future<bool> getUserLogin(String aMail, String aPW) async {
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where User_Mail = '$aMail' AND User_PassWord = '$aPW'");
    if (ListUser == null) return false;

    if (ListUser.length == 1) {
      gUserLogin = ListUser[0];
      gLoginID = gUserLogin.UserID;
      return true;
    }

    return false;
  }

  static Future<bool> getUserName(String aName) async {
    List<User> ListUser = await getUser_API_Post("select", "select * from Users where User_Nom = '$aName'");

    if (ListUser == null) return false;

    print("getUserName ${ListUser.length}");

    if (ListUser.length > 0) {
      print("getUserName return TRUE");

      return true;
    }

    return false;
  }

  static Future<bool> getUserAll() async {
    ListUser = await getUser_API_Post("select", "select * from Users ORDER BY User_Nom");

    if (ListUser == null) return false;

    print("getUserAll ${ListUser.length}");

    if (ListUser.length > 0) {
/*
      print("getUserAll return TRUE");
      for (int i = 0; i < ListUser.length; i++) {
        var wUser = ListUser[i];
        print("getUserAll ${wUser.UserID} ${wUser.User_Nom} ${wUser.User_Prenom}");
      }
*/


      return true;
    }

    return false;
  }

  static bool getUserid(String id) {
    gUser = User.UserInit();
    if (ListUser == null) return false;
    if (ListUser.length > 0) {
      for (int i = 0; i < ListUser.length; i++) {
        var element = ListUser[i];
        if (element.UserID.toString().compareTo(id) == 0) {
          gUser = element;
          return true;
        }
      }
    }
    return false;
  }

  static String getUserid_Nom(String id) {
    if (ListUser == null) return "";
    if (ListUser.length > 0) {
      for (int i = 0; i < ListUser.length; i++) {
        var element = ListUser[i];
        if (element.UserID.toString().compareTo(id) == 0) {
          return "${element.User_Nom} ${element.User_Prenom}";
        }
      }
    }
    return "";
  }

  static Future<List<User>> getUser_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    print("getUser_API_Post $aSQL");
    print("getUser_API_Post $SrvUrl");

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    print("fields ${request.fields}");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());

      final items = parsedJson['data'];

//      print("items $items");

      if (items != null) {
        List<User> UserList = await items.map<User>((json) {
          return User.fromJson(json);
        }).toList();
        return UserList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> setUser(User User) async {
    String wSlq = 'UPDATE Users SET ' +
        'User_Actif = ${User.User_Actif} ,' +
        'User_Matricule = "${User.User_Matricule}" ,' +
        'User_TypeUserID = ${User.User_TypeUserID} ,' +
        'User_NivHabID = ${User.User_NivHabID} ,' +
        'User_Niv_Isole = ${User.User_Niv_Isole} ,' +
        'User_Nom = "${User.User_Nom}" ,' +
        'User_Prenom = "${User.User_Prenom}" ,' +
        'User_Adresse1 = "${User.User_Adresse1}" ,' +
        'User_Adresse2 = "${User.User_Adresse2}" ,' +
        'User_Cp = "${User.User_Cp}" ,' +
        'User_Ville = "${User.User_Ville}" ,' +
        'User_Tel = "${User.User_Tel}" ,' +
        'User_Mail = "${User.User_Mail}" ,' +
        'User_PassWord = "${User.User_PassWord}" ,' +
        'User_Service  = "${User.User_Service}" ,' +
        'User_Fonction = "${User.User_Fonction}" ,' +
        'User_Famille  = "${User.User_Famille}" ,' +
        'User_Depot  = "${User.User_Depot}" ' +
        ' WHERE UserID = ${User.UserID}';
    print("setUser " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser ret " + ret.toString());
    return ret;
  }

  static Future<bool> addUser(User User) async {
    print("User.User_Token_FBM " + DbTools.Token_FBM);

    String wValue = 'NULL,' + User.User_Actif.toString() + ' ,"' + User.User_Matricule + '", ${User.User_TypeUserID}, ${User.User_NivHabID}, ${User.User_Niv_Isole},"' + DbTools.Token_FBM + '", "' + User.User_Nom + '", "' + User.User_Prenom + ' ", "' + User.User_Adresse1 + '", "' + User.User_Adresse2 + '", "' + User.User_Cp + '", "' + User.User_Ville + ' ", "${User.User_Tel}", "${User.User_Mail}", "${User.User_PassWord}", "${User.User_Service}", "${User.User_Fonction}", "${User.User_Famille}", "${User.User_Depot}"';
    String wSlq = "INSERT INTO Users ("
        "UserID,User_Actif, User_Matricule, User_TypeUserID, User_NivHabID,User_Niv_Isole,User_Token_FBM, User_Nom, User_Prenom,User_Adresse1,User_Adresse2,User_Cp,User_Ville,User_Tel,User_Mail,User_PassWord,User_Service ,User_Fonction ,User_Famille, User_Depot) "
        "VALUES ($wValue)";
    print("addUser " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addUser ret " + ret.toString());
    return ret;
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Param_Saisie> ListParam_Saisie = [];
  static List<Param_Saisie> ListParam_Saisiesearchresult = [];
  static Param_Saisie gParam_Saisie = Param_Saisie.Param_SaisieInit();

  static List<Param_Saisie> ListParam_Saisie_Base = [];
  static List<Param_Saisie> ListParam_Audit_Base = [];
  static List<Param_Saisie> ListParam_Verif_Base = [];

  static int affSortComparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affSort2Comparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Ordre_Affichage;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Ordre_Affichage;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affL1SortComparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Affichage_L1_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Affichage_L1_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static int affL2SortComparison(Param_Saisie a, Param_Saisie b) {
    final paramSaisieOrdreAffichagea = a.Param_Saisie_Affichage_L2_Ordre;
    final paramSaisieOrdreAffichageb = b.Param_Saisie_Affichage_L2_Ordre;
    if (paramSaisieOrdreAffichagea < paramSaisieOrdreAffichageb) {
      return -1;
    } else if (paramSaisieOrdreAffichagea > paramSaisieOrdreAffichageb) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<bool> getParam_SaisieAll() async {
    ListParam_Saisie = await getParam_Saisie_API_Post("select", "select * from Param_Saisie ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");

    print("getParam_SaisieAll aSQL select * from Param_Saisie ORDER BY Param_Saisie_ID");

    if (ListParam_Saisie == null) return false;

    print("getParam_SaisieAll ${ListParam_Saisie.length}");

    if (ListParam_Saisie.length > 0) {
      print("getParam_SaisieAll return TRUE");

      return true;
    }

    return false;
  }

  static Future<bool> getParam_Saisie(String paramSaisieOrgane, String paramSaisieType) async {
    ListParam_Saisie = await getParam_Saisie_API_Post("select", "select * from Param_Saisie WHERE Param_Saisie_Organe = '$paramSaisieOrgane' AND Param_Saisie_Type = '$paramSaisieType'  ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");

    print("getParam_Saisie select * from Param_Saisie WHERE Param_Saisie_Organe = '$paramSaisieOrgane' AND Param_Saisie_Type = '$paramSaisieType'  ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");

    if (ListParam_Saisie == null) return false;

    print("getParam_Saisie ${ListParam_Saisie.length}");
    if (ListParam_Saisie.length > 0) {
      print("getParam_Saisie return TRUE");
      int i = 1;

      for (int i = 0; i < DbTools.ListParam_Saisie.length; i++) {
        Param_Saisie element = DbTools.ListParam_Saisie[i];
        element.Param_Saisie_Ordre = i++;
        await setParam_Saisie(element);
      }
      return true;
    }

    return false;
  }

  static Future<bool> getParam_Saisie_Base(String paramSaisieType) async {
    ListParam_Saisie_Base = await getParam_Saisie_API_Post("select", "select * from Param_Saisie WHERE Param_Saisie_Organe = 'Base' AND Param_Saisie_Type = '$paramSaisieType'  ORDER BY Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_Ordre,Param_Saisie_ID");
    if (ListParam_Saisie_Base == null) return false;
    if (ListParam_Saisie_Base.length > 0) {
      int i = 1;
      ListParam_Saisie_Base.forEach((element) {
        element.Param_Saisie_Ordre = i++;
        setParam_Saisie(element);
      });
      return true;
    }
    return false;
  }

  static Future<List<Param_Saisie>> getParam_Saisie_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Saisie> paramSaisielist = await items.map<Param_Saisie>((json) {
          return Param_Saisie.fromJson(json);
        }).toList();
        return paramSaisielist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<bool> setParam_Saisie(Param_Saisie paramSaisie) async {
    String wSlq = "UPDATE Param_Saisie SET "
            "Param_SaisieId = \"${paramSaisie.Param_SaisieId}\"," +
        "Param_Saisie_Organe = \"${paramSaisie.Param_Saisie_Organe}\"," +
        "Param_Saisie_Type = \"${paramSaisie.Param_Saisie_Type}\"," +
        "Param_Saisie_ID = \"${paramSaisie.Param_Saisie_ID}\"," +
        "Param_Saisie_Label = \"${paramSaisie.Param_Saisie_Label}\"," +
        "Param_Saisie_Aide = \"${paramSaisie.Param_Saisie_Aide}\"," +
        "Param_Saisie_Controle =  \"${paramSaisie.Param_Saisie_Controle}\"," +
        "Param_Saisie_Ordre = ${paramSaisie.Param_Saisie_Ordre.toString()}," +
        "Param_Saisie_Affichage = \"${paramSaisie.Param_Saisie_Affichage.toString()}\"," +
        "Param_Saisie_Ordre_Affichage = ${paramSaisie.Param_Saisie_Ordre_Affichage.toString()}, " +
        "Param_Saisie_Affichage_Titre = \"${paramSaisie.Param_Saisie_Affichage_Titre}\"," +
        "Param_Saisie_Icon = \"${paramSaisie.Param_Saisie_Icon.toString()}\"," +
        "Param_Saisie_Triger = \"${paramSaisie.Param_Saisie_Triger.toString()}\"," +
        "Param_Saisie_Affichage_L1 = ${paramSaisie.Param_Saisie_Affichage_L1.toString()}, " +
        "Param_Saisie_Affichage_L1_Ordre = ${paramSaisie.Param_Saisie_Affichage_L1_Ordre.toString()}, " +
        "Param_Saisie_Affichage_L2 = ${paramSaisie.Param_Saisie_Affichage_L2.toString()}, " +
        "Param_Saisie_Affichage_L2_Ordre = ${paramSaisie.Param_Saisie_Affichage_L2_Ordre.toString()}" +
        " WHERE Param_SaisieId = " +
        paramSaisie.Param_SaisieId.toString();
    print("setParam_Saisie " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Saisie ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Saisie(Param_Saisie paramSaisie) async {
    String wValue = "NULL,'${paramSaisie.Param_Saisie_Organe}','${paramSaisie.Param_Saisie_Type}','???','---'";
    String wSlq = "INSERT INTO Param_Saisie (Param_SaisieId, Param_Saisie_Organe, Param_Saisie_Type, Param_Saisie_ID,Param_Saisie_Label) VALUES ($wValue)";
    print("addParam_Saisie " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Saisie ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Saisie(Param_Saisie paramSaisie) async {
    String aSQL = "DELETE FROM Param_Saisie WHERE Param_SaisieId = ${paramSaisie.Param_SaisieId} ";
    print("delParam_Saisie " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Saisie ret " + ret.toString());
    return ret;
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Param_Param> ListParam_ParamAll = [];
  static List<Param_Param> ListParam_Param = [];
  static List<Param_Param> ListParam_Param_Abrev = [];
  static List<Param_Param> ListParam_Paramsearchresult = [];
  static Param_Param gParam_Param = Param_Param.Param_ParamInit();

  static Future<bool> getParam_ParamAll() async {
    ListParam_ParamAll = await getParam_Param_API_Post("select", "select * from Param_Param ORDER BY Param_Param_Ordre,Param_Param_ID");

    print("getParam_ParamAll aSQL select * from Param_Param ORDER BY Param_Param_ID");

    if (ListParam_ParamAll == null) return false;

    print("getParam_ParamAll ${ListParam_ParamAll.length}");

    if (ListParam_ParamAll.length > 0) {
      print("getParam_ParamAll return TRUE");

      return true;
    }

    return false;
  }

  static List<String> ListParam_ParamFam = [];
  static List<String> ListParam_ParamFamID = [];
  static List<String> ListParam_FiltreFam = [];
  static List<String> ListParam_FiltreFamID = [];

  static Future initListFam() async {
    await DbTools.getUserAll();
    await DbTools.getParam_ParamFam("Type_Interv");
    DbTools.List_TypeInter.clear();
    DbTools.List_TypeInter.addAll(DbTools.ListParam_ParamFam);
    DbTools.List_TypeInterID.clear();
    DbTools.List_TypeInterID.addAll(DbTools.ListParam_ParamFamID);
    await DbTools.getParam_ParamFam("Type_Organe");
    DbTools.List_ParcTypeInter.clear();
    DbTools.List_ParcTypeInter.addAll(DbTools.ListParam_ParamFam);
    DbTools.List_ParcTypeInterID.clear();
    DbTools.List_ParcTypeInterID.addAll(DbTools.ListParam_ParamFamID);

    await DbTools.getParam_ParamFam("Status_Interv");
    DbTools.List_StatusInter.clear();
    DbTools.List_StatusInter.addAll(DbTools.ListParam_ParamFam);
    DbTools.List_StatusInterID.clear();
    DbTools.List_StatusInterID.addAll(DbTools.ListParam_ParamFamID);

    await DbTools.getParam_ParamFam("Type_Fact");
    DbTools.List_FactInter.clear();
    DbTools.List_FactInter.addAll(DbTools.ListParam_ParamFam);
    DbTools.List_FactInterID.clear();
    DbTools.List_FactInterID.addAll(DbTools.ListParam_ParamFamID);

    List_UserInter.clear();
    List_UserInterID.clear();

    for (int i = 0; i < DbTools.ListUser.length; i++) {
      var element = DbTools.ListUser[i];
      List_UserInter.add("${element.User_Nom} ${element.User_Prenom}");
      List_UserInterID.add("${element.UserID}");
    }
  }

  static Future<bool> getParam_ParamFam(String wFam) async {
    ListParam_ParamFam.clear();
    ListParam_ParamFamID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo(wFam) == 0) {
        ListParam_ParamFam.add(element.Param_Param_Text);
        ListParam_ParamFamID.add(element.Param_Param_ID);
      }
    });

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("*");

    ListParam_FiltreFam.addAll(ListParam_ParamFam);
    ListParam_FiltreFamID.addAll(ListParam_ParamFamID);

    return true;
  }

  static bool getParam_ParamMemDet(String paramParamType, String paramParamId) {
    ListParam_Param.clear();
    ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo(paramParamType) == 0 && element.Param_Param_ID.compareTo(paramParamId) == 0) {
        ListParam_Param.add(element);
      }
    });
    return true;
  }

  static String getParam_Param_Text(String paramParamType, String paramParamId) {
    String wRet = "";

    for (int i = 0; i < ListParam_ParamAll.length; i++) {
      var element = ListParam_ParamAll[i];
      if (element.Param_Param_Type.compareTo(paramParamType) == 0 && element.Param_Param_ID.compareTo(paramParamId) == 0) {
        wRet = element.Param_Param_Text;
      }
    }
    return wRet;
  }

  static Future<bool> getParam_Param(String paramParamType, bool sort) async {
    ListParam_Param = await getParam_Param_API_Post("select", "select * from Param_Param WHERE Param_Param_Type = '$paramParamType' ORDER BY Param_Param_Ordre,Param_Param_ID");

    if (!sort) return true;
//    print("getParam_Param aSQL select * from Param_Param WHERE Param_Param_Type = '${Param_Param_Type}' ORDER BY Param_Param_Ordre,Param_Param_ID");
    if (ListParam_Param == null) return false;

//    print("getParam_Param ${ListParam_Param.length}");
    if (ListParam_Param.length > 0) {
      int i = 1;
      DbTools.ListParam_Param.forEach((element) {
        //      print("getParam_Param ${element.Param_Param_Ordre} ${element.Param_Param_ID}");
        element.Param_Param_Ordre = i++;
        setParam_Param(element);
      });
      return true;
    }

    return false;
  }

  static Future<Param_Param> getParam_ParamID(int ID) async {
    ListParam_Param = await getParam_Param_API_Post("select", "select * from Param_Param WHERE Param_ParamId = '$ID' ORDER BY Param_Param_Ordre,Param_Param_ID");
    if (ListParam_Param == null) return Param_Param.Param_ParamInit();
    return ListParam_Param[0];
  }

  static Future<bool> setParam_Param(Param_Param paramParam) async {
    String wSlq = "UPDATE Param_Param SET "
            "Param_Param_Text = \"" +
        paramParam.Param_Param_Text +
        "\", " +
        "Param_Param_ID = \"" +
        paramParam.Param_Param_ID +
        "\", " +
        "Param_Param_Int = " +
        paramParam.Param_Param_Int.toString() +
        ", " +
        "Param_Param_Ordre = " +
        paramParam.Param_Param_Ordre.toString() +
        ", " +
        "Param_Param_Double = " +
        paramParam.Param_Param_Double.toString() +
        " WHERE Param_ParamId = " +
        paramParam.Param_ParamId.toString();
//    gColors.printWrapped("setParam_Param " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
//    print("setParam_Param ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Param(Param_Param paramParam) async {
    String wValue = "NULL,'${paramParam.Param_Param_Type}','???','---'";
    String wSlq = "INSERT INTO Param_Param (Param_ParamId,Param_Param_Type,Param_Param_ID,Param_Param_Text) VALUES ($wValue)";
    print("addParam_Param " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Param ret $ret $gLastID");
    return ret;
  }

  static Future<bool> delParam_Param(Param_Param paramParam) async {
    String aSQL = "DELETE FROM Param_Param WHERE Param_ParamId = ${paramParam.Param_ParamId} ";
    print("delParam_Param " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Param ret " + ret.toString());
    return ret;
  }

  static Future<List<Param_Param>> getParam_Param_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Param> paramParamlist = await items.map<Param_Param>((json) {
          return Param_Param.fromJson(json);
        }).toList();
        return paramParamlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<NF074_Gammes> ListNF074_Gammes = [];
  static List<NF074_Gammes> ListNF074_Gammessearchresult = [];
  static NF074_Gammes gNF074_Gammes = NF074_Gammes.NF074_GammesInit();

  static Future<bool> getNF074_GammesAll() async {
    ListNF074_Gammes = await getNF074_Gammes_API_Post("select", "select * from NF074_Gammes ORDER BY NF074_GammesID");
    if (ListNF074_Gammes == null) return false;
    print("getNF074_GammesAll ${ListNF074_Gammes.length}");
    if (ListNF074_Gammes.length > 0) {
      print("getNF074_GammesAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_GammesDesc(String wDesc) async {
    String wSql = 'select * from NF074_Gammes WHERE NF074_Gammes_DESC = "${wDesc}"';
//    print("getNF074_GammesDesc response $wSql");
    ListNF074_Gammes = await getNF074_Gammes_API_Post("select", wSql);
    if (ListNF074_Gammes == null) return false;
//    print("getNF074_GammesDesc ${ListNF074_Gammes.length}");
    if (ListNF074_Gammes.length > 0) {

      return true;
    }
    return false;
  }

  static Future<bool> getNF074_GammesCLF(String wCLF) async {
    String wSql = 'select * from NF074_Gammes WHERE NF074_Gammes_CLF = "${wCLF}"';
//    print("getNF074_GammesCLF response $wSql");
    ListNF074_Gammes = await getNF074_Gammes_API_Post("select", wSql);
    if (ListNF074_Gammes == null) return false;
    if (ListNF074_Gammes.length > 0) {
      //print("getNF074_GammesCLF ${ListNF074_Gammes.length}");

      return true;
    }
    return false;
  }


  static Future<bool> getNF074_CtrlGammesArticles() async {
    String wSql = "SELECT NF074_Gammes.* FROM NF074_Gammes WHERE  NF074_Gammes_REF != '' AND NF074_Gammes_REF NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Gammes_REF;";
//    print("getNF074_CtrlGammesArticles wSql $wSql");
    ListNF074_Gammes = await getNF074_Gammes_API_Post("select", wSql);
    if (ListNF074_Gammes == null) return false;
    print("getNF074_CtrlGammesArticles ${ListNF074_Gammes.length}");
    if (ListNF074_Gammes.length > 0) {
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Gammes.length; i++) {
        var element = ListNF074_Gammes[i];
        associateList.add({"Code": "${element.NF074_Gammes_REF}", "Desc": "${element.NF074_Gammes_GAM}"});
      }
      await exportCSV(associateList , "getNF074_CtrlGammesArticles");
      return true;
    }
    return false;
  }



  static Future<bool> addNF074_Gammes(NF074_Gammes wNF074_Gammes) async {
    String wValue = "NULL,'${wNF074_Gammes.NF074_Gammes_DESC}','${wNF074_Gammes.NF074_Gammes_FAB}','${wNF074_Gammes.NF074_Gammes_PRS}','${wNF074_Gammes.NF074_Gammes_CLF}','${wNF074_Gammes.NF074_Gammes_MOB}','${wNF074_Gammes.NF074_Gammes_PDT}','${wNF074_Gammes.NF074_Gammes_POIDS}','${wNF074_Gammes.NF074_Gammes_GAM}','${wNF074_Gammes.NF074_Gammes_CODF}','${wNF074_Gammes.NF074_Gammes_REF}','${wNF074_Gammes.NF074_Gammes_SERG}','${wNF074_Gammes.NF074_Gammes_APD4}','${wNF074_Gammes.NF074_Gammes_AVT}','${wNF074_Gammes.NF074_Gammes_NCERT}'";
    String wSlq = "INSERT INTO NF074_Gammes (NF074_GammesId,NF074_Gammes_DESC,NF074_Gammes_FAB,NF074_Gammes_PRS,NF074_Gammes_CLF,NF074_Gammes_MOB,NF074_Gammes_PDT,NF074_Gammes_POIDS,NF074_Gammes_GAM,NF074_Gammes_CODF,NF074_Gammes_REF,NF074_Gammes_SERG,NF074_Gammes_APD4,NF074_Gammes_AVT,NF074_Gammes_NCERT) VALUES ($wValue)";
//    print("addNF074_Gammes " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
//    print("addNF074_Gammes ret " + ret.toString());
    return ret;
  }

  static Future<bool> delNF074_Gammes(NF074_Gammes paramHab) async {
    String aSQL = "DELETE FROM NF074_Gammes WHERE NF074_GammesId = ${paramHab.NF074_GammesId} ";
    print("delNF074_Gammes " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delNF074_Gammes ret " + ret.toString());
    return ret;
  }



  static Future<List<NF074_Gammes>> getNF074_Gammes_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

//    print("getNF074_Gammes_API_Post ret ${response.statusCode}");


    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Gammes> paramHablist = await items.map<NF074_Gammes>((json) {
          return NF074_Gammes.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<NF074_Histo_Normes> ListNF074_Histo_Normes = [];
  static List<NF074_Histo_Normes> ListNF074_Histo_Normessearchresult = [];
  static NF074_Histo_Normes gNF074_Histo_Normes = NF074_Histo_Normes.NF074_Histo_NormesInit();

  static Future<bool> getNF074_Histo_NormesAll() async {
    ListNF074_Histo_Normes = await getNF074_Histo_Normes_API_Post("select", "select * from NF074_Histo_Normes ORDER BY NF074_Histo_NormesId");
    if (ListNF074_Histo_Normes == null) return false;
    print("getNF074_Histo_NormesAll ${ListNF074_Histo_Normes.length}");
    if (ListNF074_Histo_Normes.length > 0) {
      print("getNF074_Histo_NormesAll return TRUE");
      return true;
    }
    return false;
  }


  static Future<bool> setNF074_Histo_Normes(NF074_Histo_Normes aNF074_Histo_Normes) async {
    String wSlq = "UPDATE NF074_Histo_Normes SET NF074_Histo_Normes_NCERT = ${aNF074_Histo_Normes.NF074_Histo_Normes_NCERT} WHERE Param_HabId = ${aNF074_Histo_Normes.NF074_Histo_NormesId}";
    gColors.printWrapped("setNF074_Histo_Normes " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setNF074_Histo_Normes ret " + ret.toString());
    return ret;
  }





  static Future<List<NF074_Histo_Normes>> getNF074_Histo_Normes_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Histo_Normes> paramHablist = await items.map<NF074_Histo_Normes>((json) {
          return NF074_Histo_Normes.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
  
  //*****************************
  //*****************************
  //*****************************

  static List<NF074_Pieces_Actions> ListNF074_Pieces_Actions = [];
  static List<NF074_Pieces_Actions> ListNF074_Pieces_Actionssearchresult = [];
  static NF074_Pieces_Actions gNF074_Pieces_Actions = NF074_Pieces_Actions.NF074_Pieces_ActionsInit();

  static Future<bool> getNF074_CtrlGammesPieces_Actions_PDT() async {

    String wSql = "SELECT NF074_Pieces_Actions.* FROM NF074_Pieces_Actions WHERE  NF074_Pieces_Actions_PDT NOT IN (SELECT NF074_Gammes_PDT FROM NF074_Gammes) GROUP BY NF074_Pieces_Actions_PDT;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSql);
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesPieces_Actions_POIDS() async {
    String wSql = "SELECT NF074_Pieces_Actions.* FROM NF074_Pieces_Actions WHERE  NF074_Pieces_Actions_POIDS NOT IN (SELECT NF074_Gammes_POIDS FROM NF074_Gammes) GROUP BY NF074_Pieces_Actions_POIDS;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSql);
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesPieces_Actions_PRS() async {
    String wSql = "SELECT NF074_Pieces_Actions.* FROM NF074_Pieces_Actions WHERE  NF074_Pieces_Actions_PRS NOT IN (SELECT NF074_Gammes_PRS FROM NF074_Gammes) GROUP BY NF074_Pieces_Actions_PRS;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSql);
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      return true;
    }
    return false;
  }


  static Future<bool> getNF074_Pieces_ActionsAll() async {
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", "select * from NF074_Pieces_Actions ORDER BY NF074_Pieces_ActionsId");
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_Pieces_ActionsAll ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      print("getNF074_Pieces_ActionsAll return TRUE");
      return true;
    }
    return false;
  }


  static Future<bool> getNF074_CtrlPiecesActionsArticles1() async {
    String wSql = "SELECT NF074_Pieces_Actions.* FROM NF074_Pieces_Actions WHERE NF074_Pieces_Actions_Code_article_PD1 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Actions_Code_article_PD1;";
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSql);
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_CtrlPiecesActionsArticles1 ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      print("getNF074_CtrlPiecesActionsArticles1 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Actions.length; i++) {
        var element = ListNF074_Pieces_Actions[i];
        associateList.add({"Code": "${element.NF074_Pieces_Actions_CodeArticlePD1}", "Desc": "${element.NF074_Pieces_Actions_DescriptionPD1}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPiecesActionsArticles1");

      return true;
    }
    return false;
  }

  static Future exportCSV(List<Map<String, dynamic>> list, String wName) async {
    List<List<dynamic>> rows = [];
    rows.add(["Code", "Desc"]);
    for (var map in list) {
      rows.add([map["Code"], map["Desc"]]);
    }
    String csv = const ListToCsvConverter().convert(fieldDelimiter : ";",rows);
    List<int> bytes = utf8.encode(csv);
    await FileSaveHelper.saveAndLaunchFile(bytes, '$wName.csv');
  }



  static Future<bool> getNF074_CtrlPiecesActionsArticles2() async {
    String wSql = "SELECT NF074_Pieces_Actions.* FROM NF074_Pieces_Actions WHERE NF074_Pieces_Actions_Code_article_PD2 != '' AND NF074_Pieces_Actions_Code_article_PD2 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Actions_Code_article_PD2;";
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSql);
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_CtrlPiecesActionsArticles2 ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      print("getNF074_CtrlPiecesActionsArticles2 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Actions.length; i++) {
        var element = ListNF074_Pieces_Actions[i];
        associateList.add({"Code": "${element.NF074_Pieces_Actions_CodeArticlePD2}", "Desc": "${element.NF074_Pieces_Actions_DescriptionPD2}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPiecesActionsArticles2");

      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPiecesActionsArticles3() async {
    String wSql = "SELECT NF074_Pieces_Actions.* FROM NF074_Pieces_Actions WHERE NF074_Pieces_Actions_Code_article_PD3 != '' AND  F074_Pieces_Actions_Code_article_PD3 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Actions_Code_article_PD3;";
    ListNF074_Pieces_Actions = await getNF074_Pieces_Actions_API_Post("select", wSql);
    if (ListNF074_Pieces_Actions == null) return false;
    print("getNF074_CtrlPiecesActionsArticles3 ${ListNF074_Pieces_Actions.length}");
    if (ListNF074_Pieces_Actions.length > 0) {
      print("getNF074_CtrlPiecesActionsArticles3 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Actions.length; i++) {
        var element = ListNF074_Pieces_Actions[i];
        associateList.add({"Code": "${element.NF074_Pieces_Actions_CodeArticlePD3}", "Desc": "${element.NF074_Pieces_Actions_DescriptionPD3}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPiecesActionsArticles3");

      return true;
    }
    return false;
  }


  static Future<List<NF074_Pieces_Actions>> getNF074_Pieces_Actions_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Pieces_Actions> paramHablist = await items.map<NF074_Pieces_Actions>((json) {
          return NF074_Pieces_Actions.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<NF074_Pieces_Det> ListNF074_Pieces_Det = [];
  static List<NF074_Pieces_Det> ListNF074_Pieces_Detsearchresult = [];
  static NF074_Pieces_Det gNF074_Pieces_Det = NF074_Pieces_Det.NF074_Pieces_DetInit();



  static Future<bool> getNF074_CtrlGammesPiecesDet() async {
    String wSql = "SELECT NF074_Pieces_Det.* FROM NF074_Pieces_Det WHERE  NF074_Pieces_Det_CODF NOT IN (SELECT NF074_Gammes_CODF FROM NF074_Gammes) GROUP BY NF074_Pieces_Det_CODF;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Det = await getNF074_Pieces_Det_API_Post("select", wSql);
    if (ListNF074_Pieces_Det == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Det.length}");
    if (ListNF074_Pieces_Det.length > 0) {
      return true;
    }
    return false;
  }



  static Future<bool> getNF074_Pieces_DetAll() async {
    ListNF074_Pieces_Det = await getNF074_Pieces_Det_API_Post("select", "select * from NF074_Pieces_Det ORDER BY NF074_Pieces_DetId");
    if (ListNF074_Pieces_Det == null) return false;
    print("getNF074_Pieces_DetAll ${ListNF074_Pieces_Det.length}");
    if (ListNF074_Pieces_Det.length > 0) {
      print("getNF074_Pieces_DetAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPieceDetArticles1() async {
    String wSql = "SELECT NF074_Pieces_Det.* FROM NF074_Pieces_Det WHERE  NF074_Pieces_Det_Code_article_PD1 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Det_Code_article_PD1;";
    ListNF074_Pieces_Det = await getNF074_Pieces_Det_API_Post("select", wSql);
    if (ListNF074_Pieces_Det == null) return false;
    print("getNF074_CtrlPieceDetArticles1 ${ListNF074_Pieces_Det.length}");
    if (ListNF074_Pieces_Det.length > 0) {
      print("getNF074_CtrlPieceDetArticles1 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Det.length; i++) {
        var element = ListNF074_Pieces_Det[i];
        associateList.add({"Code": "${element.NF074_Pieces_Det_CodeArticlePD1}", "Desc": "${element.NF074_Pieces_Det_DescriptionPD1}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPieceDetArticles1");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPieceDetArticles2() async {
    String wSql = "SELECT NF074_Pieces_Det.* FROM NF074_Pieces_Det WHERE NF074_Pieces_Det_Code_article_PD2 != '' AND  NF074_Pieces_Det_Code_article_PD2 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Det_Code_article_PD2;";
    ListNF074_Pieces_Det = await getNF074_Pieces_Det_API_Post("select", wSql);
    if (ListNF074_Pieces_Det == null) return false;
    print("getNF074_CtrlPieceDetArticles2 ${ListNF074_Pieces_Det.length}");
    if (ListNF074_Pieces_Det.length > 0) {
      print("getNF074_CtrlPieceDetArticles2 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Det.length; i++) {
        var element = ListNF074_Pieces_Det[i];
        associateList.add({"Code": "${element.NF074_Pieces_Det_CodeArticlePD2}", "Desc": "${element.NF074_Pieces_Det_DescriptionPD2}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPieceDetArticles2");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPieceDetArticles3() async {
    String wSql = "SELECT NF074_Pieces_Det.* FROM NF074_Pieces_Det WHERE NF074_Pieces_Det_Code_article_PD3 != '' AND  NF074_Pieces_Det_Code_article_PD3 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Det_Code_article_PD3;";
    ListNF074_Pieces_Det = await getNF074_Pieces_Det_API_Post("select", wSql);
    if (ListNF074_Pieces_Det == null) return false;
    print("getNF074_CtrlPieceDetArticles3 ${ListNF074_Pieces_Det.length}");
    if (ListNF074_Pieces_Det.length > 0) {
      print("getNF074_CtrlPieceDetArticles3 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Det.length; i++) {
        var element = ListNF074_Pieces_Det[i];
        associateList.add({"Code": "${element.NF074_Pieces_Det_CodeArticlePD3}", "Desc": "${element.NF074_Pieces_Det_DescriptionPD3}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPieceDetArticles3");
      return true;
    }
    return false;
  }

  static Future<List<NF074_Pieces_Det>> getNF074_Pieces_Det_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Pieces_Det> paramHablist = await items.map<NF074_Pieces_Det>((json) {
          return NF074_Pieces_Det.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<NF074_Pieces_Det_Inc> ListNF074_Pieces_Det_Inc = [];
  static List<NF074_Pieces_Det_Inc> ListNF074_Pieces_Det_Incsearchresult = [];
  static NF074_Pieces_Det_Inc gNF074_Pieces_Det_Inc = NF074_Pieces_Det_Inc.NF074_Pieces_Det_IncInit();


  static Future<bool> getNF074_CtrlGammesPieces_Det_Inc_PDT() async {

    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_PDT NOT IN (SELECT NF074_Gammes_PDT FROM NF074_Gammes) GROUP BY NF074_Pieces_Det_Inc_PDT;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesPieces_Det_Inc_POIDS() async {
    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_POIDS NOT IN (SELECT NF074_Gammes_POIDS FROM NF074_Gammes) GROUP BY NF074_Pieces_Det_Inc_POIDS;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesPieces_Det_Inc_PRS() async {
    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_PRS NOT IN (SELECT NF074_Gammes_PRS FROM NF074_Gammes) GROUP BY NF074_Pieces_Det_Inc_PRS;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesPieces_Det_Inc_CLF() async {
    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_CLF NOT IN (SELECT NF074_Gammes_CLF FROM NF074_Gammes) GROUP BY NF074_Pieces_Det_Inc_CLF;";
    print("getNF074_CtrlGammesPiecesDet wSql $wSql");
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlGammesPiecesDet ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      return true;
    }
    return false;
  }



  static Future<bool> getNF074_Pieces_Det_IncAll() async {
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", "select * from NF074_Pieces_Det_Inc ORDER BY NF074_Pieces_Det_IncId");
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_Pieces_Det_IncAll ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      print("getNF074_Pieces_Det_IncAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPieceDetIncArticles1() async {
    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_Code_article_PD1 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Det_Inc_Code_article_PD1;";
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlPieceDetIncArticles1 ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      print("getNF074_CtrlPieceDetIncArticles1 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Det_Inc.length; i++) {
        var element = ListNF074_Pieces_Det_Inc[i];
        associateList.add({"Code": "${element.NF074_Pieces_Det_Inc_CodeArticlePD1}", "Desc": "${element.NF074_Pieces_Det_Inc_DescriptionPD1}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPieceDetIncArticles1");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPieceDetIncArticles2() async {
    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_Code_article_PD2 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Det_Inc_Code_article_PD2;";
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlPieceDetIncArticles2 ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      print("getNF074_CtrlPieceDetIncArticles2 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Det_Inc.length; i++) {
        var element = ListNF074_Pieces_Det_Inc[i];
        associateList.add({"Code": "${element.NF074_Pieces_Det_Inc_CodeArticlePD2}", "Desc": "${element.NF074_Pieces_Det_Inc_DescriptionPD2}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPieceDetIncArticles2");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlPieceDetIncArticles3() async {
    String wSql = "SELECT NF074_Pieces_Det_Inc.* FROM NF074_Pieces_Det_Inc WHERE  NF074_Pieces_Det_Inc_Code_article_PD3 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Pieces_Det_Inc_Code_article_PD3;";
    ListNF074_Pieces_Det_Inc = await getNF074_Pieces_Det_Inc_API_Post("select", wSql);
    if (ListNF074_Pieces_Det_Inc == null) return false;
    print("getNF074_CtrlPieceDetIncArticles3 ${ListNF074_Pieces_Det_Inc.length}");
    if (ListNF074_Pieces_Det_Inc.length > 0) {
      print("getNF074_CtrlPieceDetIncArticles3 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Pieces_Det_Inc.length; i++) {
        var element = ListNF074_Pieces_Det_Inc[i];
        associateList.add({"Code": "${element.NF074_Pieces_Det_Inc_CodeArticlePD3}", "Desc": "${element.NF074_Pieces_Det_Inc_DescriptionPD3}"});
      }
      await exportCSV(associateList , "getNF074_CtrlPieceDetIncArticles3");
      return true;
    }
    return false;
  }
  static Future<List<NF074_Pieces_Det_Inc>> getNF074_Pieces_Det_Inc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Pieces_Det_Inc> paramHablist = await items.map<NF074_Pieces_Det_Inc>((json) {
          return NF074_Pieces_Det_Inc.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<NF074_Mixte_Produit> ListNF074_Mixte_Produit = [];
  static List<NF074_Mixte_Produit> ListNF074_Mixte_Produitsearchresult = [];
  static NF074_Mixte_Produit gNF074_Mixte_Produit = NF074_Mixte_Produit.NF074_Mixte_ProduitInit();

  static Future<bool> getNF074_CtrlGammesMixte_Produit_PDT() async {

    String wSql = "SELECT NF074_Mixte_Produit.* FROM NF074_Mixte_Produit WHERE  NF074_Mixte_Produit_PDT NOT IN (SELECT NF074_Gammes_PDT FROM NF074_Gammes) GROUP BY NF074_Mixte_Produit_PDT;";
    print("getNF074_CtrlGammesMixte_Produit_PDT wSql $wSql");
    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSql);
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_CtrlGammesMixte_Produit_PDT ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesMixte_Produit_POIDS() async {
    String wSql = "SELECT NF074_Mixte_Produit.* FROM NF074_Mixte_Produit WHERE  NF074_Mixte_Produit_POIDS NOT IN (SELECT NF074_Gammes_POIDS FROM NF074_Gammes) GROUP BY NF074_Mixte_Produit_POIDS;";
    print("getNF074_CtrlGammesMixte_Produit_POIDS wSql $wSql");
    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSql);
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_CtrlGammesMixte_Produit_POIDS ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlGammesMixte_Produit_CLF() async {
    String wSql = "SELECT NF074_Mixte_Produit.* FROM NF074_Mixte_Produit WHERE  NF074_Mixte_Produit_CLF NOT IN (SELECT NF074_Gammes_CLF FROM NF074_Gammes) GROUP BY NF074_Mixte_Produit_CLF;";
    print("getNF074_CtrlGammesMixte_Produit_CLF wSql $wSql");
    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSql);
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_CtrlGammesMixte_Produit_CLF ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      return true;
    }
    return false;
  }
  
  
  
  static Future<bool> getNF074_Mixte_ProduitAll() async {
    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", "select * from NF074_Mixte_Produit ORDER BY NF074_Mixte_ProduitId");
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_Mixte_ProduitAll ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      print("getNF074_Mixte_ProduitAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlMixteProduitArticles1() async {
    String wSql = "SELECT NF074_Mixte_Produit.* FROM NF074_Mixte_Produit WHERE NF074_Mixte_Produit_Code_article_PD1 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Mixte_Produit_Code_article_PD1;";
    print("getNF074_CtrlMixteProduitArticles1 wSql ${wSql}");

    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSql);
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_CtrlMixteProduitArticles1 ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      print("getNF074_CtrlMixteProduitArticles1 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Mixte_Produit.length; i++) {
        var element = ListNF074_Mixte_Produit[i];
        associateList.add({"Code": "${element.NF074_Mixte_Produit_CodeArticlePD1}", "Desc": "${element.NF074_Mixte_Produit_DescriptionPD1}"});
      }
      await exportCSV(associateList , "getNF074_CtrlMixteProduitArticles1");

      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlMixteProduitArticles2() async {
    String wSql = "SELECT NF074_Mixte_Produit.* FROM NF074_Mixte_Produit WHERE NF074_Mixte_Produit_Code_article_PD2 != '' AND NF074_Mixte_Produit_Code_article_PD2 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Mixte_Produit_Code_article_PD2;";
    print("getNF074_CtrlMixteProduitArticles2 wSql ${wSql}");

    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSql);
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_CtrlMixteProduitArticles2 ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      print("getNF074_CtrlMixteProduitArticles2 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Mixte_Produit.length; i++) {
        var element = ListNF074_Mixte_Produit[i];
        associateList.add({"Code": "${element.NF074_Mixte_Produit_CodeArticlePD2}", "Desc": "${element.NF074_Mixte_Produit_DescriptionPD2}"});
      }
      await exportCSV(associateList , "getNF074_CtrlMixteProduitArticles2");

      return true;
    }
    return false;
  }

  static Future<bool> getNF074_CtrlMixteProduitArticles3() async {
    String wSql = "SELECT NF074_Mixte_Produit.* FROM NF074_Mixte_Produit WHERE NF074_Mixte_Produit_Code_article_PD3 != '' AND  NF074_Mixte_Produit_Code_article_PD3 NOT IN (SELECT Article_codeArticle FROM Articles_Ebp) GROUP BY NF074_Mixte_Produit_Code_article_PD3;";
    print("getNF074_CtrlMixteProduitArticles3 wSql ${wSql}");

    ListNF074_Mixte_Produit = await getNF074_Mixte_Produit_API_Post("select", wSql);
    if (ListNF074_Mixte_Produit == null) return false;
    print("getNF074_CtrlMixteProduitArticles3 ${ListNF074_Mixte_Produit.length}");
    if (ListNF074_Mixte_Produit.length > 0) {
      print("getNF074_CtrlMixteProduitArticles3 return TRUE");
      List<Map<String, dynamic>> associateList = [];
      for (int i = 0; i < ListNF074_Mixte_Produit.length; i++) {
        var element = ListNF074_Mixte_Produit[i];
        associateList.add({"Code": "${element.NF074_Mixte_Produit_CodeArticlePD3}", "Desc": "${element.NF074_Mixte_Produit_DescriptionPD3}"});
      }
      await exportCSV(associateList , "getNF074_CtrlMixteProduitArticles3");

      return true;
    }
    return false;
  }



  static Future<List<NF074_Mixte_Produit>> getNF074_Mixte_Produit_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<NF074_Mixte_Produit> paramHablist = await items.map<NF074_Mixte_Produit>((json) {
          return NF074_Mixte_Produit.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
  //*****************************
  //*****************************
  //*****************************

  static List<Param_Hab> ListParam_Hab = [];
  static List<Param_Hab> ListParam_Habsearchresult = [];
  static Param_Hab gParam_Hab = Param_Hab.Param_HabInit();

  static Future<bool> getParam_HabAll() async {
    ListParam_Hab = await getParam_Hab_API_Post("select", "select * from Param_Hab ORDER BY Param_Hab_Ordre,Param_HabID");

    if (ListParam_Hab == null) return false;
    print("getParam_HabAll ${ListParam_Hab.length}");
    if (ListParam_Hab.length > 0) {
      print("getParam_HabAll return TRUE");
      return true;
    }
    return false;
  }

  String Param_Hab_PDT = "";
  String Param_Hab_Grp = "";
  int Param_Hab_Ordre = 0;

  static Future<bool> setParam_Hab(Param_Hab paramHab) async {
    String wSlq = "UPDATE Param_Hab SET "
            "Param_Hab_PDT = \"${paramHab.Param_Hab_PDT}\", " +
        "Param_Hab_Grp = \"${paramHab.Param_Hab_Grp}\", " +
        "Param_Hab_Ordre = ${paramHab.Param_Hab_Ordre.toString()} WHERE Param_HabId = ${paramHab.Param_HabId.toString()}";
    gColors.printWrapped("setParam_Hab " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Hab ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Hab(Param_Hab paramHab) async {
    String wValue = "NULL,'???','---', 0";
    String wSlq = "INSERT INTO Param_Hab (Param_HabId, Param_Hab_PDT, Param_Hab_Grp, Param_Hab_Ordre) VALUES ($wValue)";
    print("addParam_Hab " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Hab ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Hab(Param_Hab paramHab) async {
    String aSQL = "DELETE FROM Param_Hab WHERE Param_HabId = ${paramHab.Param_HabId} ";
    print("delParam_Hab " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Hab ret " + ret.toString());
    return ret;
  }

  static Future<List<Param_Hab>> getParam_Hab_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Hab> paramHablist = await items.map<Param_Hab>((json) {
          return Param_Hab.fromJson(json);
        }).toList();
        return paramHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static Future<bool> Add_Hierarchie(int clientId) async {
    String wSlq = "INSERT INTO Groupes (Groupe_ClientId, Groupe_Depot,Groupe_Code, Groupe_Nom,  Groupe_Adr1, Groupe_Adr2, Groupe_Adr3, Groupe_Adr4, Groupe_CP, Groupe_Ville, Groupe_Pays, Groupe_Acces, Groupe_Rem)     SELECT Adresse_ClientId,Client_Depot,Adresse_Code,Client_Nom,Adresse_Adr1,Adresse_Adr2,Adresse_Adr3,Adresse_Adr4,Adresse_CP,Adresse_Ville,Adresse_Pays,Adresse_Acces,Adresse_Rem FROM Adresses , Clients WHERE Adresse_Type = 'LIVR' AND Adresse_ClientId = ClientId AND Adresse_ClientId = $clientId";
    print("Add_Hierarchie " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("Add_Hierarchie ret " + ret.toString());

    wSlq = "INSERT INTO Sites (Site_GroupeId, Site_Depot,Site_Code, Site_Nom,  Site_Adr1, Site_Adr2, Site_Adr3, Site_Adr4, Site_CP, Site_Ville, Site_Pays, Site_Acces, Site_Rem, Site_ResourceId)     SELECT $gLastID,Client_Depot,Adresse_Code,Client_Nom,Adresse_Adr1,Adresse_Adr2,Adresse_Adr3,Adresse_Adr4,Adresse_CP,Adresse_Ville,Adresse_Pays,Adresse_Acces,Adresse_Rem, ${gClient.Client_Commercial} FROM Adresses , Clients WHERE Adresse_Type = 'LIVR' AND Adresse_ClientId = ClientId AND Adresse_ClientId = $clientId";
    print("Add_Hierarchie " + wSlq);
    ret = await add_API_Post("insert", wSlq);
    print("Add_Hierarchie ret " + ret.toString());

    wSlq = "INSERT INTO Zones (Zone_SiteId, Zone_Depot,Zone_Code, Zone_Nom,  Zone_Adr1, Zone_Adr2, Zone_Adr3, Zone_Adr4, Zone_CP, Zone_Ville, Zone_Pays, Zone_Acces, Zone_Rem)     SELECT $gLastID,Client_Depot,Adresse_Code,Client_Nom,Adresse_Adr1,Adresse_Adr2,Adresse_Adr3,Adresse_Adr4,Adresse_CP,Adresse_Ville,Adresse_Pays,Adresse_Acces,Adresse_Rem FROM Adresses , Clients WHERE Adresse_Type = 'LIVR' AND Adresse_ClientId = ClientId AND Adresse_ClientId = $clientId";
    print("Add_Hierarchie " + wSlq);
    ret = await add_API_Post("insert", wSlq);
    print("Add_Hierarchie ret " + ret.toString());
    return ret;
  }

  static Future<bool> Count_Hierarchie(int clientId) async {
    String wSlq = "SELECT count(*) as count FROM Groupes where Groupe_ClientId = $clientId";
    print("Count Group wSlq $wSlq");
    int wcountGroupes = await getCount_API_Post("select", wSlq);
    print("Count wCount_Groupes $wcountGroupes");

    wSlq = "SELECT count(Sites.SiteId) as count FROM Groupes , Sites where Site_GroupeId = GroupeId AND Groupe_ClientId = $clientId";
    print("Count Sites wSlq $wSlq");
    int wcountSites = await getCount_API_Post("select", wSlq);
    print("Count wCount_Sites $wcountSites");

    wSlq = "SELECT count(Zones.ZoneId) as count FROM Groupes , Sites, Zones where Site_GroupeId = GroupeId AND Zone_SiteId = SiteId AND Groupe_ClientId = $clientId";
    print("Count Zones wSlq $wSlq");
    int wcountZones = await getCount_API_Post("select", wSlq);
    print("Count wCount_Zones $wcountZones");

    if (wcountGroupes + wcountSites + wcountZones > 0) return true;
    return false;
  }

  static Future<int> getCount_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      print("items $items");
      if (items != null) {
        print("item ${items[0]}");
        final wCount = items[0]['count'];
        if (wCount != null) {
          return int.parse(wCount);
        }
      }
    } else {
      print(response.reasonPhrase);
    }
    return -1;
  }

  //*****************************
  //*****************************
  //*****************************

  static String gDepot = Client.ClientInit();

  static List<Client> ListClient = [];
  static List<Client> ListClientsearchresult = [];
  static Client gClient = Client.ClientInit();

  //*****************************
  //*****************************
  //*****************************

  static List<Client> ListClient_CSIP = [];
  static List<Client> ListClient_CSIP_Total = [];

  static Future<bool> getClient_User_CSIP(int wUserID) async {

    DbTools.ListClient_CSIP_Total.clear();
    await DbTools.getClient_User_C(wUserID);
    DbTools.ListClient_CSIP.forEach((wClient) {
      wClient.Adresse_Adr1 = "C";
      DbTools.ListClient_CSIP_Total.add(wClient);
    });


    await DbTools.getClient_User_S(wUserID);
    DbTools.ListClient_CSIP.forEach((wClient) {
      wClient.Adresse_Adr1 = "S";
      DbTools.ListClient_CSIP_Total.add(wClient);
    });

    await DbTools.getClient_User_I(wUserID);
    DbTools.ListClient_CSIP.forEach((wClient) {
      wClient.Adresse_Adr1 = "I";
      DbTools.ListClient_CSIP_Total.add(wClient);
    });

    await DbTools.getClient_User_I2(wUserID);
    DbTools.ListClient_CSIP.forEach((wClient) {
      wClient.Adresse_Adr1 = "I2";
      DbTools.ListClient_CSIP_Total.add(wClient);
    });

    await DbTools.getClient_User_P(wUserID);
    DbTools.ListClient_CSIP.forEach((wClient) {
      wClient.Adresse_Adr1 = "P";
      DbTools.ListClient_CSIP_Total.add(wClient);
    });

    return false;

  }
/*

  SELECT Clients.* FROM Clients Where Clients.Client_Commercial = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId AND Sites.Site_ResourceId = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable2 = 11
  UNION
  SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions, Planning where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Planning.Planning_InterventionId = Interventions.InterventionId AND Planning.Planning_ResourceId = 11;
*/

  static Future<bool> getClient_User_C(int wUserID) async {
    String wSlq = "SELECT Clients.* FROM Clients Where Clients.Client_Commercial = $wUserID";
    //print("getClient_User_C ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_C ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_C return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_S(int wUserID) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId AND Sites.Site_ResourceId = $wUserID";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_I(int wUserID) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable = $wUserID";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_I2(int wUserID) async {
    String wSlq = "SELECT Clients.* FROM Clients, Groupes, Sites, Zones, Interventions where Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Interventions.Intervention_Responsable2 = $wUserID";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient_User_P(int wUserID) async {
    String wSlq = "SELECT Clients.*, Planning_ResourceId FROM Clients, Groupes, Sites, Zones, Interventions, Planning where  Groupe_ClientId = ClientId And Site_GroupeId = GroupeId And Zones.Zone_SiteId = Sites.SiteId AND Interventions.Intervention_ZoneId = Zones.ZoneId AND Planning.Planning_InterventionId = Interventions.InterventionId AND Planning.Planning_ResourceId = $wUserID";
    //print("getClient_User_S ${wSlq}");
    ListClient_CSIP = await getClient_CSIP_API_Post("select", wSlq);
    if (ListClient_CSIP == null) return false;
    //print("getClient_User_S ${ListClient_CSIP.length}");
    if (ListClient_CSIP.length > 0) {
      //print("getClient_User_S return TRUE");
      return true;
    }
    return false;
  }


  //*****************************
  //*****************************
  //*****************************



  static Future<bool> getClientAll() async {
 //   String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT' ORDER BY Client_Nom;";
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays, CONCAT(Users.User_Nom, ' ' , Users.User_Prenom) as Users_Nom FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT' JOIN Users ON Clients.Client_Commercial = Users.UserID ORDER BY Client_Nom;";

    print("getClientAll wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);

    if (ListClient == null) return false;
    print("getClientAll ${ListClient.length}");
    if (ListClient.length > 0) {
      print("getClientAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClientDepot() async {
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT'  WHERE Clients.Client_Depot = '$gDepot'  ORDER BY Client_Nom;";
    print("getClientDepot wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);

    if (ListClient == null) return false;
    print("getClientDepot ${ListClient.length}");
    if (ListClient.length > 0) {
      print("getClientDepot return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getClient(String Id) async {
//    String wSlq = "SELECT * FROM Clients Where ClientId = '${Id}'";
    String wSlq = "SELECT Clients.*, Adresse_Adr1, Adresse_CP,Adresse_Ville,Adresse_Pays FROM Clients LEFT JOIN Adresses ON Clients.ClientId = Adresses.Adresse_ClientId AND Adresses.Adresse_Type = 'FACT' WHERE ClientId = '$Id' ORDER BY Client_Nom;";

    print("getClient wSlq $wSlq");
    ListClient = await getClient_API_Post("select", wSlq);

    if (ListClient == null) return false;
    print("getClient ${ListClient.length}");
    if (ListClient.length > 0) {
      gClient = ListClient[0];
      return true;
    }
    return false;
  }

  static Future<bool> setClient(Client Client) async {
    String wSlq = "UPDATE Clients SET "
            "Client_CodeGC = \"${Client.Client_CodeGC}\", " +
        "Client_CL_Pr = ${Client.Client_CL_Pr}, " +
        "Client_Famille = \"${Client.Client_Famille}\", " +

        "Client_Rglt = \"${Client.Client_Rglt}\", " +

        "Client_Depot = \"${Client.Client_Depot}\", " +
        "Client_PersPhys = ${Client.Client_PersPhys}, " +
        "Client_OK_DataPerso = ${Client.Client_OK_DataPerso}, " +
        "Client_Civilite   = \"${Client.Client_Civilite}\", " +
        "Client_Nom        = \"${Client.Client_Nom}\", " +
        "Client_Siret      = \"${Client.Client_Siret}\", " +
        "Client_NAF        = \"${Client.Client_NAF}\", " +
        "Client_TVA        = \"${Client.Client_TVA}\", " +
        "Client_Commercial = \"${Client.Client_Commercial}\", " +
        "Client_Createur    = \"${Client.Client_Createur}\", " +
        "Client_Contrat      = ${Client.Client_Contrat}, " +
        "Client_TypeContrat      = \"${Client.Client_TypeContrat}\", " +
        "Client_Ct_Debut      = \"${Client.Client_Ct_Debut}\", " +
        "Client_Ct_Fin      = \"${Client.Client_Ct_Fin}\", " +
        "Client_Organes      = \"${Client.Client_Organes}\" " +
        "WHERE ClientId = ${Client.ClientId.toString()}";
    gColors.printWrapped("setClient " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setClient ret " + ret.toString());
    return ret;
  }

  static Future<bool> addClient(Client Client) async {
    String wValue = "NULL,'???'";
    String wSlq = "INSERT INTO Clients (ClientId, Client_Nom) VALUES ($wValue)";
    print("addClient " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addClient ret " + ret.toString());
    return ret;
  }

  static Future<bool> delClient(Client Client) async {
    String aSQL = "DELETE FROM Clients WHERE ClientId = ${Client.ClientId} ";
    print("delClient " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delClient ret " + ret.toString());
    return ret;
  }

  static Future<List<Client>> getClient_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Client> ClientList = await items.map<Client>((json) {
          return Client.fromJson(json);
        }).toList();
        return ClientList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<List<Client>> getClient_CSIP_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("getClient_CSIP_API_Post response ${response.statusCode}");
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      if (items != null) {
        List<Client> ClientList = await items.map<Client>((json) {
          return Client.fromJson_CSIP(json);
        }).toList();
        return ClientList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }



  //*****************************
  //*****************************
  //*****************************

  static List<Adresse> ListAdresse = [];
  static List<Adresse> ListAdressesearchresult = [];
  static Adresse gAdresse = Adresse.AdresseInit();
  static Adresse gAdresseLivr = Adresse.AdresseInit();

  static Future<bool> getAdresseAll() async {
    ListAdresse = await getAdresse_API_Post("select", "select * from Adresses ORDER BY Adresse_Type");

    if (ListAdresse == null) return false;
    print("getAdresseAll ${ListAdresse.length}");
    if (ListAdresse.length > 0) {
      print("getAdresseAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getAdresseID(int ID) async {
    ListAdresse.forEach((element) {
      if (element.AdresseId == ID) {
        gAdresse = element;
        return;
      }
    });
  }

  static Future<bool> getAdresseClientType(int ClientID, String Type) async {
    String wSlq = "select * from Adresses  where Adresse_ClientId = $ClientID AND Adresse_Type = '$Type' ORDER BY Adresse_Type";
    print("getAdresseClientType  Type $Type SQL ${wSlq}");

    ListAdresse = await getAdresse_API_Post("select", wSlq);

    if (ListAdresse == null) return false;
    //  print("getAdresseClientType ${ListAdresse.length}");
    if (ListAdresse.length > 0) {
      gAdresse = ListAdresse[0];
//      print("getAdresseClientType return TRUE");
      return true;
    } else {
      print("getAdresseClientType  Type $Type addAdresse >");
      await addAdresse(ClientID, Type);
      print("getAdresseClientType  Type $Type addAdresse <");
      await getAdresseClientType(ClientID, Type);
      print("getAdresseClientType  Type $Type addAdresse <<<");
    }
    return false;
  }

  static Future<bool> getAdresseType(String Type) async {
    String wSlq = "select * from Adresses  where  Adresse_Type = '$Type' ORDER BY Adresse_Type";
//    print("getAdresseClientType SQL ${wSlq}");

    ListAdresse = await getAdresse_API_Post("select", wSlq);

    if (ListAdresse == null) return false;
    //  print("getAdresseClientType ${ListAdresse.length}");
    if (ListAdresse.length > 0) {
      gAdresse = ListAdresse[0];
//      print("getAdresseClientType return TRUE");
      return true;
    }

    return false;
  }



  static Future<bool> getAdresseClient(int ClientID) async {
    String wSlq = "select * from Adresses  where Adresse_ClientId = $ClientID  ORDER BY Adresse_Type,Adresse_Adr1";
    print("getAdresseClientType SQL $wSlq");

    ListAdresse = await getAdresse_API_Post("select", wSlq);

    if (ListAdresse == null) return false;
    //  print("getAdresseClientType ${ListAdresse.length}");
    if (ListAdresse.length > 0) {
      gAdresse = ListAdresse[0];
//      print("getAdresseClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future<bool> setAdresse(Adresse Adresse) async {
    String wSlq = "UPDATE Adresses SET "
            "Adresse_ClientId     =   ${Adresse.Adresse_ClientId}, " +
        "Adresse_Code      = \"${Adresse.Adresse_Code}\", " +
        "Adresse_Type      = \"${Adresse.Adresse_Type}\", " +
        "Adresse_Nom      = \"${Adresse.Adresse_Nom}\", " +
        "Adresse_Adr1      = \"${Adresse.Adresse_Adr1}\", " +
        "Adresse_Adr2      = \"${Adresse.Adresse_Adr2}\", " +
        "Adresse_Adr3      = \"${Adresse.Adresse_Adr3}\", " +
        "Adresse_Adr4      = \"${Adresse.Adresse_Adr4}\", " +
        "Adresse_CP        = \"${Adresse.Adresse_CP}\", " +
        "Adresse_Ville     = \"${Adresse.Adresse_Ville}\", " +
        "Adresse_Pays      = \"${Adresse.Adresse_Pays}\", " +
        "Adresse_Acces      = \"${Adresse.Adresse_Acces}\", " +
        "Adresse_Rem       = \"${Adresse.Adresse_Rem}\" " +
        "WHERE AdresseId      = ${Adresse.AdresseId.toString()}";
    gColors.printWrapped("setAdresse " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setAdresse ret " + ret.toString());
    return ret;
  }

  static Future<bool> addAdresse(int adresseClientid, String Type) async {
    print("addAdresse Type ${Type}");
    String wValue = "NULL, $adresseClientid, '$Type'";
    String wSlq = "INSERT INTO Adresses (AdresseId, Adresse_ClientId, Adresse_Type) VALUES ($wValue)";
    print("addAdresse " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addAdresse ret " + ret.toString());
    return ret;
  }

  static Future<bool> addGroupeAdresse() async {
    String wSlq = " INSERT IGNORE INTO Groupes ( Groupe_ClientId, Groupe_Code,  Groupe_Nom, Groupe_Adr1, Groupe_Adr2, Groupe_Adr3, Groupe_CP, Groupe_Ville, Groupe_Pays, Groupe_Rem) SELECT AdresseId,  Adresse_Code, Adresse_Nom, Adresse_Adr1, Adresse_Adr2, Adresse_Adr3, Adresse_CP, Adresse_Ville, Adresse_Pays, Adresse_Rem FROM Adresses Where Adresse_Type = 'SITE'";
    print("addGroupeAdresse " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addGroupeAdresse ret " + ret.toString());
    return ret;
  }

  static Future<bool> addSitesAdresse() async {
    String wSlq = " INSERT IGNORE INTO Sites ( Site_AdresseId, Site_Code,  Site_Nom, Site_Adr1, Site_Adr2, Site_Adr3, Site_CP, Site_Ville, Site_Pays, Site_Rem) SELECT AdresseId,  Adresse_Code, Adresse_Nom, Adresse_Adr1, Adresse_Adr2, Adresse_Adr3, Adresse_CP, Adresse_Ville, Adresse_Pays, Adresse_Rem FROM Adresses Where Adresse_Type = 'SITE'";
    print("addSiteAdresse " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addSiteAdresse ret " + ret.toString());
    return ret;
  }

  static Future<bool> delAdresse(Adresse Adresse) async {
    String aSQL = "DELETE FROM Adresses WHERE AdresseId = ${Adresse.AdresseId} ";
    print("delAdresse " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delAdresse ret " + ret.toString());
    return ret;
  }

  static Future<List<Adresse>> getAdresse_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Adresse> AdresseList = await items.map<Adresse>((json) {
          return Adresse.fromJson(json);
        }).toList();
        return AdresseList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   GROUPES   *****************
  //******************************************

  static List<Groupe> ListGroupe = [];
  static List<Groupe> ListGroupesearchresult = [];
  static Groupe gGroupe = Groupe.GroupeInit();

  static Future<bool> getGroupeAll() async {
    ListGroupe = await getGroupe_API_Post("select", "select * from Groupes ORDER BY Groupe_Nom");

    if (ListGroupe == null) return false;
    print("getGroupeAll ${ListGroupe.length}");
    if (ListGroupe.length > 0) {
      print("getGroupeAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getGroupesClient(int ID) async {
    String wTmp = "select * from Groupes WHERE Groupe_ClientId = $ID ORDER BY Groupe_Nom";

//    print("wTmp getGroupesClient ${wTmp}");
    ListGroupe = await getGroupe_API_Post("select", wTmp);

    if (ListGroupe == null) return false;
//    print("getGroupesClient ${ListGroupe.length}");
    if (ListGroupe.length > 0) {
      DbTools.gGroupe = ListGroupe[0];
      //    print("getGroupesClient return TRUE");
      return true;
    }
    return false;
  }

  static Future getGroupeID(int ID) async {
    ListGroupe.forEach((element) {
      if (element.GroupeId == ID) {
        gGroupe = element;
        return;
      }
    });
  }

  static Future<bool> setGroupe(Groupe Groupe) async {
    String wSlq = "UPDATE Groupes SET "
            "Groupe_ClientId     =   ${Groupe.Groupe_ClientId}, " +
        "Groupe_Code      = \"${Groupe.Groupe_Code}\", " +
        "Groupe_Depot      = \"${Groupe.Groupe_Depot}\", " +
        "Groupe_Nom      = \"${Groupe.Groupe_Nom}\", " +
        "Groupe_Adr1      = \"${Groupe.Groupe_Adr1}\", " +
        "Groupe_Adr2      = \"${Groupe.Groupe_Adr2}\", " +
        "Groupe_Adr3      = \"${Groupe.Groupe_Adr3}\", " +
        "Groupe_Adr4      = \"${Groupe.Groupe_Adr4}\", " +
        "Groupe_CP        = \"${Groupe.Groupe_CP}\", " +
        "Groupe_Ville     = \"${Groupe.Groupe_Ville}\", " +
        "Groupe_Pays      = \"${Groupe.Groupe_Pays}\", " +
        "Groupe_Acces      = \"${Groupe.Groupe_Acces}\", " +
        "Groupe_Rem       = \"${Groupe.Groupe_Rem}\" " +
        "WHERE GroupeId      = ${Groupe.GroupeId.toString()}";
    gColors.printWrapped("setGroupe " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setGroupe ret " + ret.toString());
    return ret;
  }

  static Future<bool> addGroupe(int groupeClientid, String Type) async {
    String wValue = "NULL, $groupeClientid";
    String wSlq = "INSERT INTO Groupes (GroupeId, Groupe_ClientId) VALUES ($wValue)";
    print("addGroupe " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addGroupe ret " + ret.toString());
    return ret;
  }

  static Future<bool> delGroupe(Groupe groupe) async {
    String aSQL = "DELETE FROM Groupes WHERE GroupeId = ${groupe.GroupeId} ";
    print("delGroupe " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delGroupe ret " + ret.toString());
    return ret;
  }

  static Future<List<Groupe>> getGroupe_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    print("getGroupe_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      print("getGroupe_API_Post parsedJson $parsedJson");
      final items = parsedJson['data'];

      if (items != null) {
        List<Groupe> GroupeList = await items.map<Groupe>((json) {
          return Groupe.fromJson(json);
        }).toList();

        return GroupeList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   SITES   *****************
  //******************************************

  static List<Site> ListSite = [];
  static List<Site> ListSitesearchresult = [];
  static Site gSite = Site.SiteInit();

  static Future<bool> getSiteAll() async {
    ListSite = await getSite_API_Post("select", "select * from Sites ORDER BY Site_Nom");

    if (ListSite == null) return false;
    print("getSiteAll ${ListSite.length}");
    if (ListSite.length > 0) {
      print("getSiteAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getSitesGroupe(int ID) async {
    String wTmp = "select * from Sites WHERE Site_GroupeId = $ID ORDER BY Site_Nom";

//    print("wTmp getSitesSite ${wTmp}");
    ListSite = await getSite_API_Post("select", wTmp);

    if (ListSite == null) return false;
//    print("getSitesSite ${ListSite.length}");
    if (ListSite.length > 0) {
      //    print("getSitesSite return TRUE");
      return true;
    }
    return false;
  }

  static Future getSiteID(int ID) async {
    ListSite.forEach((element) {
      if (element.SiteId == ID) {
        gSite = element;
        return;
      }
    });
  }

  static Future<bool> setSite(Site Site) async {
    String wSlq = "UPDATE Sites SET "
            "Site_GroupeId     =   ${Site.Site_GroupeId}, " +
        "Site_Code      = \"${Site.Site_Code}\", " +
        "Site_Depot      = \"${Site.Site_Depot}\", " +
        "Site_Nom      = \"${Site.Site_Nom}\", " +
        "Site_Adr1      = \"${Site.Site_Adr1}\", " +
        "Site_Adr2      = \"${Site.Site_Adr2}\", " +
        "Site_Adr3      = \"${Site.Site_Adr3}\", " +
        "Site_Adr4      = \"${Site.Site_Adr4}\", " +
        "Site_CP        = \"${Site.Site_CP}\", " +
        "Site_Ville     = \"${Site.Site_Ville}\", " +
        "Site_Pays      = \"${Site.Site_Pays}\", " +
        "Site_Acces     = \"${Site.Site_Acces}\", " +
        "Site_RT        = \"${Site.Site_RT}\", " +
        "Site_APSAD     = \"${Site.Site_APSAD}\", " +
        "Site_ResourceId     =   ${Site.Site_ResourceId}, " +
        "Site_Rem       = \"${Site.Site_Rem}\" " +
        "WHERE SiteId   = ${Site.SiteId.toString()}";
    gColors.printWrapped("setSite " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setSite ret " + ret.toString());
    return ret;
  }

  static Future<bool> addSite(int siteGroupeid) async {
    String wValue = "NULL, $siteGroupeid";
    String wSlq = "INSERT INTO Sites (SiteId, Site_GroupeId) VALUES ($wValue)";
    print("addSite " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addSite ret " + ret.toString());
    return ret;
  }

  static Future<bool> delSite(Site site) async {
    String aSQL = "DELETE FROM Sites WHERE SiteId = ${site.SiteId} ";
    print("delSite " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delSite ret " + ret.toString());
    return ret;
  }

  static Future<List<Site>> getSite_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

//    print("getSite_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //  print("getSite_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Site> SiteList = await items.map<Site>((json) {
          return Site.fromJson(json);
        }).toList();
        return SiteList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   ZONES   *****************
  //******************************************

  static List<Zone> ListZone = [];
  static List<Zone> ListZonesearchresult = [];
  static Zone gZone = Zone.ZoneInit();

  static Future<bool> getZoneAll() async {
    ListZone = await getZone_API_Post("select", "select * from Zones ORDER BY Zone_Nom");

    if (ListZone == null) return false;
    print("getZoneAll ${ListZone.length}");
    if (ListZone.length > 0) {
      print("getZoneAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getZonesSite(int ID) async {
    String wTmp = "select * from Zones WHERE Zone_SiteId = $ID ORDER BY Zone_Nom";

//    print("wTmp getZonesClient ${wTmp}");
    ListZone = await getZone_API_Post("select", wTmp);

    if (ListZone == null) return false;
//    print("getZonesClient ${ListZone.length}");
    if (ListZone.length > 0) {
      gZone = ListZone[0];
      //    print("getZonesClient return TRUE");
      return true;
    }
    return false;
  }

  static Future getZoneID(int ID) async {
    ListZone.forEach((element) {
      if (element.ZoneId == ID) {
        gZone = element;
        return;
      }
    });
  }

  static Future<bool> setZone(Zone Zone) async {
    String wSlq = "UPDATE Zones SET "
            "Zone_SiteId     =   ${Zone.Zone_SiteId}, " +
        "Zone_Code      = \"${Zone.Zone_Code}\", " +
        "Zone_Depot      = \"${Zone.Zone_Depot}\", " +
        "Zone_Nom      = \"${Zone.Zone_Nom}\", " +
        "Zone_Adr1      = \"${Zone.Zone_Adr1}\", " +
        "Zone_Adr2      = \"${Zone.Zone_Adr2}\", " +
        "Zone_Adr3      = \"${Zone.Zone_Adr3}\", " +
        "Zone_Adr4      = \"${Zone.Zone_Adr4}\", " +
        "Zone_CP        = \"${Zone.Zone_CP}\", " +
        "Zone_Ville     = \"${Zone.Zone_Ville}\", " +
        "Zone_Pays      = \"${Zone.Zone_Pays}\", " +
        "Zone_Acces      = \"${Zone.Zone_Acces}\", " +
        "Zone_Rem       = \"${Zone.Zone_Rem}\" " +
        "WHERE ZoneId      = ${Zone.ZoneId.toString()}";
    gColors.printWrapped("setZone " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setZone ret " + ret.toString());
    return ret;
  }

  static Future<bool> addZone(int zoneSiteid) async {
    String wValue = "NULL, $zoneSiteid";
    String wSlq = "INSERT INTO Zones (ZoneId, Zone_SiteId) VALUES ($wValue)";
    print("addZone " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addZone ret " + ret.toString());
    return ret;
  }

  static Future<bool> delZone(Zone zone) async {
    String aSQL = "DELETE FROM Zones WHERE ZoneId = ${zone.ZoneId} ";
    print("delZone " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delZone ret " + ret.toString());
    return ret;
  }

  static Future<List<Zone>> getZone_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

//    print("getZone_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //  print("getZone_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Zone> ZoneList = await items.map<Zone>((json) {
          return Zone.fromJson(json);
        }).toList();
        return ZoneList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   INTERVENTIONS   ***********
  //******************************************

  static List<Intervention> ListIntervention = [];
  static List<Intervention> ListInterventionsearchresult = [];
  static Intervention gIntervention = Intervention.InterventionInit();

  static int affSortComparisonData(Intervention a, Intervention b) {
    final wInterventionDateA = a.Intervention_Date;
    final wInterventionDateB = b.Intervention_Date;

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wInterventionDateA!);
    var inputDateB = inputFormat.parse(wInterventionDateB!);

    if (inputDateA.isBefore(inputDateB)) {
      return 1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return -1;
    } else {
      return 0;
    }
  }

  static Future<bool> getInterventionAll() async {
    ListIntervention = await getIntervention_API_Post("select", "select * from Interventions ORDER BY Intervention_Nom");
    if (ListIntervention == null) return false;
    print("getInterventionAll ${ListIntervention.length}");
    if (ListIntervention.length > 0) {
      print("getInterventionAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getInterventionsZone(int ID) async {
    String wTmp = "SELECT a.*, IFNULL(c.Cnt,0) as Cnt FROM Interventions a LEFT JOIN (SELECT Parcs_InterventionId, count(1) Cnt FROM Parcs_Ent GROUP BY Parcs_InterventionId) as c ON c.Parcs_InterventionId=a.InterventionId WHERE Intervention_ZoneId = $ID ORDER BY 1;";
    print("wTmp $wTmp");

    ListIntervention = await getIntervention_API_Post("select", wTmp);

    if (ListIntervention == null) return false;
    //  print("getInterventionsSite ${ListIntervention.length}");
    if (ListIntervention.length > 0) {
      //  print("getInterventionsSite return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getInterventionIDSrv(int ID) async {
    ListIntervention = await getIntervention_API_Post("select", "select * from Interventions WHERE InterventionId = $ID");
    if (ListIntervention == null) return false;
    print("getInterventionAll ${ListIntervention.length}");
    if (ListIntervention.length > 0) {
      gIntervention = ListIntervention[0];
      print("getInterventionAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getInterventionID(int ID) async {
    ListIntervention.forEach((element) {
      if (element.InterventionId == ID) {
        print("getInterventionID ret " + element.Desc());

        gIntervention = element;
        return;
      }
    });
  }

  static Future<bool> setIntervention(Intervention Intervention) async {
    String wSlq = "UPDATE Interventions SET "
            "InterventionId     =   ${Intervention.InterventionId}, " +
        "Intervention_ZoneId      = \"${Intervention.Intervention_ZoneId}\", " +
        "Intervention_Date      = \"${Intervention.Intervention_Date}\", " +
        "Intervention_Type      = \"${Intervention.Intervention_Type}\", " +
        "Intervention_Parcs_Type             = \"${Intervention.Intervention_Parcs_Type}\", " +
        "Intervention_Status                 = \"${Intervention.Intervention_Status}\", " +
        "Intervention_Histo_Status           = \"${Intervention.Intervention_Histo_Status}\", " +
        "Intervention_Facturation            = \"${Intervention.Intervention_Facturation}\", " +
        "Intervention_Histo_Facturation      = \"${Intervention.Intervention_Histo_Facturation}\", " +
        "Intervention_Responsable            = \"${Intervention.Intervention_Responsable}\", " +
        "Intervention_Responsable2            = \"${Intervention.Intervention_Responsable2}\", " +
        "Intervention_Intervenants           = \"${Intervention.Intervention_Intervenants}\", " +
        "Intervention_Reglementation         = \"${Intervention.Intervention_Reglementation}\", " +
        "Intervention_Signataire_Client      = \"${Intervention.Intervention_Signataire_Client}\", " +
        "Intervention_Signataire_Tech        = \"${Intervention.Intervention_Signataire_Tech}\", " +
        "Intervention_Signataire_Date        = \"${Intervention.Intervention_Signataire_Date}\", " +
        "Intervention_Remarque      = \"${Intervention.Intervention_Remarque}\" " +
        "WHERE InterventionId      = ${Intervention.InterventionId.toString()}";
    gColors.printWrapped("setIntervention " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setIntervention ret " + ret.toString());
    return ret;
  }

  static Future<bool> addIntervention(int interventionZoneid, String Date, String Verif) async {
    String wValue = "NULL, $interventionZoneid, '$Date' , '$Verif', '', ${gSite.Site_ResourceId} ";
    String wSlq = "INSERT INTO Interventions (InterventionId, Intervention_ZoneId, Intervention_Date, Intervention_Type, Intervention_Remarque, Intervention_Responsable) VALUES ($wValue)";
    print("addIntervention " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addIntervention ret " + ret.toString());
    return ret;
  }

  static Future<bool> delIntervention(Intervention Intervention) async {
    String aSQL = "DELETE FROM Interventions WHERE InterventionId = ${Intervention.InterventionId} ";
    print("delIntervention " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delIntervention ret " + ret.toString());
    return ret;
  }

  static Future<List<Intervention>> getIntervention_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

//    print("getIntervention_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //  print("getIntervention_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Intervention> InterventionList = await items.map<Intervention>((json) {
          return Intervention.fromJson(json);
        }).toList();
        return InterventionList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*************************************
  //************   PLANNING   ***********
  //*************************************

  static List<Planning_Srv> ListPlanning = [];
  static Planning_Srv gPlanning = Planning_Srv.Planning_RdvInit();

  static List<UserH> ListUserH = [];

  static Future getPlanning_All() async {
    ListPlanning = await getPlanning_API_Post("select", "select * from Planning");
    if (ListPlanning == null) return false;
    if (ListPlanning.length > 0) {
      return true;
    }
    return false;
  }

  static Future getPlanning_InterventionId(int InterventionId) async {
    ListPlanning = await getPlanning_API_Post("select", "select * from Planning where Planning_InterventionId = $InterventionId");
    if (ListPlanning == null) return false;
    if (ListPlanning.length > 0) {
      return true;
    }
    return false;
  }

  static Future getPlanning_InterventionIdRes(int InterventionId) async {
    ListUserH = await getPlanningH_API_Post("select", "SELECT Users.User_Nom , Users.User_Prenom, SUM(TIMEDIFF( Planning.Planning_InterventionendTime,Planning.Planning_InterventionstartTime) / 10000) as H FROM Planning , Users where `Planning_ResourceId` = Users.UserID AND   Planning_InterventionId = $InterventionId GROUP BY Planning.Planning_ResourceId ORDER BY H DESC;");
    if (ListUserH == null) return false;
    if (ListUserH.length > 0) {
      return true;
    }
    return false;
  }

  static Future getPlanning_ResourceId(int ResourceId) async {
    ListPlanning = await getPlanning_API_Post("select", "select * from Planning where Planning_ResourceId = $ResourceId");
    if (ListPlanning == null) return false;
    if (ListPlanning.length > 0) {
      return true;
    }
    return false;
  }

  static Future<bool> setPlanning(Planning_Srv planning) async {
    String wSlq = "UPDATE Planning SET "
        "Planning_Libelle = '${planning.Planning_Libelle}', "
        "Planning_ResourceId = '${planning.Planning_ResourceId}', "
        "Planning_InterventionstartTime = '${planning.Planning_InterventionstartTime}', "
        "Planning_InterventionendTime = '${planning.Planning_InterventionendTime}' "
        "WHERE PlanningId = ${planning.PlanningId}";

    gColors.printWrapped("setPlanning " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setPlanning ret " + ret.toString());
    return ret;
  }

  static Future<bool> addPlanning(Planning_Srv Planning) async {
    String wValue = "NULL, ${Planning.Planning_InterventionId}, ${Planning.Planning_ResourceId} , '${Planning.Planning_InterventionstartTime}', '${Planning.Planning_InterventionendTime}' , '${Planning.Planning_Libelle}'";
    String wSlq = "INSERT INTO Planning (PlanningId, Planning_InterventionId, Planning_ResourceId, Planning_InterventionstartTime, Planning_InterventionendTime, Planning_Libelle) VALUES ($wValue)";
    print("addPlanning " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addPlanning ret " + ret.toString());
    return ret;
  }

  static Future<bool> delPlanning(Planning_Srv Planning) async {
    String aSQL = "DELETE FROM Planning WHERE PlanningId = ${Planning.PlanningId} ";
    print("delPlanning " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delPlanning ret " + ret.toString());
    return ret;
  }

  static Future<List<Planning_Srv>> getPlanning_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    print("getIntervention_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getIntervention_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Planning_Srv> PlanningList = await items.map<Planning_Srv>((json) {
          return Planning_Srv.fromJson(json);
        }).toList();

        print("Planning length ${PlanningList.length}");

        return PlanningList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  static Future<List<UserH>> getPlanningH_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    print("getPlanningH_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getPlanningH_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<UserH> ListUserH = await items.map<UserH>((json) {
          return UserH.fromJson(json);
        }).toList();

        print("getPlanningH_API_Post length ${ListUserH.length}");

        return ListUserH;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
  //***************************************************
  //************   PLANNING INTERVENTIONS   ***********
  //***************************************************

  static List<Planning_Interv> ListPlanning_Interv = [];
  static Planning_Interv gPlanning_Interv = Planning_Interv.Planning_RdvInit();

  /*
  SELECT InterventionId,Intervention_Type,Intervention_Parcs_Type,Intervention_Status,
      ZoneId, Zone_Nom, SiteId, Site_Nom, GroupeId, Groupe_Nom, ClientId, Client_Nom
  FROM Interventions, Zones, Sites, Groupes, Clients
  WHERE Intervention_ZoneId = ZoneId
  AND Zone_SiteId = SiteId
  AND Site_GroupeId = GroupeId
  AND Groupe_ClientId = ClientId
  AND InterventionId = 20

*/

  static Future getPlanning_IntervAll() async {
    String wTmp = "SELECT InterventionId,Intervention_Type,Intervention_Parcs_Type,Intervention_Status, ZoneId, Zone_Nom, SiteId, Site_Nom, GroupeId, Groupe_Nom, ClientId, Client_Nom FROM Interventions, Zones, Sites, Groupes, Clients WHERE Intervention_ZoneId = ZoneId AND Zone_SiteId = SiteId AND Site_GroupeId = GroupeId AND Groupe_ClientId = ClientId ORDER BY InterventionId DESC";
    print("wTmp $wTmp");

    ListPlanning_Interv = await getPlanning_Interv_API_Post("select", wTmp);

    if (ListPlanning_Interv == null) return false;
    if (ListPlanning_Interv.length > 0) {
      return true;
    }
    return false;
  }

  static Future getPlanning_IntervID(int ID) async {
    String wTmp = "SELECT InterventionId,Intervention_Type,Intervention_Parcs_Type,Intervention_Status, ZoneId, Zone_Nom, SiteId, Site_Nom, GroupeId, Groupe_Nom, ClientId, Client_Nom FROM Interventions, Zones, Sites, Groupes, Clients WHERE Intervention_ZoneId = ZoneId AND Zone_SiteId = SiteId AND Site_GroupeId = GroupeId AND Groupe_ClientId = ClientId AND InterventionId = $ID";
    print("wTmp $wTmp");

    ListPlanning_Interv = await getPlanning_Interv_API_Post("select", wTmp);

    if (ListPlanning_Interv == null) return false;
    if (ListPlanning_Interv.length > 0) {
      return true;
    }
    return false;
  }

  static Future getPlanning_Interv_ID(int ID) async {
    ListPlanning_Interv.forEach((element) {
      if (element.Planning_Interv_InterventionId == ID) {
        gPlanning_Interv = element;
        return;
      }
    });
  }

  static Future<List<Planning_Interv>> getPlanning_Interv_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    print("getIntervention_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    print("getIntervention_API_Post response ${response.statusCode}");

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Planning_Interv> planningIntervlist = await items.map<Planning_Interv>((json) {
          return Planning_Interv.fromJson(json);
        }).toList();

        print("Planning_Interv length ${planningIntervlist.length}");

        return planningIntervlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   InterMissionS   ***********
  //******************************************

  static List<InterMission> ListInterMission = [];
  static List<InterMission> ListInterMissionsearchresult = [];
  static InterMission gInterMission = InterMission.InterMissionInit();

  static int affSortComparisonDataIM(InterMission a, InterMission b) {
    final wInterMissionDateA = a.InterMission_Date;
    final wInterMissionDateB = b.InterMission_Date;

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDateA = inputFormat.parse(wInterMissionDateA);
    var inputDateB = inputFormat.parse(wInterMissionDateB);

    if (inputDateA.isBefore(inputDateB)) {
      return 1;
    } else if (inputDateA.isAfter(inputDateB)) {
      return -1;
    } else {
      return 0;
    }
  }

  static Future<bool> getInterMissionAll() async {
    ListInterMission = await getInterMission_API_Post("select", "select * from InterMissions ORDER BY InterMission_Nom");
    if (ListInterMission == null) return false;
    print("getInterMissionAll ${ListInterMission.length}");
    if (ListInterMission.length > 0) {
      print("getInterMissionAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getInterMissionsIntervention(int ID) async {
    String wTmp = "SELECT * FROM InterMissions WHERE InterMission_InterventionId = $ID ORDER BY InterMission_Nom";
    print("wTmp $wTmp");

    ListInterMission = await getInterMission_API_Post("select", wTmp);

    if (ListInterMission == null) return false;
    //  print("getInterMissionsSite ${ListInterMission.length}");
    if (ListInterMission.length > 0) {
      //  print("getInterMissionsSite return TRUE");
      return true;
    }
    return false;
  }

  static Future getInterMissionID(int ID) async {
    ListInterMission.forEach((element) {
      if (element.InterMissionId == ID) {
        gInterMission = element;
        return;
      }
    });
  }

  static Future<bool> setInterMission(InterMission InterMission) async {
    String wSlq = "UPDATE InterMissions SET "
            "InterMissionId     =   ${InterMission.InterMissionId}, " +
        "InterMission_InterventionId      = \"${InterMission.InterMission_InterventionId}\", " +
        "InterMission_Nom      = \"${InterMission.InterMission_Nom}\", " +
        "InterMission_Exec      = ${InterMission.InterMission_Exec}, " +
        "InterMission_Date      = \"${InterMission.InterMission_Date}\", " +
        "InterMission_Note      = \"${InterMission.InterMission_Note}\" " +
        "WHERE InterMissionId      = ${InterMission.InterMissionId.toString()}";
    gColors.printWrapped("setInterMission " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setInterMission ret " + ret.toString());
    return ret;
  }

  static Future<bool> addInterMission(InterMission InterMission) async {
    String wValue = "NULL, ${InterMission.InterMission_InterventionId}, '${InterMission.InterMission_Nom}' , ${InterMission.InterMission_Exec}, '${InterMission.InterMission_Date}' ";
    String wSlq = "INSERT INTO InterMissions (InterMissionId, InterMission_InterventionId, InterMission_Nom, InterMission_Exec, InterMission_Date) VALUES ($wValue)";
    print("addInterMission " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addInterMission ret " + ret.toString());
    return ret;
  }

  static Future<bool> delInterMission(InterMission InterMission) async {
    String aSQL = "DELETE FROM InterMissions WHERE InterMissionId = ${InterMission.InterMissionId} ";
    print("delInterMission " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delInterMission ret " + ret.toString());
    return ret;
  }

  static Future<List<InterMission>> getInterMission_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

//    print("getInterMission_API_Post " + aSQL);

    http.StreamedResponse response = await request.send();
    //  print("getInterMission_API_Post response ${response.statusCode}" );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<InterMission> InterMissionList = await items.map<InterMission>((json) {
          return InterMission.fromJson(json);
        }).toList();
        return InterMissionList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   Parc_Ents   ***************
  //******************************************

  static List<Parc_Ent> ListParc_Ent = [];
  static List<Parc_Ent> ListParc_Entsearchresult = [];
  static Parc_Ent gParc_Ent = Parc_Ent.Parc_EntInit(0, "", 0);

  static Future<bool> getParc_EntAll() async {
    ListParc_Ent = await getParc_Ent_API_Post("select", "select * from Parc_Ent ORDER BY Parcs_Type");

    if (ListParc_Ent == null) return false;
    print("getParc_EntAll ${ListParc_Ent.length}");
    if (ListParc_Ent.length > 0) {
      print("getParc_EntAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_EntID(int ID) async {
    String wSql = "select * from Parcs_Ent WHERE Parcs_InterventionId = $ID ORDER BY Parcs_Type";
    ListParc_Ent = await getParc_Ent_API_Post("select", wSql);

    if (ListParc_Ent == null) return false;
    print("getParc_EntID ${ListParc_Ent.length} $wSql");
    if (ListParc_Ent.length > 0) {
      print("getParc_EntID return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> setParc_Ent(Parc_Ent parcEnt) async {
    String wSlq = "UPDATE Parc_Ents SET "
            "ParcsId     =   ${parcEnt.ParcsId}, " +
        "Parcs_order     =   ${parcEnt.Parcs_order}, " +
        "Parcs_InterventionId = \"${parcEnt.Parcs_InterventionId}\", " +
        "Parcs_Intervention_Timer = \"${parcEnt.Parcs_Intervention_Timer}\", " +
        "Parcs_Type  = \"${parcEnt.Parcs_Type}\", " +
        "Parcs_Date_Rev  = \"${parcEnt.Parcs_Date_Rev}\", " +
        "Parcs_QRCode  = \"${parcEnt.Parcs_QRCode}\", " +
        "Parcs_FREQ_Id  = \"${parcEnt.Parcs_FREQ_Id}\", " +
        "Parcs_FREQ_Label  = \"${parcEnt.Parcs_FREQ_Label}\", " +
        "Parcs_ANN_Id  = \"${parcEnt.Parcs_ANN_Id}\", " +
        "Parcs_ANN_Label  = \"${parcEnt.Parcs_ANN_Label}\", " +
        "Parcs_NIV_Id  = \"${parcEnt.Parcs_NIV_Id}\", " +
        "Parcs_NIV_Label  = \"${parcEnt.Parcs_NIV_Label}\", " +
        "Parcs_ZNE_Id  = \"${parcEnt.Parcs_ZNE_Id}\", " +
        "Parcs_ZNE_Label  = \"${parcEnt.Parcs_ZNE_Label}\", " +
        "Parcs_EMP_Id  = \"${parcEnt.Parcs_EMP_Id}\", " +
        "Parcs_EMP_Label  = \"${parcEnt.Parcs_EMP_Label}\", " +
        "Parcs_LOT_Id  = \"${parcEnt.Parcs_LOT_Id}\", " +
        "Parcs_LOT_Label  = \"${parcEnt.Parcs_LOT_Label}\", " +
        "Parcs_SERIE_Id  = \"${parcEnt.Parcs_SERIE_Id}\", " +
        "Parcs_SERIE_Label  = \"${parcEnt.Parcs_SERIE_Label}\", " +
        "Parcs_Audit_Note  = \"${parcEnt.Parcs_Audit_Note}\", " +
        "Parcs_Verif_Note  = \"${parcEnt.Parcs_Verif_Note}\"";

    gColors.printWrapped("setParc_Ent " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_EntAdrType(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid, ";
    String wSlq = "INSERT INTO Parc_Ents (ParcsId, Parcs_InterventionId, ) VALUES ($wValue)";
    print("addParc_Ent " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Ent(int parcsInterventionid) async {
    String wValue = "NULL, $parcsInterventionid";
    String wSlq = "INSERT INTO Parc_Ents (ParcsId, Parcs_InterventionId) VALUES ($wValue)";
    print("addParc_Ent " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Ent(Parc_Ent parcEnt) async {
    String aSQL = "DELETE FROM Parc_Ents WHERE Parc_EntId = ${parcEnt.ParcsId} ";
    print("delParc_Ent " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Ent ret " + ret.toString());
    return ret;
  }

  static Future<List<Parc_Ent>> getParc_Ent_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Parc_Ent> parcEntlist = await items.map<Parc_Ent>((json) {
          return Parc_Ent.fromJson(json);
        }).toList();
        return parcEntlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //******************************************
  //************   Parc_Descs   ***************
  //******************************************

  static List<Parc_Desc> ListParc_Desc = [];
  static List<Parc_Desc> ListParc_Descsearchresult = [];
  static Parc_Desc gParc_Desc = Parc_Desc.Parc_DescInit(0, "");

  static Future<bool> getParc_DescAll() async {
    ListParc_Desc = await getParc_Desc_API_Post("select", "select * from Parc_Desc ORDER BY ParcsDescId");

    if (ListParc_Desc == null) return false;
    print("getParc_DescAll ${ListParc_Desc.length}");
    if (ListParc_Desc.length > 0) {
      print("getParc_DescAll return TRUE");
      return true;
    }
    return false;
  }

  static Future getParc_DescID(int ID) async {
    String wSql = "SELECT Parcs_Desc.* FROM Parcs_Desc, Parcs_Ent  WHERE ParcsDesc_ParcsId = ParcsId AND Parcs_InterventionId =  $ID ORDER BY Parcs_Type";
    ListParc_Desc = await getParc_Desc_API_Post("select", wSql);

    if (ListParc_Desc == null) return false;
    print("getParc_DescID ${ListParc_Desc.length} $wSql");
    if (ListParc_Desc.length > 0) {
      print("getParc_DescID return TRUE");
      return true;
    }
    return false;
  }

  int? ParcsDescId = 0;
  int? ParcsDesc_ParcsId = 0;
  String? ParcsDesc_Type = "";
  String? ParcsDesc_Id = "";
  String? ParcsDesc_Lib = "";

  static Future<bool> setParc_Desc(Parc_Desc parcDesc) async {
    String wSlq = "UPDATE Parc_Descs SET "
            "ParcsDescId     =   ${parcDesc.ParcsDescId}, " +
        "ParcsDesc_ParcsId     =   ${parcDesc.ParcsDesc_ParcsId}, " +
        "ParcsDesc_Type = \"${parcDesc.ParcsDesc_Type}\", " +
        "ParcsDesc_Id = \"${parcDesc.ParcsDesc_Id}\", " +
        "ParcsDesc_Lib  = \"${parcDesc.ParcsDesc_Lib}\"";

    gColors.printWrapped("setParc_Desc " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_DescAdrType(int parcsdescParcsid) async {
    String wValue = "NULL, $parcsdescParcsid, ";
    String wSlq = "INSERT INTO Parc_Descs (ParcsDescId, ParcsDesc_ParcsId, ) VALUES ($wValue)";
    print("addParc_Desc " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParc_Desc(int parcsdescParcsid) async {
    String wValue = "NULL, $parcsdescParcsid";
    String wSlq = "INSERT INTO Parc_Descs (ParcsDescId, ParcsDesc_ParcsId) VALUES ($wValue)";
    print("addParc_Desc " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParc_Desc(Parc_Desc parcDesc) async {
    String aSQL = "DELETE FROM Parc_Descs WHERE ParcsDescId = ${parcDesc.ParcsDescId} ";
    print("delParc_Desc " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParc_Desc ret " + ret.toString());
    return ret;
  }

  static Future<List<Parc_Desc>> getParc_Desc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Parc_Desc> parcDesclist = await items.map<Parc_Desc>((json) {
          return Parc_Desc.fromJson(json);
        }).toList();
        return parcDesclist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Contact> ListContact = [];
  static List<Contact> ListContactsearchresult = [];
  static Contact gContact = Contact.ContactInit();
  static Contact gContactLivr = Contact.ContactInit();

  static Future<bool> getContactAll() async {
    ListContact = await getContact_API_Post("select", "select * from Contacts ORDER BY Contact_Type");

    if (ListContact == null) return false;
    print("getContactAll ${ListContact.length}");
    if (ListContact.length > 0) {
      print("getContactAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> getContactClientAdrType(int ClientID, int AdresseId, String Type) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $ClientID AND Contact_AdresseId = $AdresseId AND Contact_Type = '$Type' ORDER BY Contact_Type";
    print("getContactClientType $wSlq");

    ListContact = await getContact_API_Post("select", wSlq);

    if (ListContact == null) return false;
    print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      print("getContactClientType return TRUE");
      return true;
    } else {
      await addContactAdrType(ClientID, AdresseId, Type);
      await getContactClientAdrType(ClientID, AdresseId, Type);
    }
    return false;
  }

  static Future<bool> getContactClient(int ClientID) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $ClientID ORDER BY Contact_Type";
//    print("getContactClientType ${wSlq}");

    ListContact = await getContact_API_Post("select", wSlq);

    if (ListContact == null) return false;
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future<bool> getContactSite(int SiteID) async {
    String wSlq = "select * from Contacts  where Contact_AdresseId = $SiteID AND Contact_Type = 'SITE' ORDER BY Contact_Type";

    ListContact = await getContact_API_Post("select", wSlq);

    if (ListContact == null) return false;
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future<bool> getContactGrp(int contactClientid, int contactAdresseid) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $contactClientid AND Contact_AdresseId = $contactAdresseid AND Contact_Type = 'GRP' ORDER BY Contact_Type";

    ListContact = await getContact_API_Post("select", wSlq);

    if (ListContact == null) return false;
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future<bool> getContactType(int contactClientid, int contactAdresseid, String wType) async {
    String wSlq = "select * from Contacts  where Contact_ClientId = $contactClientid AND Contact_AdresseId = $contactAdresseid AND Contact_Type = '$wType' ORDER BY Contact_Type";

    ListContact = await getContact_API_Post("select", wSlq);

    if (ListContact == null) return false;
    //  print("getContactClientType ${ListContact.length}");
    if (ListContact.length > 0) {
      gContact = ListContact[0];
      //  print("getContactClientType return TRUE");
      return true;
    } else {}
    return false;
  }

  static Future getContactID(int ID) async {
    for (int i = 0; i < ListContact.length; i++) {
      var element = ListContact[i];

      if (element.ContactId == ID) {
        gContact = element;
        return;
      }
    }
  }

  static Future<bool> setContact(Contact Contact) async {
    String wSlq = "UPDATE Contacts SET "
            "Contact_ClientId     =   ${Contact.Contact_ClientId}, " +
        "Contact_AdresseId     =   ${Contact.Contact_AdresseId}, " +
        "Contact_Code             = \"${Contact.Contact_Code}\", " +
        "Contact_Type             = \"${Contact.Contact_Type}\", " +
        "Contact_Civilite         = \"${Contact.Contact_Civilite}\", " +
        "Contact_Prenom           = \"${Contact.Contact_Prenom}\", " +
        "Contact_Nom              = \"${Contact.Contact_Nom}\", " +
        "Contact_Fonction         = \"${Contact.Contact_Fonction}\", " +
        "Contact_Service          = \"${Contact.Contact_Service}\", " +
        "Contact_Tel1             = \"${Contact.Contact_Tel1}\", " +
        "Contact_Tel2             = \"${Contact.Contact_Tel2}\", " +
        "Contact_eMail            = \"${Contact.Contact_eMail}\", " +
        "Contact_Rem              = \"${Contact.Contact_Rem}\" " +
        "WHERE ContactId      = ${Contact.ContactId.toString()}";
    gColors.printWrapped("setContact " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setContact ret " + ret.toString());
    return ret;
  }

  static Future<bool> addContactAdrType(int contactClientid, int contactAdresseid, String Type) async {
    String wValue = "NULL, $contactClientid, $contactAdresseid, '$Type'";
    String wSlq = "INSERT INTO Contacts (ContactId, Contact_ClientId, Contact_AdresseId, Contact_Type) VALUES ($wValue)";
    print("addContact " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addContact ret " + ret.toString());
    return ret;
  }

  static Future<bool> addContact(int contactClientid) async {
    String wValue = "NULL, $contactClientid";
    String wSlq = "INSERT INTO Contacts (ContactId, Contact_ClientId) VALUES ($wValue)";
    print("addContact " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addContact ret " + ret.toString());
    return ret;
  }

  static Future<bool> delContact(Contact Contact) async {
    String aSQL = "DELETE FROM Contacts WHERE ContactId = ${Contact.ContactId} ";
    print("delContact " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delContact ret " + ret.toString());
    return ret;
  }

  static Future<List<Contact>> getContact_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Contact> ContactList = await items.map<Contact>((json) {
          return Contact.fromJson(json);
        }).toList();
        return ContactList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Art> ListArt = [];
  static List<Art> ListArtsearchresult = [];
  static Art gArt = Art.ArtInit();

  static Future<bool> getArtAll() async {
    ListArt = await getArt_API_Post("select", "select * from Articles ORDER BY Art_Lib");

    if (ListArt == null) return false;
    print("getArtAll ${ListArt.length}");
    if (ListArt.length > 0) {
      print("getArtAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> setArt(Art Art) async {
    String wSlq = "UPDATE Articles SET "
            "Art_Groupe = \"${Art.Art_Groupe}\", " +
        "Art_Fam = \"${Art.Art_Fam}\", " +
        "Art_Sous_Fam = \"${Art.Art_Sous_Fam}\", " +
        "Art_Id = \"${Art.Art_Id}\", " +
        "Art_Lib = \"${Art.Art_Lib}\", " +
        "Art_Stock = ${Art.Art_Stock.toString()} "
            "WHERE ArtId = ${Art.ArtId.toString()}";
    gColors.printWrapped("setArt " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setArt ret " + ret.toString());
    return ret;
  }

  static Future<bool> addArt(Art Art) async {
    String wValue = "NULL,'???','???','???','???','---', 0";
    String wSlq = "INSERT INTO Articles (ArtId, Art_Groupe  ,Art_Fam     ,Art_Sous_Fam,Art_Id      ,Art_Lib     ,Art_Stock) VALUES ($wValue)";
    print("addArt " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addArt ret " + ret.toString());
    return ret;
  }

  static Future<bool> delArt(Art Art) async {
    String aSQL = "DELETE FROM Articles WHERE ArtId = ${Art.ArtId} ";
    print("delArt " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delArt ret " + ret.toString());
    return ret;
  }

  static Future<List<Art>> getArt_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Art> ArtList = await items.map<Art>((json) {
          return Art.fromJson(json);
        }).toList();
        return ArtList;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Article_Ebp> ListArticle_Ebp = [];
  static List<Article_Ebp> ListArticle_Ebpsearchresult = [];
  static Article_Ebp gArticle_Ebp = Article_Ebp.Article_EbpInit();

  static Future<bool> getArticle_EbpAll() async {
    ListArticle_Ebp = await getArticle_Ebp_API_Post("select", "select * from Articles_Ebp ORDER BY Article_codeArticle");

    if (ListArticle_Ebp == null) return false;
//    print("getArticle_EbpAll ${ListArticle_Ebp.length}");
    if (ListArticle_Ebp.length > 0) {
      //    print("getArticle_EbpAll return TRUE");
      return true;
    }
    return false;
  }

  static Future<bool> setArticle_Ebp(Article_Ebp artEbp) async {
    artEbp.Article_Notes.replaceAll('"', "“");

    String wSlq = "UPDATE Articles_Ebp SET "
            "Article_descriptionCommercialeEnClair = \"${artEbp.Article_descriptionCommercialeEnClair}\", " +
        "Article_Libelle = \"${artEbp.Article_Libelle}\", " +
        "Article_Notes = \"${artEbp.Article_Notes}\", " +
        "Article_Promo_PVHT = ${artEbp.Article_Promo_PVHT.toString()} "
            "WHERE ArticleID = ${artEbp.ArticleID.toString()}";
    gColors.printWrapped("setArt " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setArt ret " + ret.toString());
    return ret;
  }

  static Future<bool> addArticle_Ebp(Article_Ebp articleEbp) async {
    String wValue = "NULL,'???'";
    String wSlq = "INSERT INTO Article_Ebp (ArticleID, Article_descriptionCommercialeEnClair) VALUES ($wValue)";
    print("addArticle_Ebp " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addArticle_Ebp ret " + ret.toString());
    return ret;
  }

  static Future<bool> deladdArticle_Ebp(Article_Ebp articleEbp) async {
    String aSQL = "DELETE FROM Article_Ebp WHERE ArticleID = ${articleEbp.ArticleID} ";
    print("delClient " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delClient ret " + ret.toString());
    return ret;
  }

  static Future<List<Article_Ebp>> getArticle_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Article_Ebp> articleEbplist = await items.map<Article_Ebp>((json) {
          return Article_Ebp.fromJson(json);
        }).toList();
        return articleEbplist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Articles_Link_Ebp> ListArticles_Link_Ebp = [];
  static List<Articles_Link_Ebp> ListArticles_Link_Ebpsearchresult = [];
  static Articles_Link_Ebp gArticles_Link_Ebp = Articles_Link_Ebp.Articles_Link_EbpInit();

  static Future<bool> getArticles_Link_EbpAll(String articlesLinkParentid) async {
    String aSQL = "select * from Articles_Link_Ebp WHERE Articles_Link_ParentID = '$articlesLinkParentid' ORDER BY Articles_Link_ParentID,Articles_Link_TypeChildID, Articles_Link_ChildID";

    print("aSQL $aSQL");

    ListArticles_Link_Ebp = await getArticles_Link_Ebp_API_Post("select", aSQL);
    if (ListArticles_Link_Ebp == null) return false;
    if (ListArticles_Link_Ebp.length > 0) {
      return true;
    }
    return false;
  }

  static Future<List<Articles_Link_Ebp>> getArticles_Link_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Articles_Link_Ebp> articlesLinkEbplist = await items.map<Articles_Link_Ebp>((json) {
          return Articles_Link_Ebp.fromJson(json);
        }).toList();
        return articlesLinkEbplist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Articles_Link_Verif_Ebp> ListArticles_Link_Verif_Ebp = [];
  static List<Articles_Link_Verif_Ebp> ListArticles_Link_Verif_Ebpsearchresult = [];
  static Articles_Link_Verif_Ebp gArticles_Link_Verif_Ebp = Articles_Link_Verif_Ebp.Articles_Link_Verif_EbpInit();

  static Future<bool> getArticles_Link_Verif_EbpAll(String articlesLinkVerifParentid) async {
    String aSQL = "select * from Articles_Link_Verif_Ebp WHERE Articles_Link_Verif_ParentID = '$articlesLinkVerifParentid' ORDER BY Articles_Link_Verif_TypeVerif,Articles_Link_Verif_TypeChildID, Articles_Link_Verif_ChildID";

    print("aSQL $aSQL");

    ListArticles_Link_Verif_Ebp = await getArticles_Link_Verif_Ebp_API_Post("select", aSQL);
    if (ListArticles_Link_Verif_Ebp == null) return false;
    if (ListArticles_Link_Verif_Ebp.length > 0) {
      return true;
    }
    return false;
  }

  static Future<List<Articles_Link_Verif_Ebp>> getArticles_Link_Verif_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Articles_Link_Verif_Ebp> articlesLinkVerifEbplist = await items.map<Articles_Link_Verif_Ebp>((json) {
          return Articles_Link_Verif_Ebp.fromJson(json);
        }).toList();
        return articlesLinkVerifEbplist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Article_Fam_Ebp> ListArticle_Fam_Ebp = [];
  static List<Article_Fam_Ebp> ListArticle_Fam_Ebpsearchresult = [];
  static Article_Fam_Ebp gArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();

  static Future<bool> getArticle_Fam_EbpAll() async {
    ListArticle_Fam_Ebp = await getArticle_Fam_Ebp_API_Post("select", "select * from Articles_Fam_Ebp ORDER BY Article_Fam_Description");

    if (ListArticle_Fam_Ebp == null) return false;
//    print("getArticle_Fam_EbpAll ${ListArticle_Fam_Ebp.length}");
    if (ListArticle_Fam_Ebp.length > 0) {
      for (int i = 0; i < ListArticle_Fam_Ebp.length; i++) {
        Article_Fam_Ebp warticleFamEbp = ListArticle_Fam_Ebp[i];
        if (warticleFamEbp.Article_Fam_UUID.isEmpty) {
          var uuid = Uuid();
          String uuidv1 = uuid.v1();
          warticleFamEbp.Article_Fam_UUID = uuidv1;
          setArticle_Fam_UUID(warticleFamEbp);
        }
        if (warticleFamEbp.Article_Fam_Libelle.isEmpty) {
          if (warticleFamEbp.Article_Fam_Code_Parent.isEmpty) {
            if (warticleFamEbp.Article_Fam_Description.contains("-")) {
              if (warticleFamEbp.Article_Fam_Description.indexOf("-") < warticleFamEbp.Article_Fam_Description.length - 1) {
                String wLib = warticleFamEbp.Article_Fam_Description.substring(warticleFamEbp.Article_Fam_Description.indexOf("-") + 1);
                print("cut $wLib");
                warticleFamEbp.Article_Fam_Libelle = gColors.capitalize(wLib);
              }
            } else {
              warticleFamEbp.Article_Fam_Libelle = gColors.capitalize(warticleFamEbp.Article_Fam_Description);
            }
          } else {
            warticleFamEbp.Article_Fam_Libelle = gColors.capitalize(warticleFamEbp.Article_Fam_Description);
          }

          setArticle_Fam(warticleFamEbp);
        }
      }

      return true;
    }
    return false;
  }

  static Future<bool> setArticle_Fam_UUID(Article_Fam_Ebp warticleFamEbp) async {
    String wSlq = "UPDATE Articles_Fam_Ebp SET "
            "Article_Fam_UUID = '${warticleFamEbp.Article_Fam_UUID.replaceAll("'", "\'")}' " +
        "WHERE Article_FamId = ${warticleFamEbp.Article_FamId}";
    bool ret = await add_API_Post("upddel", wSlq);
    return ret;
  }

  static Future<bool> setArticle_Fam(Article_Fam_Ebp warticleFamEbp) async {
    print("wSlq: ${warticleFamEbp.Article_Fam_Description}");
    print("wSlq: ${warticleFamEbp.Article_Fam_Description.replaceAll("'", "\'")}");
    print("wSlq: ${warticleFamEbp.Article_Fam_Description.replaceAll("'", "''")}");

    String wSlq = "UPDATE Articles_Fam_Ebp SET "
            "Article_Fam_Description = '${warticleFamEbp.Article_Fam_Description.replaceAll("'", "''")}', " +
        "Article_Fam_Libelle = '${warticleFamEbp.Article_Fam_Libelle.replaceAll("'", "''")}' " +
        "WHERE Article_FamId = ${warticleFamEbp.Article_FamId}";
    print("wSlq: " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    return ret;
  }

  static Future<List<Article_Fam_Ebp>> getArticle_Fam_Ebp_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Article_Fam_Ebp> articleFamEbplist = await items.map<Article_Fam_Ebp>((json) {
          return Article_Fam_Ebp.fromJson(json);
        }).toList();
        return articleFamEbplist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<User_Hab> ListUser_Hab = [];
  static List<User_Hab> ListUser_Habsearchresult = [];
  static User_Hab gUser_Hab = User_Hab.User_HabInit();

  static Future<bool> getUser_Hab(int userHabUserid) async {
    ListUser_Hab = await getUser_Hab_API_Post("select", "select Users_Hab.*, Param_Hab_PDT, Param_Hab_Grp from Users_Hab, Param_Hab where User_Hab_Param_HabID = Param_HabID AND User_Hab_UserID = $userHabUserid ORDER BY User_Hab_Ordre,User_HabID");
    if (ListUser_Hab == null) return false;
    print("getUser_HabAll ${ListUser_Hab.length}");
    if (ListUser_Hab.length > 0) {
      int i = 1;
      ListUser_Hab.forEach((element) {
        element.User_Hab_Ordre = i++;
        setUser_Hab_Ordre(element);
      });
      return true;
    }
    return false;
  }

  static Future<bool> setUser_Hab_Ordre(User_Hab userHab) async {
    String wSlq = "UPDATE Users_Hab SET "
            "User_Hab_Ordre = ${userHab.User_Hab_Ordre} " +
        "WHERE User_HabId = ${userHab.User_HabID}";
    bool ret = await add_API_Post("upddel", wSlq);
    return ret;
  }

  static Future<bool> setUser_Hab(User_Hab userHab) async {
    String wSlq = "UPDATE Users_Hab SET "
            "User_Hab_MaintPrev = ${userHab.User_Hab_MaintPrev}, " +
        "User_Hab_Install = ${userHab.User_Hab_Install}, " +
        "User_Hab_MaintCorrect = ${userHab.User_Hab_MaintCorrect}, " +
        "User_Hab_Ordre = ${userHab.User_Hab_Ordre} " +
        "WHERE User_HabId = ${userHab.User_HabID}";
    gColors.printWrapped("setUser_Hab " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser_Hab ret " + ret.toString());
    return ret;
  }

  static Future<bool> addUser_Hab(int userHabUserid) async {
    String wSlq = "INSERT IGNORE INTO Users_Hab (User_Hab_UserID, User_Hab_Param_HabID, User_Hab_Ordre) " + "SELECT $userHabUserid, Param_HabId, Param_Hab_Ordre FROM Param_Hab;";
    gColors.printWrapped("addUser_Hab " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser_Hab ret " + ret.toString());
    return ret;
  }

  static Future<List<User_Hab>> getUser_Hab_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<User_Hab> userHablist = await items.map<User_Hab>((json) {
          return User_Hab.fromJson(json);
        }).toList();
        return userHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<User_Desc> ListUser_Desc = [];
  static List<User_Desc> ListUser_Descsearchresult = [];
  static User_Desc gUser_Desc = User_Desc.User_DescInit();

  static Future<bool> getUser_Desc(int userDescUserid) async {
    ListUser_Desc = await getUser_Desc_API_Post("select", "SELECT Users_Desc.*, Param_Saisie_Param_Label FROM Users_Desc, Param_Saisie_Param WHERE User_Desc_Param_DescID = Param_Saisie_ParamId AND Param_Saisie_Param_Id = 'DESC' AND User_Desc_UserID = $userDescUserid");
    if (ListUser_Desc == null) return false;
    print("getUser_DescAll ${ListUser_Desc.length}");
    if (ListUser_Desc.length > 0) {
      int i = 1;
      ListUser_Desc.forEach((element) {
        element.User_Desc_Ordre = i++;
        setUser_Desc_Ordre(element);
      });
      return true;
    }
    return false;
  }

  static Future<bool> setUser_Desc_Ordre(User_Desc userDesc) async {
    String wSlq = "UPDATE Users_Desc SET "
            "User_Desc_Ordre = ${userDesc.User_Desc_Ordre} " +
        "WHERE User_DescId = ${userDesc.User_DescID}";
    bool ret = await add_API_Post("upddel", wSlq);
    return ret;
  }

  static Future<bool> setUser_Desc(User_Desc userDesc) async {
    String wSlq = "UPDATE Users_Desc SET "
            "User_Desc_MaintPrev = ${userDesc.User_Desc_MaintPrev}, " +
        "User_Desc_Install = ${userDesc.User_Desc_Install}, " +
        "User_Desc_MaintCorrect = ${userDesc.User_Desc_MaintCorrect}, " +
        "User_Desc_Ordre = ${userDesc.User_Desc_Ordre} " +
        "WHERE User_DescId = ${userDesc.User_DescID}";
    gColors.printWrapped("setUser_Desc " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> addUser_Desc(int userDescUserid) async {
    String wSlq = "INSERT IGNORE INTO Users_Desc (User_Desc_UserID, User_Desc_Param_DescID, User_Desc_Ordre) " + "SELECT $userDescUserid,Param_Saisie_ParamId, Param_Saisie_Param_Ordre FROM Param_Saisie_Param WHERE Param_Saisie_Param_Id = 'DESC'";
    gColors.printWrapped("setUser_Desc " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setUser_Desc ret " + ret.toString());
    return ret;
  }

  static Future<List<User_Desc>> getUser_Desc_API_Post(String aType, String aSQL) async {
    setSrvToken();

    gColors.printWrapped("setUser_Desc " + aSQL);

    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<User_Desc> userDesclist = await items.map<User_Desc>((json) {
          return User_Desc.fromJson(json);
        }).toList();
        return userDesclist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Niveau_Hab> ListNiveau_Hab = [];
  static List<Niveau_Hab> ListNiveau_Habsearchresult = [];
  static Niveau_Hab gNiveau_Hab = Niveau_Hab.Niveau_HabInit();

  static Future<bool> getNiveau_Hab(int niveauHabUserid) async {
    String wSql = "select *, Param_Hab_PDT, Param_Hab_Grp from Niveaux_Hab, Param_Hab where Niveau_Hab_Param_HabID = Param_HabID AND Niveau_Hab_NiveauID = $niveauHabUserid ORDER BY Niveau_Hab_Ordre,Niveau_HabID;";

    ListNiveau_Hab = await getNiveau_Hab_API_Post("select", wSql);
    if (ListNiveau_Hab == null) return false;
    print("getNiveau_Hab ${ListNiveau_Hab.length}");
    if (ListNiveau_Hab.length > 0) {
      int i = 1;
      ListNiveau_Hab.forEach((element) {
        element.Niveau_Hab_Ordre = i++;
        setNiveau_Hab_Ordre(element);
      });
      return true;
    }
    return false;
  }

  static Future<bool> setNiveau_Hab_Ordre(Niveau_Hab niveauHab) async {
    String wSlq = "UPDATE Niveaux_Hab SET "
            "Niveau_Hab_Ordre = ${niveauHab.Niveau_Hab_Ordre} " +
        "WHERE Niveau_HabId = ${niveauHab.Niveau_HabID}";
    bool ret = await add_API_Post("upddel", wSlq);
    return ret;
  }

  static Future<bool> setNiveau_Hab(Niveau_Hab niveauHab) async {
    String wSlq = "UPDATE Niveaux_Hab SET "
            "Niveau_Hab_MaintPrev = ${niveauHab.Niveau_Hab_MaintPrev}, " +
        "Niveau_Hab_Install = ${niveauHab.Niveau_Hab_Install}, " +
        "Niveau_Hab_MaintCorrect = ${niveauHab.Niveau_Hab_MaintCorrect}, " +
        "Niveau_Hab_Ordre = ${niveauHab.Niveau_Hab_Ordre} " +
        "WHERE Niveau_HabId = ${niveauHab.Niveau_HabID}";
    gColors.printWrapped("setNiveau_Hab " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setNiveau_Hab ret " + ret.toString());
    return ret;
  }

  static Future<bool> addNiveau_Hab(int niveauHabUserid) async {
    String wSlq = "INSERT IGNORE INTO Niveaux_Hab (Niveau_Hab_NiveauID, Niveau_Hab_Param_HabID, Niveau_Hab_Ordre) " + "SELECT $niveauHabUserid, Param_HabId, Param_Hab_Ordre FROM Param_Hab;";
    gColors.printWrapped("setNiveau_Hab " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setNiveau_Hab ret " + ret.toString());
    return ret;
  }

  static Future<List<Niveau_Hab>> getNiveau_Hab_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Niveau_Hab> niveauHablist = await items.map<Niveau_Hab>((json) {
          return Niveau_Hab.fromJson(json);
        }).toList();
        return niveauHablist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Niveau_Desc> ListNiveau_Desc = [];
  static List<Niveau_Desc> ListNiveau_Descsearchresult = [];
  static Niveau_Desc gNiveau_Desc = Niveau_Desc.Niveau_DescInit();

  static Future<bool> getNiveau_Desc(int niveauDescUserid) async {
    String wSql = "select Niveaux_Desc.*, Param_Saisie_Param_Label from Niveaux_Desc, Param_Saisie_Param where Param_Saisie_Param_Id = 'DESC' AND Niveau_Desc_Param_DescID = Param_Saisie_ParamId AND Niveau_Desc_NiveauID = $niveauDescUserid ORDER BY Niveau_Desc_Ordre,Niveau_DescID";
    gColors.printWrapped("getNiveau_Desc $wSql");
    ListNiveau_Desc = await getNiveau_Desc_API_Post("select", wSql);
    if (ListNiveau_Desc == null) return false;
    print("getNiveau_Desc ${ListNiveau_Desc.length}");
    if (ListNiveau_Desc.length > 0) {
      int i = 1;
      ListNiveau_Desc.forEach((element) {
        element.Niveau_Desc_Ordre = i++;
        setNiveau_Desc_Ordre(element);
      });
      return true;
    }
    return false;
  }

  static Future<bool> setNiveau_Desc_Ordre(Niveau_Desc niveauDesc) async {
    String wSlq = "UPDATE Niveaux_Desc SET "
            "Niveau_Desc_Ordre = ${niveauDesc.Niveau_Desc_Ordre} " +
        "WHERE Niveau_DescId = ${niveauDesc.Niveau_DescID}";
    bool ret = await add_API_Post("upddel", wSlq);
    return ret;
  }

  static Future<bool> setNiveau_Desc(Niveau_Desc niveauDesc) async {
    String wSlq = "UPDATE Niveaux_Desc SET "
            "Niveau_Desc_MaintPrev = ${niveauDesc.Niveau_Desc_MaintPrev}, " +
        "Niveau_Desc_Install = ${niveauDesc.Niveau_Desc_Install}, " +
        "Niveau_Desc_MaintCorrect = ${niveauDesc.Niveau_Desc_MaintCorrect}, " +
        "Niveau_Desc_Ordre = ${niveauDesc.Niveau_Desc_Ordre} " +
        "WHERE Niveau_DescId = ${niveauDesc.Niveau_DescID}";
    gColors.printWrapped("setNiveau_Desc " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setNiveau_Desc ret " + ret.toString());
    return ret;
  }

  static Future<bool> addNiveau_Desc(int niveauDescUserid) async {
    String wSlq = "INSERT IGNORE INTO Niveaux_Desc (Niveau_Desc_NiveauID, Niveau_Desc_Param_DescID, Niveau_Desc_Ordre) " + "SELECT $niveauDescUserid, Param_Saisie_ParamId, Param_Saisie_Param_Ordre FROM Param_Saisie_Param WHERE Param_Saisie_Param_Id = 'DESC'";
    gColors.printWrapped("addNiveau_Desc " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setNiveau_Desc ret " + ret.toString());
    return ret;
  }

  static Future<List<Niveau_Desc>> getNiveau_Desc_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Niveau_Desc> niveauDesclist = await items.map<Niveau_Desc>((json) {
          return Niveau_Desc.fromJson(json);
        }).toList();
        return niveauDesclist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //***********************************************************************
  //***********************************************************************
  //***********************************************************************

  static List<Param_Saisie_Param> ListParam_Saisie_Param = [];
  static List<Param_Saisie_Param> ListParam_Saisie_ParamAll = [];
  static List<Param_Saisie_Param> ListParam_Saisie_Paramsearchresult = [];
  static Param_Saisie_Param gParam_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();

  static Future<bool> getParam_Saisie_ParamAll() async {
    ListParam_Saisie_Param = await getParam_Saisie_Param_API_Post("select", "select * from Param_Saisie_Param ORDER BY Param_Saisie_Param_Id,Param_Saisie_Param_Ordre");

    ListParam_Saisie_ParamAll.clear();
    if (ListParam_Saisie_Param == null) return false;

    ListParam_Saisie_ParamAll.addAll(ListParam_Saisie_Param);
    print("getParam_Saisie_ParamAll ${ListParam_Saisie_Param.length}");
    if (ListParam_Saisie_Param.length > 0) {
      return true;
    }

    return false;
  }

  static Future<bool> getParam_Saisie_Param(String paramSaisieParamId) async {
    String wSql = "select * from Param_Saisie_Param WHERE Param_Saisie_Param_Id = '$paramSaisieParamId' ORDER BY Param_Saisie_Param_Id,Param_Saisie_Param_Ordre,Param_Saisie_Param_Label";

//    print("getParam_Saisie_Param ${wSql}");

    ListParam_Saisie_Param = await getParam_Saisie_Param_API_Post("select", wSql);

    //  print("getParam_Saisie_Param ${ListParam_Saisie_Param.length}");
    if (ListParam_Saisie_Param.length > 0) {
      int o = 0;
      for (int i = 0; i < DbTools.ListParam_Saisie_Param.length; i++) {
        Param_Saisie_Param element = DbTools.ListParam_Saisie_Param[i];
        //    print("getParam_Saisie_Param ${element.Param_Saisie_Param_Ordre} $i ${element.Param_Saisie_Param_Id} ${element.Param_Saisie_Param_Label}");
        element.Param_Saisie_Param_Ordre = o++;
        await setParam_Saisie_Param_Ordre(element);
      }
      return true;
    }
    return false;
  }

  static bool getParam_Saisie_ParamMem(String paramSaisieParamId) {
    ListParam_Saisie_Param.clear();
    ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo(paramSaisieParamId) == 0) {
        ListParam_Saisie_Param.add(element);
      }
    });
    return true;
  }

  static Future<bool> setParam_Saisie_Param_Ordre(Param_Saisie_Param paramSaisieParam) async {
    String wSlq = "UPDATE Param_Saisie_Param SET Param_Saisie_Param_Ordre = " + paramSaisieParam.Param_Saisie_Param_Ordre.toString() + " WHERE Param_Saisie_ParamId = " + paramSaisieParam.Param_Saisie_ParamId.toString();
    bool ret = await add_API_Post("upddel", wSlq);
//    print("> $ret setParam_Saisie_Param_Ordre " + wSlq);
    return ret;
  }

  static Future<bool> setParam_Saisie_Param(Param_Saisie_Param paramSaisieParam) async {
    String wSlq = "UPDATE Param_Saisie_Param SET "
            "Param_Saisie_Param_Id = \"" +
        paramSaisieParam.Param_Saisie_Param_Id +
        "\", " +
        "Param_Saisie_Param_Ordre = " +
        paramSaisieParam.Param_Saisie_Param_Ordre.toString() +
        ", " +
        "Param_Saisie_Param_Default = " +
        paramSaisieParam.Param_Saisie_Param_Default.toString() +
        ", " +
        "Param_Saisie_Param_Init = " +
        paramSaisieParam.Param_Saisie_Param_Init.toString() +
        ", " +
        "Param_Saisie_Param_Label = \"" +
        paramSaisieParam.Param_Saisie_Param_Label.toString() +
        "\", " +
        "Param_Saisie_Param_Abrev = \"" +
        paramSaisieParam.Param_Saisie_Param_Abrev.toString() +
        "\", " +
        "Param_Saisie_Param_Aide = \"" +
        paramSaisieParam.Param_Saisie_Param_Aide.toString() +
        "\", " +
        "Param_Saisie_Param_Color = \"" +
        paramSaisieParam.Param_Saisie_Param_Color.toString() +
        "\" " +
        " WHERE Param_Saisie_ParamId = " +
        paramSaisieParam.Param_Saisie_ParamId.toString();
    print("setParam_Saisie_Param " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Saisie_Param ret $ret");

    return ret;
  }

  static Future<bool> addParam_Saisie_Param(Param_Saisie_Param wparamSaisieParam) async {
    String wValue = "NULL,'${wparamSaisieParam.Param_Saisie_Param_Id}',${wparamSaisieParam.Param_Saisie_Param_Ordre}, '${wparamSaisieParam.Param_Saisie_Param_Label}', '${wparamSaisieParam.Param_Saisie_Param_Abrev}','${wparamSaisieParam.Param_Saisie_Param_Aide}','${wparamSaisieParam.Param_Saisie_Param_Color}'";
    String wSlq = "INSERT INTO Param_Saisie_Param (Param_Saisie_ParamId,Param_Saisie_Param_Id,Param_Saisie_Param_Ordre,Param_Saisie_Param_Label, Param_Saisie_Param_Abrev,Param_Saisie_Param_Aide, Param_Saisie_Param_Color) VALUES ($wValue)";
    print("addParam_Saisie_Param " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Saisie_Param ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Saisie_Param(Param_Saisie_Param paramSaisieParam) async {
    String aSQL = "DELETE FROM Param_Saisie_Param WHERE Param_Saisie_ParamId = ${paramSaisieParam.Param_Saisie_ParamId} ";
    print("delParam_Saisie_Param " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Saisie_Param ret " + ret.toString());
    return ret;
  }

  static Future<List<Param_Saisie_Param>> getParam_Saisie_Param_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];

      if (items != null) {
        List<Param_Saisie_Param> paramSaisieParamlist = await items.map<Param_Saisie_Param>((json) {
          return Param_Saisie_Param.fromJson(json);
        }).toList();
        return paramSaisieParamlist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static List<Param_Gamme> ListParam_Gamme = [];
  static List<Param_Gamme> ListParam_Gammesearchresult = [];
  static Param_Gamme gParam_Gamme = Param_Gamme.Param_GammeInit();

  static Future<bool> getParam_GammeAll() async {
    ListParam_Gamme = await getParam_Gamme_API_Post("select", "select * from Param_Gamme ORDER BY Param_Gamme_Ordre,Param_Gamme_ID");

    print("getParam_GammeAll aSQL select * from Param_Gamme ORDER BY Param_Gamme_ID");

    if (ListParam_Gamme == null) return false;

    print("getParam_GammeAll ${ListParam_Gamme.length}");

    if (ListParam_Gamme.length > 0) {
      print("getParam_GammeAll return TRUE");

      return true;
    }

    return false;
  }

  static Future<bool> getParam_Gamme(String paramGammeTypeOrgane) async {
    String wSql = "select * from Param_Gamme WHERE Param_Gamme_Type_Organe = '$paramGammeTypeOrgane' ORDER BY Param_Gamme_Ordre,Param_Gamme_FAB_Lib,Param_Gamme_PRS_Lib,Param_Gamme_CLF_Lib,Param_Gamme_GAM_Lib,Param_Gamme_PDT_Lib,Param_Gamme_POIDS_Lib";
//    print("getParam_Gamme ${wSql}");

    ListParam_Gamme = await getParam_Gamme_API_Post("select", wSql);

    if (ListParam_Gamme == null) return false;
    //  print("getParam_GammeAll ${ListParam_Gamme.length}");
    if (ListParam_Gamme.length > 0) {
      //  print("getParam_GammeAll return TRUE");

      for (int i = 0; i < DbTools.ListParam_Gamme.length; i++) {
        Param_Gamme wsetparamGamme = DbTools.ListParam_Gamme[i];
        if (wsetparamGamme.Param_Gamme_Ordre != i + 1) {
          wsetparamGamme.Param_Gamme_Ordre = i + 1;
          await DbTools.setParam_Gamme(wsetparamGamme);
        }
      }

      return true;
    }

    return false;
  }

  /*
  Param_GammeId
  Param_Gamme_Type_Organe
  Param_Gamme_FAB_Id
  Param_Gamme_FAB_Lib
  Param_Gamme_PRS_Id
  Param_Gamme_PRS_Lib
  Param_Gamme_CLF_Id
  Param_Gamme_CLF_Lib
  Param_Gamme_GAM_Id
  Param_Gamme_GAM_Lib
  Param_Gamme_PDT_Id
  Param_Gamme_PDT_Lib
  Param_Gamme_POIDS_Id
  Param_Gamme_POIDS_Lib
  Param_Gamme_REF
*/

  static Future<bool> setParam_Gamme(Param_Gamme paramGamme) async {
    String wSlq = 'UPDATE Param_Gamme SET '
            'Param_Gamme_Type_Organe = "${paramGamme.Param_Gamme_Type_Organe}", ' +
        'Param_Gamme_DESC_Id = ${paramGamme.Param_Gamme_DESC_Id}, ' +
        'Param_Gamme_DESC_Lib = "${paramGamme.Param_Gamme_DESC_Lib}", ' +
        'Param_Gamme_FAB_Id = ${paramGamme.Param_Gamme_FAB_Id}, ' +
        'Param_Gamme_FAB_Lib = "${paramGamme.Param_Gamme_FAB_Lib}", ' +
        'Param_Gamme_PRS_Id = ${paramGamme.Param_Gamme_PRS_Id}, ' +
        'Param_Gamme_PRS_Lib = "${paramGamme.Param_Gamme_PRS_Lib}", ' +
        'Param_Gamme_CLF_Id = ${paramGamme.Param_Gamme_CLF_Id}, ' +
        'Param_Gamme_CLF_Lib = "${paramGamme.Param_Gamme_CLF_Lib}", ' +
        'Param_Gamme_MOB_Id = ${paramGamme.Param_Gamme_MOB_Id}, ' +
        'Param_Gamme_MOB_Lib = "${paramGamme.Param_Gamme_MOB_Lib}", ' +
        'Param_Gamme_GAM_Id = ${paramGamme.Param_Gamme_GAM_Id}, ' +
        'Param_Gamme_GAM_Lib = "${paramGamme.Param_Gamme_GAM_Lib}", ' +
        'Param_Gamme_PDT_Id = ${paramGamme.Param_Gamme_PDT_Id}, ' +
        'Param_Gamme_PDT_Lib = "${paramGamme.Param_Gamme_PDT_Lib}", ' +
        'Param_Gamme_POIDS_Id = ${paramGamme.Param_Gamme_POIDS_Id}, ' +
        'Param_Gamme_POIDS_Lib = "${paramGamme.Param_Gamme_POIDS_Lib}", ' +
        'Param_Gamme_REF = "${paramGamme.Param_Gamme_REF}", ' +
        'Param_Gamme_Ordre = ${paramGamme.Param_Gamme_Ordre} ' +
        'WHERE Param_GammeId = ${paramGamme.Param_GammeId.toString()}';

    print("setParam_Gamme " + wSlq);
    bool ret = await add_API_Post("upddel", wSlq);
    print("setParam_Gamme ret " + ret.toString());
    return ret;
  }

  static Future<bool> addParam_Gamme(Param_Gamme paramGamme) async {
    String wValue = "NULL,'${paramGamme.Param_Gamme_Type_Organe}'";
    String wSlq = "INSERT INTO Param_Gamme (Param_GammeId,Param_Gamme_Type_Organe) VALUES ($wValue)";
    print("addParam_Gamme " + wSlq);
    bool ret = await add_API_Post("insert", wSlq);
    print("addParam_Gamme ret " + ret.toString());
    return ret;
  }

  static Future<bool> delParam_Gamme(Param_Gamme paramGamme) async {
    String aSQL = "DELETE FROM Param_Gamme WHERE Param_GammeId = ${paramGamme.Param_GammeId} ";
    print("delParam_Gamme " + aSQL);
    bool ret = await add_API_Post("upddel", aSQL);
    print("delParam_Gamme ret " + ret.toString());
    return ret;
  }

  static Future<List<Param_Gamme>> getParam_Gamme_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
//      print("${items}");
      if (items != null) {
        List<Param_Gamme> paramGammelist = await items.map<Param_Gamme>((json) {
          return Param_Gamme.fromJson(json);
        }).toList();
        return paramGammelist;
      }
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  //*****************************
  //*****************************
  //*****************************

  static int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  //****************************************
  //****************************************
  //****************************************

  static Future<bool> setdel_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL});

    http.StreamedResponse response = await request.send();
    print("setdelUser_API_Post " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      if (success == 1) return true;
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }

  static Future<bool> add_API_Post(String aType, String aSQL) async {
    setSrvToken();
    gLastID = -1;
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=

//    print("SrvUrl " + SrvUrl);
//    print("aType " + aType);

    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL});

    http.StreamedResponse response = await request.send();
//    print("add_API_Post " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());

      var success = parsedJson['success'];

/*
      print("add_API_Post parsedJson ${parsedJson.toString()}");
      print("add_API_Post success $success");
      var decsql = parsedJson['decsql'];
      print("add_API_Post decsql $decsql");
*/

      if (success == 1) {
        gLastID = int.tryParse("${parsedJson['last_id']}") ?? 0;
      }
      return true;
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }

  //****************************************
  //****************************************
  //****************************************

  static Future<bool> removephoto_API_Post(String aName) async {
    setSrvToken();
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));

    request.fields.addAll({
      'tic12z': SrvToken,
      'zasq': 'removephoto',
      'Name': aName,
    });

    print("removephoto_API_Post ${request.fields}");

    http.StreamedResponse response = await request.send();
    print("removephoto_API_Post " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      var success = parsedJson['success'];
      if (success == 1) {
        return true;
      }
    } else {
      print(response.reasonPhrase);
    }
    return false;
  }

  //****************************************
  //****************************************
  //****************************************

  static void setSrvToken() {
    var uuid = Uuid();
    var v1 = uuid.v1();

    Random random = new Random();

    int Cut = random.nextInt(8) + 1;
    String sCut = "T" + Cut.toString();

    String S1 = SrvTokenKey.substring(0, Cut);
    String S2 = SrvTokenKey.substring(Cut);

    int F1 = random.nextInt(7);
    String sR3 = "P" + F1.toString().padLeft(2, '0');
    int F3 = random.nextInt(7);
    int F2 = 16 - F1 - F3;

    int R5 = F1 + Cut + 3 + F2 + 2;

    String sR5 = "S" + R5.toString().padLeft(2, '0');

//    print("v1 $v1");

    int C1 = random.nextInt(20) + 1;
    int C2 = random.nextInt(20) + 1;
    int C3 = random.nextInt(20) + 1;

//    print("F1  $C1 $F1");
//    print("F2  $C2 $F2");
//    print("F3  $C3 $F3");

    String sF1 = v1.substring(C1, C1 + F1);
//    print("sF1 $sF1");
    String sF2 = v1.substring(C2, C2 + F2);
//    print("sF2 $sF2");
    String sF3 = v1.substring(C3, C3 + F3);
//    print("sF3 $sF3");

//    print("SrvTokenKey $SrvTokenKey");
//    print("Cut $Cut $sCut");
//    print("S1 $S1");
//    print("S2 $S2");

//    print("R3 $sR3");
//    print("R5 $R5 $sR5");

    String Tok = sF1 + S1 + sR5 + sF2 + sCut + S2 + sR3 + sF3;
    int TokLen = Tok.length;
//    print("Tok $Tok $TokLen");

    SrvToken = Tok;

    int pT = Tok.indexOf('T') + 1;
    String rsT1 = Tok.substring(pT, pT + 1);
    int rT1 = int.parse(rsT1);
//    print("rT1 $rT1");
    int rT2 = 8 - rT1;
//    print("rT2 $rT2");

    int pP = Tok.indexOf('P') + 1;
//    print("pP $pP");
    String rsP = Tok.substring(pP, pP + 2);
    int rP = int.parse(rsP);
//    print("rP $rP");

    int pS = Tok.indexOf('S') + 1;
//    print("pS $pS");
    String rsS = Tok.substring(pS, pS + 2);
    int rS = int.parse(rsS);
//    print("rS $rS");

    String rR3 = Tok.substring(rP, rP + rT1);
    String rR5 = Tok.substring(rS, rS + rT2);
//    print("rR3 $rR3");
//    print("rR5 $rR5");

    String rR35 = rR3 + rR5;

    //   print("VERIF $rR35");
  }

  //***************************************************************
  //***************************************************************
  //***************************************************************

  static Future ctrl_NF074_Sql(String wSql) async {
    List<Ret> listRet = [];
    listRet = await getSQL_API_Post("select", wSql);

    print("ctrl_NF074_Sql ${listRet.length}");


      for (int i = 0; i < listRet.length; i++) {

        print("ctrl_NF074_Sql ret ${listRet[i].ret}");



      }


  }


  static Future<List<Ret>> getSQL_API_Post(String aType, String aSQL) async {
    setSrvToken();
    String eSQL = base64.encode(utf8.encode(aSQL)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    var request = http.MultipartRequest('POST', Uri.parse(SrvUrl.toString()));
    request.fields.addAll({'tic12z': SrvToken, 'zasq': aType, 'resza12': eSQL, 'uid': "${DbTools.gUserLogin.UserID}"});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var parsedJson = json.decode(await response.stream.bytesToString());
      final items = parsedJson['data'];
      print("${items}");

      if (items != null) {
        List<Ret> listRet = await items.map<Ret>((json) {
          return Ret.fromJson(json);
        }).toList();
        return listRet;
      }

    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
  //***************************************************************
  //***************************************************************
  //***************************************************************



}

class GrdBtnGrp {
  int? GrdBtnGrpId = 0;
  Color? GrdBtnGrp_Color = Colors.white;
  Color? GrdBtnGrp_ColorSel = Colors.black;
  Color? GrdBtnGrp_Txt_Color = Colors.black;
  Color? GrdBtnGrp_Txt_Colordes = Colors.black;
  Color? GrdBtnGrp_Txt_ColorSel = Colors.white;
  int? GrdBtnGrpType = 0;
  List<int>? GrdBtnGrpSelId = [0];

  GrdBtnGrp({
    this.GrdBtnGrpId,
    this.GrdBtnGrp_Color,
    this.GrdBtnGrp_ColorSel,
    this.GrdBtnGrp_Txt_Color,
    this.GrdBtnGrp_Txt_Colordes,
    this.GrdBtnGrp_Txt_ColorSel,
    this.GrdBtnGrpType,
    this.GrdBtnGrpSelId,
  });
}

class GrdBtn {
  int? GrdBtnId = 0;
  int? GrdBtn_GroupeId = 0;
  String? GrdBtn_Label = "";

  GrdBtn({
    this.GrdBtnId,
    this.GrdBtn_GroupeId,
    this.GrdBtn_Label,
  });
}

class Ret {
  String? ret = "";

  Ret({
    this.ret,
  });

  factory Ret.fromJson(Map<String, dynamic> json) {

    Ret wRet = Ret(
      ret : json['ret'],
    );

    return wRet;
  }




}



/*



CREATE TABLE `NF074` (
`NF074id` int(11) NOT NULL,
`NF074_Fichier` varchar(512) NOT NULL DEFAULT '',
`NF074_No`        varchar(5) NOT NULL DEFAULT '',
`NF074_MM` varchar(2) NOT NULL DEFAULT '',
`NF074_AAAA` varchar(4) NOT NULL DEFAULT '',
`NF074_Fabricant` varchar(512) NOT NULL DEFAULT '',
`NF074_Certif` varchar(512) NOT NULL DEFAULT '',
`NF074_RTCH` varchar(512) NOT NULL DEFAULT '',
`NF074_Type` varchar(512) NOT NULL DEFAULT '',
`NF074_Vol` varchar(512) NOT NULL DEFAULT '',
`NF074_Add` varchar(512) NOT NULL DEFAULT '',
`NF074_QAdd` varchar(512) NOT NULL DEFAULT '',
`NF074_MAdd` varchar(512) NOT NULL DEFAULT '',
`NF074_Agent` varchar(512) NOT NULL DEFAULT '',
`NF074_Foyers` varchar(512) NOT NULL DEFAULT '',
`NF074_Temps` varchar(512) NOT NULL DEFAULT '',
`NF074_Durée` varchar(512) NOT NULL DEFAULT '',
`NF074_Transp` varchar(512) NOT NULL DEFAULT '',
`NF074_Pres` varchar(512) NOT NULL DEFAULT '',
`NF074_Aux` varchar(512) NOT NULL DEFAULT '',
`NF074_NORME` varchar(512) NOT NULL DEFAULT '',
`NF074_USINE` varchar(512) NOT NULL DEFAULT '',
`NF074_Entrée` varchar(512) NOT NULL DEFAULT '',
`NF074_Sortie` varchar(512) NOT NULL DEFAULT '')
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


ALTER TABLE `NF074 ADD PRIMARY KEY (`NF074id`);



*/










