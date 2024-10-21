import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class ParamSite_Dialog2 {
  ParamSite_Dialog2();

  static Future<void> ParamSite_Dialog(BuildContext context, {bool readonly = false}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new ParamSite2(readonly: readonly),
    );
  }
}

class ParamSite2 extends StatefulWidget {
  final bool readonly;
  const ParamSite2({Key? key, required this.readonly}) : super(key: key);

  @override
  State<ParamSite2> createState() => _ParamSite2State();
}

class _ParamSite2State extends State<ParamSite2> {
  String wTitle = "";

  bool readonly = false;

  static List<String> listMes = [
    "APSAD N1 / Sprinkleurs",
    "APSAD N2 / Brouillard d'eau",
    "APSAD N3 / Maintenance colonnes incendies",
    "APSAD N4 / Extincteurs portatifs et mobiles",
    "APSAD N5 / RIA et PIA",
    "APSAD N7  / Détection incendie",
    "APSAD N12 / Extinction mousse à haut foisonnement",
    "APSAD N13 / Extinction automatique à gaz",
    "APSAD N16 / Compartimentage",
    "APSAD N17 / Désenfumage naturel",

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
  ];

  static List<String> itemlistDate = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];



  void initLib() async {
    String siteApsad = DbTools.gSite.Site_APSAD!;
    if (siteApsad.isNotEmpty) {
      itemlistApp = json.decode(siteApsad).cast<bool>().toList();
    }
    for (int i = itemlistApp.length; i < 10; i++) {
      itemlistApp.add(false);
    }

    String siteApsadDate = DbTools.gSite.Site_APSAD_Date!;
    if (siteApsadDate.isNotEmpty) {
      String cleanedString = siteApsadDate.replaceAll("[", "").replaceAll("]", "").trim();
      itemlistDate= cleanedString.split(',').map((e) => e.trim()).toList();
      itemlistDate = itemlistDate.toList();
    }
    setState(() {});
  }

  void initState() {
    readonly = widget.readonly;
    initLib();
    super.initState();
  }

  DateTime wDateTime = DateTime.now();
  String  wDateTimeText = "        ";


  Widget APSAD(BuildContext context) {
    print("_buildPopupDialog");

    List<Widget> cclistMes = [];
    for (int i = 0; i < listMes.length; i++) {
      var wlistMes = listMes[i];
      var witemlistApp = false;
      var witemlistDate = "";
      if (i < itemlistApp.length) {
        witemlistApp = itemlistApp[i];
        witemlistDate = itemlistDate[i];
      }
      readonly
          ? cclistMes.add(gColors.CheckBoxFieldReadOnly(
              400,
              8,
              "$wlistMes",
              witemlistApp,
            ))
          : cclistMes.add(
          Row(children: [
            gColors.CheckBoxField(
                400,
                8,
                "$wlistMes",
                witemlistApp,
                    (sts) => setState(() {
                  itemlistApp[i] = sts!;
                  print("itemlistApp ${itemlistApp.toString()}");
                })),

            !witemlistApp ? Container() :
            Container(

                child: Center(
                    child: InkWell(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 80,
                            child: Text(
                              itemlistDate[i],
                              style: gColors.bodySaisie_B_B,
                            ),
                          ),

                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(context: context, initialDate: wDateTime, firstDate: DateTime(DateTime.now().year - 10), lastDate: DateTime(DateTime.now().year + 10));
                        if (pickedDate != null) {
                          wDateTime = pickedDate;
                          print("pickedDate ${pickedDate}");
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          print("formattedDate ${formattedDate}");
                          setState(() {
                            itemlistDate[i] = formattedDate;
                          });
                        } else {}
                      },
                    ))),
          ],)
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: cclistMes),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    double height = 450; //MediaQuery.of(context).size.height - 200;
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
                "Paramètres Site",
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
                "APSAD",
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
                  DbTools.gSite.Site_APSAD = itemlistApp.toString();
                  DbTools.gSite.Site_APSAD_Date = itemlistDate.toString();
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
