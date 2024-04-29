import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus_backoff/Tools/Api_Gouv.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/shared_Cookies.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/2-login.dart';
import 'package:verifplus_backoff/widgets/4-Menu.dart';
import 'package:verifplus_backoff/widgets/Clients/Clients.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  var IsRememberLogin = false;
  var milliseconds = 2000;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    print(">>>>>>>>>>>>>>>>>> inseeToken");
    try {
      await Api_Gouv.inseeToken() ;
    } catch (e) {
    }

    print("<<<<<<<<<<<<<<<<<< inseeToken");
//    await DbTools.getClientAll();
    DbTools.getParam_ParamFam("FamClient");

    var _duration = new Duration(milliseconds: milliseconds); //SetUp duration here
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    print("splash navigationPage IsRememberLogin  $IsRememberLogin");
    //Excel.CrtExcelPat("TK_Debarras_${DbTools.gInventaire.nom}.xlsx");
    await DbTools.getParam_SaisieAll();


    DbTools.ListParam_Param_Abrev.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Abrev") == 0) {
        DbTools.ListParam_Param_Abrev.add(element);
      }
    });

    DbTools.ListParam_Param_Civ.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Civ") == 0) {
        DbTools.ListParam_Param_Civ.add(element);
      }
    });

    DbTools.ListParam_ParamCiv.clear();
    DbTools.ListParam_ParamCiv.add("");
    for (int i = 0; i < DbTools.ListParam_Param_Civ.length; i++) {
      Param_Param wParam_Param = DbTools.ListParam_Param_Civ[i];
      if (wParam_Param.Param_Param_Text == "C")
       DbTools.ListParam_ParamCiv.add(wParam_Param.Param_Param_ID);
    }

    DbTools.ListParam_ParamForme.clear();
    DbTools.ListParam_ParamForme.add("");
    for (int i = 0; i < DbTools.ListParam_Param_Civ.length; i++) {
      Param_Param wParam_Param = DbTools.ListParam_Param_Civ[i];
      if (wParam_Param.Param_Param_Text != "C")
        DbTools.ListParam_ParamForme.add(wParam_Param.Param_Param_ID);
    }



    if (IsRememberLogin)
      {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Menu()));
//      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>       Clients_screen()));
      }
    else
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();

    print("SplashScreen initLib");
    CookieManager cm = CookieManager.getInstance();
    String IsRememberLogins = cm.getCookie("IsRememberLogin");
    IsRememberLogin = (IsRememberLogins == "X");

    print("SplashScreen initLib IsRememberLogin  $IsRememberLogin");


    if (IsRememberLogin)
    {
      print("SplashScreen initLib IsRememberLogin");
      String emailLogin = cm.getCookie("emailLogin");
      String passwordLogin = cm.getCookie("passwordLogin");
      if (!await DbTools.getUserLogin(emailLogin, passwordLogin))
      {
        IsRememberLogin =false;
      }
    }

    print("SplashScreen initLib startTime");
    await startTime();

  }


  @override
  void initState() {
    initLib();
    if (DbTools.gTED) milliseconds = 10;

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });


        super.initState();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    var size = MediaQuery.of(context).size;

//    print("size W ${size.width} H ${size.height} ${MediaQuery.of(context).devicePixelRatio}");
//    print("size W ${size.width *MediaQuery.of(context).devicePixelRatio } H ${size.height *MediaQuery.of(context).devicePixelRatio} ");

    //"601 x 913"
    // W 800.0 H 1232.0

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final double width = MediaQuery.of(context).size.width * 0.9;
    final double height = MediaQuery.of(context).size.height * 0.9;

    double w = animation.value * 700;
    double h = animation.value * 700;

    if (w > width) w = width;
    if (h > height) h = height;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/AppIco.png',
                width: w,
                height: h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Outils de vérification  ",
                    style: gColors.bodyTitle1_B_P,),
                  Text(
                    "Incendie",
                    style: gColors.bodyTitle1_B_S,),

                ],),

            ],
          ),
        ],
      ),
    );
  }
}
