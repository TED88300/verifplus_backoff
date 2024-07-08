import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class ParamZone_Dialog {
  ParamZone_Dialog();

  static Future<void> ParamZone_dialog(BuildContext context, {bool readonly = false}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new ParamZone(readonly: readonly),
    );
  }
}

class ParamZone extends StatefulWidget {
  final bool readonly;
  const ParamZone({Key? key, required this.readonly}) : super(key: key);

  @override
  State<ParamZone> createState() => _ParamZoneState();
}

class _ParamZoneState extends State<ParamZone> {
  String wTitle = "";

  bool readonly = false;

  static List<String> listMes = [
    "Règle APSAD R1 / Sprinkleurs",
    "Règle APSAD D2 / Brouillard d'eau",
    "Règle APSAD R3 / Maintenance colonnes incendies",
    "Règle APSAD R4 / Extincteurs portatifs et mobiles",
    "Règle APSAD R5 / RIA et PIA",
    "Règle APSAD R7  / Détection incendie",
    "Règle APSAD R12 / Extinction mousse à haut foisonnement",
    "Règle APSAD R13 / Extinction automatique à gaz",
    "Règle APSAD R16 / Compartimentage",
    "Règle APSAD R17 / Désenfumage naturel",
    "ERT (Etablissement recevant des travailleurs)",
    "ERP (Etablissement recevant du public)",
    "IGH (Immeuble de grander hauteur)",
    "DREAL (Direction régionale de l'environnement, de l'aménagement et du logement)",
    "Autres",
  ];
  static List<bool> itemlistApp = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void initLib() async {
    String ZoneApsad = DbTools.gZone.Zone_Regle!;
    if (ZoneApsad.isNotEmpty) {
      itemlistApp = json.decode(ZoneApsad).cast<bool>().toList();
    }
/*
    for (int i = itemlistApp.length; i < 15; i++) {
      itemlistApp.add(false);
    }
*/
    setState(() {});
  }

  void initState() {
    readonly = widget.readonly;
    initLib();
    super.initState();
  }

  Widget APSAD(BuildContext context) {
    print("_buildPopupDialog");

    List<Widget> cclistMes = [];
    for (int i = 0; i < listMes.length; i++) {
      var wlistMes = listMes[i];
      var witemlistApp = false;
      if (i < itemlistApp.length) {
        witemlistApp = itemlistApp[i];
      }
      readonly
          ? cclistMes.add(gColors.CheckBoxFieldReadOnly(
              400,
              8,
              "$wlistMes",
              witemlistApp,
            ))
          : cclistMes.add(gColors.CheckBoxField(
              400,
              8,
              "$wlistMes",
              witemlistApp,
              (sts) => setState(() {
                    itemlistApp[i] = sts!;
                    print("itemlistApp ${itemlistApp.toString()}");
                  })));
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
    double height = 650; //MediaQuery.of(context).size.height - 200;
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
                "Paramètres Zone",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_W,
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
          height: height,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
              ),
              Text(
                "Règlementations applicables à l'établissement du client",
                style: gColors.bodyTitle1_B_G.copyWith(decoration: TextDecoration.underline),
              ),
              Container(
                height: 20,
              ),
              APSAD(context),
              Container(
                height: 20,
              ),
              readonly ? Container() :
              new ElevatedButton(
                onPressed: () async {
                  DbTools.gZone.Zone_Regle = itemlistApp.toString();
                  DbTools.setZone(DbTools.gZone);
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
