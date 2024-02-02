import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class ParamSite_Dialog {
  ParamSite_Dialog();

  static Future<void> ParamSite_dialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new ParamSite(),
    );
  }
}

class ParamSite extends StatefulWidget {
  @override
  State<ParamSite> createState() => _ParamSiteState();
}

class _ParamSiteState extends State<ParamSite> {
  String wTitle = "";

  static List<String> listMes = [
    "Règle APSAD R4, R5, R17",
    "ERT",
    "ERP",
    "Habitation",
    "IGH",
    "ICPE",
    "DREAL",
    "Autres",
  ];
  static List<bool> itemlistApp = [false, false, false, false, false, false, false, false];

  void initLib() async {
    String siteApsad = DbTools.gSite.Site_APSAD!;
    if (siteApsad.isNotEmpty) {
      itemlistApp = json.decode(siteApsad).cast<bool>().toList();
    }
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  Widget APSAD(BuildContext context) {
    print("_buildPopupDialog");

    List<Widget> cclistMes = [];
    for (int i = 0; i < listMes.length; i++) {
      var wlistMes = listMes[i];
      var witemlistApp = itemlistApp[i];

      print("listMes[i] ${listMes[i]} ${itemlistApp[i]}");

      cclistMes.add(

          gColors.CheckBoxField(
          200,
          8,
          "$wlistMes",
          witemlistApp,
          (sts) => setState(() {
                itemlistApp[i] = sts!;

                print("itemlistApp ${itemlistApp.toString()}");
              }))



      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(children: cclistMes),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    double height = 380; //MediaQuery.of(context).size.height - 200;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: gColors.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Vérif+ : Paramètres Site",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_Wr,
              ),
            ],
          )),
      content: Container(
        margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Container(
            height : height,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
              ),
              Text(
                "Réglementations",
                style: gColors.bodyTitle1_B_G.copyWith(decoration: TextDecoration.underline),
              ),
              Container(
                height: 20,
              ),
              APSAD(context),
              Container(
                height: 20,
              ),
              new ElevatedButton(
                onPressed: () async {
                  DbTools.gSite.Site_APSAD = itemlistApp.toString();
                  DbTools.setSite(DbTools.gSite);

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    side: const BorderSide(
                      width: 1.0,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Valider', style: gColors.bodyTitle1_B_Wr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
