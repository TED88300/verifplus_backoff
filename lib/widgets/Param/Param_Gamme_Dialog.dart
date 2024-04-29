import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Gamme.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Param_Gamme_Dialog {
  Param_Gamme_Dialog();
  static Future<void> Param_Dialog(
    BuildContext context,
    String wType,
    String wTitle,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Param_Gamme_screen(
        wType: wType,
        wTitle: wTitle,
      ),
    );
  }
}

class Param_Gamme_screen extends StatefulWidget {
  final String wType;
  final String wTitle;
  const Param_Gamme_screen({Key? key, required this.wType, required this.wTitle}) : super(key: key);

  @override
  _Param_Gamme_screenState createState() => _Param_Gamme_screenState();
}

class _Param_Gamme_screenState extends State<Param_Gamme_screen> {
  Param_Gamme wParam_Gamme = Param_Gamme.Param_GammeInit();
  String Title = "Paramètres ";

  static List<String> ListParam_ParamOrgane = [];
  static List<String> ListParam_ParamOrganeID = [];
  String selectedValueOrgane = "";
  String selectedValueOrganeID = "";

  static List<String> ListDesc = [];
  static List<String> ListDescID = [];
  String selectedValueDesc = "";
  String selectedValueDescID = "";

  static List<String> ListFab = [];
  static List<String> ListFabID = [];
  String selectedValueFab = "";
  String selectedValueFabID = "";

  static List<String> ListPrs = [];
  static List<String> ListPrsID = [];
  String selectedValuePrs = "";
  String selectedValuePrsID = "";

  static List<String> ListClf = [];
  static List<String> ListClfID = [];
  String selectedValueClf = "";
  String selectedValueClfID = "";

  static List<String> ListMob = [];
  static List<String> ListMobID = [];
  String selectedValueMob = "";
  String selectedValueMobID = "";

  static List<String> ListGam = [];
  static List<String> ListGamID = [];
  String selectedValueGam = "";
  String selectedValueGamID = "";

  static List<String> ListPdt = [];
  static List<String> ListPdtID = [];
  String selectedValuePdt = "";
  String selectedValuePdtID = "";

  static List<String> ListPoids = [];
  static List<String> ListPoidsID = [];
  String selectedValuePoids = "";
  String selectedValuePoidsID = "";

  bool isK = false;

  bool isNotLoad = true;

  Future LoadCSV() async {
    var myData = await rootBundle.loadString('assets/GAMME.csv');

    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(eol: "\r", fieldDelimiter: ";", shouldParseNumbers: false).convert(myData);

    print("LoadCSV ${rowsAsListOfValues.length} ${rowsAsListOfValues[0].length}");
    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      // for (var i = 1; i < 10; i++) {
      if (rowsAsListOfValues[i].length != 10) continue;
      print("LoadCSV ${rowsAsListOfValues[i]}");
      String wDESC = rowsAsListOfValues[i][1].trim();
      String wFAB = rowsAsListOfValues[i][2].trim();
      String wPRS = rowsAsListOfValues[i][3].trim();
      String wCLF = rowsAsListOfValues[i][4].trim();
      String wMOB = rowsAsListOfValues[i][5].trim();
      String wPDT = rowsAsListOfValues[i][6].trim();
      String wPOIDS = rowsAsListOfValues[i][7].trim();
      String wGAM = rowsAsListOfValues[i][8].trim();
      String wREF = rowsAsListOfValues[i][9].trim();

      print("$i D |$wDESC| ${ListDesc.length}");
      GetDesc(wDESC);
      print("$wDESC > $selectedValueDescID $selectedValueDesc");

      print("F |$wFAB| ${ListFab.length}");
      GetFab(wFAB);
      print("$wFAB > $selectedValueFabID $selectedValueFab");

      print("P |$wPRS| ${ListPrs.length}");
      GetPrs(wPRS);
      print("$wPRS > $selectedValuePrsID $selectedValuePrs");

      print("C |$wCLF| ${ListClf.length}");
      GetClf(wCLF);
      print("$wCLF > $selectedValueClfID $selectedValueClf");

      print("M |$wMOB| ${ListMob.length}");
      GetMob(wMOB);
      print("$wMOB > $selectedValueMobID $selectedValueMob");

      print("G |$wGAM| ${ListGam.length}");
      GetGam(wGAM);
      print("$wGAM > $selectedValueGamID $selectedValueGam");

      print("Pdt |$wPDT| ${ListPdt.length}");
      GetPdt(wPDT);
      print("$wPDT > $selectedValuePdtID $selectedValuePdt");

      isK = wPOIDS.contains("K");
      wPOIDS = wPOIDS.replaceAll("Kilos", "").replaceAll("Litres", "").trim();
      print("Poids |$wPOIDS| ${ListPoids.length}");
      GetPoids(wPOIDS);
      selectedValuePoids = "$selectedValuePoids ${isK ? "Kg" : "L"}";
      print("$wPOIDS > $selectedValuePoidsID $selectedValuePoids");

      Param_Gamme wparamGamme = Param_Gamme.Param_GammeInit();
      wparamGamme.Param_Gamme_Type_Organe = selectedValueOrganeID;
      await DbTools.addParam_Gamme(wparamGamme);
      wparamGamme.Param_GammeId = DbTools.gLastID;
      wparamGamme.Param_Gamme_DESC_Id = int.parse(selectedValueDescID);
      wparamGamme.Param_Gamme_DESC_Lib = selectedValueDesc;

      wparamGamme.Param_Gamme_FAB_Id = int.parse(selectedValueFabID);
      wparamGamme.Param_Gamme_FAB_Lib = selectedValueFab;
      wparamGamme.Param_Gamme_PRS_Id = int.parse(selectedValuePrsID);
      wparamGamme.Param_Gamme_PRS_Lib = selectedValuePrs;
      wparamGamme.Param_Gamme_CLF_Id = int.parse(selectedValueClfID);
      wparamGamme.Param_Gamme_CLF_Lib = selectedValueClf;
      wparamGamme.Param_Gamme_MOB_Id = int.parse(selectedValueMobID);
      wparamGamme.Param_Gamme_MOB_Lib = selectedValueMob;
      wparamGamme.Param_Gamme_GAM_Id = int.parse(selectedValueGamID);
      wparamGamme.Param_Gamme_GAM_Lib = selectedValueGam;
      wparamGamme.Param_Gamme_PDT_Id = int.parse(selectedValuePdtID);
      wparamGamme.Param_Gamme_PDT_Lib = selectedValuePdt;
      wparamGamme.Param_Gamme_POIDS_Id = int.parse(selectedValuePoidsID);
      wparamGamme.Param_Gamme_POIDS_Lib = selectedValuePoids;
      wparamGamme.Param_Gamme_REF = wREF;
      wparamGamme.Param_Gamme_Ordre = 0;
      await DbTools.setParam_Gamme(wparamGamme);
    }
  }

  Future Reload() async {
    await DbTools.getParam_Gamme(selectedValueOrganeID);
    print("getParam_Gamme ${DbTools.ListParam_Gamme.length}");
    await Filtre();
    isNotLoad = false;
    setState(() {});
  }

  Future Filtre() async {
    DbTools.ListParam_Gammesearchresult.clear();
    DbTools.ListParam_Gammesearchresult.addAll(DbTools.ListParam_Gamme);
    DbTools.ListParam_Gammesearchresult.forEach((element) {
//      print("DbTools ${element.Param_Gamme_Type_Organe}");
    });

    //   _model = DaviModel<Param_Gamme>(rows: DbTools.ListParam_Gammesearchresult, columns: wColumns);

    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();
    print("getParam_Param ${DbTools.ListParam_Param.length}");

    await DbTools.getParam_Saisie_ParamAll();
    print("getParam_Saisie_ParamAll ${DbTools.ListParam_Saisie_Param.length}");

    ListParam_ParamOrgane.clear();
    ListParam_ParamOrganeID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        ListParam_ParamOrgane.add(element.Param_Param_Text);
        ListParam_ParamOrganeID.add(element.Param_Param_ID);
      }
    });
    selectedValueOrgane = ListParam_ParamOrgane[0];
    selectedValueOrganeID = ListParam_ParamOrganeID[0];

    print("ListParam_ParamOrgane ${ListParam_ParamOrgane.length}");

    ListDesc.clear();
    ListDescID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("DESC") == 0) {
        ListDesc.add(element.Param_Saisie_Param_Label);
        ListDescID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValueDesc = ListDesc[0];
    selectedValueDescID = ListDescID[0];

    ListFab.clear();
    ListFabID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("FAB") == 0) {
        ListFab.add(element.Param_Saisie_Param_Label);
        ListFabID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValueFab = ListFab[0];
    selectedValueFabID = ListFabID[0];

    ListPrs.clear();
    ListPrsID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("PRS") == 0) {
        ListPrs.add(element.Param_Saisie_Param_Label);
        ListPrsID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValuePrs = ListPrs[0];
    selectedValuePrsID = ListPrsID[0];

    ListClf.clear();
    ListClfID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("CLF") == 0) {
        ListClf.add(element.Param_Saisie_Param_Label);
        ListClfID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValueClf = ListClf[0];
    selectedValueClfID = ListClfID[0];

    ListMob.clear();
    ListMobID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("MOB") == 0) {
        ListMob.add(element.Param_Saisie_Param_Label);
        ListMobID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValueMob = ListMob[0];
    selectedValueMobID = ListMobID[0];

    ListGam.clear();
    ListGamID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("GAM") == 0) {
        ListGam.add(element.Param_Saisie_Param_Label);
        ListGamID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValueGam = ListGam[0];
    selectedValueGamID = ListGamID[0];

    ListPdt.clear();
    ListPdtID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("PDT") == 0) {
        ListPdt.add(element.Param_Saisie_Param_Label);
        ListPdtID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValuePdt = ListPdt[0];
    selectedValuePdtID = ListPdtID[0];

    ListPoids.clear();
    ListPoidsID.clear();
    DbTools.ListParam_Saisie_ParamAll.forEach((element) {
      if (element.Param_Saisie_Param_Id.compareTo("POIDS") == 0) {
        ListPoids.add(element.Param_Saisie_Param_Label);
        ListPoidsID.add(element.Param_Saisie_ParamId.toString());
      }
    });
    selectedValuePoids = ListPoids[0];
    selectedValuePoidsID = ListPoidsID[0];

//   await LoadCSV();

    Reload();
  }

  void initState() {
    super.initState();
    initLib();

    Title = "Paramètres - ${widget.wTitle}";
  }

  @override
  Widget build(BuildContext context) {
    print("build ${wParam_Gamme.Param_GammeId}");

    return
      isNotLoad
          ? Container()
          : Container(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 10,
                      ),
                      DropdownButtonOrgane(),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  color: wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty ? Colors.black : Colors.black12,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  if (wParam_Gamme.Param_Gamme_Ordre > 1) {
                                    DbTools.ListParam_Gammesearchresult.forEach((element) {
                                      print("AVANT ${element.Param_GammeId}");
                                    });

                                    DbTools.ListParam_Gammesearchresult.forEach((element) async {
                                      if (element.Param_Gamme_Ordre == wParam_Gamme.Param_Gamme_Ordre - 1) {
                                        element.Param_Gamme_Ordre = wParam_Gamme.Param_Gamme_Ordre;
                                        await DbTools.setParam_Gamme(element);
                                      } else if (element.Param_Gamme_Ordre == wParam_Gamme.Param_Gamme_Ordre) {
                                        element.Param_Gamme_Ordre = wParam_Gamme.Param_Gamme_Ordre - 1;
                                        await DbTools.setParam_Gamme(element);
                                        wParam_Gamme = element;
                                      }
                                    });

                                    DbTools.ListParam_Gammesearchresult.forEach((element) {
                                      print("APRES ${element.Param_GammeId}  ${element.Param_Gamme_Ordre}");
                                    });
                                    //wParam_Gamme.Param_Gamme_Ordre = wParam_Gamme.Param_Gamme_Ordre - 1;
                                    Reload();
                                    setState(() {});
                                  }
                                },
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty ? Colors.black : Colors.black12,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  if (wParam_Gamme.Param_Gamme_Ordre < DbTools.ListParam_Gammesearchresult.length) {
                                    Param_Gamme tmpparamGamme = Param_Gamme.Param_GammeInit();

                                    DbTools.ListParam_Gammesearchresult.forEach((element) {
                                      print("AVANT ${element.Param_GammeId}  ${element.Param_Gamme_Ordre}");
                                    });

                                    for (int i = DbTools.ListParam_Gammesearchresult.length - 1; i >= 0; i--) {
                                      Param_Gamme element = DbTools.ListParam_Gammesearchresult[i];

                                      if (element.Param_Gamme_Ordre == wParam_Gamme.Param_Gamme_Ordre) {
                                        element.Param_Gamme_Ordre = wParam_Gamme.Param_Gamme_Ordre + 1;
                                        await DbTools.setParam_Gamme(element);
                                        tmpparamGamme = element;
                                      } else if (element.Param_Gamme_Ordre == wParam_Gamme.Param_Gamme_Ordre + 1) {
                                        element.Param_Gamme_Ordre = wParam_Gamme.Param_Gamme_Ordre;
                                        await DbTools.setParam_Gamme(element);
                                      }
                                    }

                                    DbTools.ListParam_Gammesearchresult.forEach((element) {
                                      print("APRES ${element.Param_GammeId} ${element.Param_Gamme_Ordre}");
                                    });
                                    //wParam_Gamme.Param_Gamme_Ordre = wParam_Gamme.Param_Gamme_Ordre - 1;
                                    Reload();
                                    setState(() {});
                                    wParam_Gamme = tmpparamGamme;
                                  }
                                },
                              ),
                              Container(
                                width: 8,
                              ),
                              Container(
                                width: 50,
                                child: Text(
                                  "${wParam_Gamme.Param_GammeId}",
                                  style: gColors.bodySaisie_B_B,
                                ),
                              ),
                              Container(
                                width: 8,
                              ),
                              DropdownButtonFab(),
                              Container(
                                width: 8,
                              ),
                              DropdownButtonPrs(),
                              Container(
                                width: 8,
                              ),
                              DropdownButtonClf(),
                              Container(
                                width: 8,
                              ),
                              DropdownButtonMob(),
                              Container(
                                width: 8,
                              ),
                              DropdownButtonPdt(),
                              Container(
                                width: 8,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 150,
                              ),
                              DropdownButtonPoids(),
                              Text(
                                'KG(L) : ',
                                style: gColors.bodySaisie_B_B,
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                value: isK,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isK = value!;
                                  });
                                },
                              ),
                              Container(
                                width: 8,
                              ),
                              Container(
                                width: 8,
                              ),
                              DropdownButtonGam(),
                              Expanded(
                                child: Container(
                                  width: 50,
                                  child: _buildFieldText(context, wParam_Gamme),
                                ),
                              ),
                              Container(
                                width: 1,
                              ),
                              Tooltip(
                                textStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.normal),
                                decoration: BoxDecoration(color: Colors.orange),
                                message: "Sauvegarder",
                                child:
                              InkWell(
                                child: Icon(
                                  Icons.check,
                                  color: wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty ? Colors.blue : Colors.black12,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  if (wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty) {
                                    wParam_Gamme.Param_Gamme_FAB_Id = int.parse(selectedValueFabID);
                                    wParam_Gamme.Param_Gamme_FAB_Lib = selectedValueFab;

                                    wParam_Gamme.Param_Gamme_PRS_Id = int.parse(selectedValuePrsID);
                                    wParam_Gamme.Param_Gamme_PRS_Lib = selectedValuePrs;
                                    wParam_Gamme.Param_Gamme_CLF_Id = int.parse(selectedValueClfID);
                                    wParam_Gamme.Param_Gamme_CLF_Lib = selectedValueClf;
                                    wParam_Gamme.Param_Gamme_MOB_Id = int.parse(selectedValueMobID);
                                    wParam_Gamme.Param_Gamme_MOB_Lib = selectedValueMob;
                                    wParam_Gamme.Param_Gamme_GAM_Id = int.parse(selectedValueGamID);
                                    wParam_Gamme.Param_Gamme_GAM_Lib = selectedValueGam;
                                    wParam_Gamme.Param_Gamme_PDT_Id = int.parse(selectedValuePdtID);
                                    wParam_Gamme.Param_Gamme_PDT_Lib = selectedValuePdt;
                                    wParam_Gamme.Param_Gamme_POIDS_Id = int.parse(selectedValuePoidsID);
                                    wParam_Gamme.Param_Gamme_POIDS_Lib = "$selectedValuePoids ${isK ? "Kg" : "L"}";
                                    wParam_Gamme.Param_Gamme_REF = Param_Saisie_RefController.text;

                                    await DbTools.setParam_Gamme(wParam_Gamme);
                                    await Reload();
                                    wParam_Gamme = Param_Gamme.Param_GammeInit();
                                  }
                                },
                              )),
                              Container(
                                width: 1,
                              ),
                              Tooltip(
                                textStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.normal),
                                decoration: BoxDecoration(color: Colors.orange),
                                message: "Supprimer",
                                child:InkWell(
                                child: Icon(
                                  Icons.delete,
                                  color: wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty ? Colors.red : Colors.black12,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  if (wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty) {
                                    await DbTools.delParam_Gamme(wParam_Gamme);
                                    await Reload();
                                    wParam_Gamme = Param_Gamme.Param_GammeInit();
                                  }
                                },
                              )),
                              Tooltip(
                                textStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.normal),
                                decoration: BoxDecoration(color: Colors.orange),
                                message: "Ajouter",
                                child:
                              InkWell(
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                  size: 24.0,
                                ),
                                onTap: () {
                                  setState(() async {
                                    Param_Gamme tparamGamme = Param_Gamme.Param_GammeInit();
                                    tparamGamme.Param_Gamme_Type_Organe = selectedValueOrganeID;
                                    await DbTools.addParam_Gamme(tparamGamme);
                                    await Reload();
                                    setState(() {
                                      wParam_Gamme = tparamGamme;
                                      print("_onRowTap ${wParam_Gamme.Param_GammeId}");
                                      Reload();
                                    });
                                  });
                                },
                              )),
                              Container(
                                width: 1,
                              ),
                              Tooltip(
                                textStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.normal),
                                decoration: BoxDecoration(color: Colors.orange),
                                message: "Dupliquer",
                                child:                              InkWell(
                                child: Icon(
                                  Icons.control_point_duplicate,
                                  color: wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty ? Colors.green : Colors.black12,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  if (wParam_Gamme.Param_Gamme_Type_Organe.isNotEmpty) {
                                    await DbTools.addParam_Gamme(wParam_Gamme);
                                    wParam_Gamme.Param_GammeId = DbTools.gLastID;
                                    await DbTools.setParam_Gamme(wParam_Gamme);
                                    await Reload();
                                    setState(() {
                                      print("_onRowTap ${wParam_Gamme.Param_GammeId}");
                                      Reload();
                                    });
                                  }
                                },
                              )),
                            ],
                          ),
                        ],
                      )
                  ),

                  Container(
                    height: 10,
                  ),

                  Param_GammeGridWidget(),



                ],
              ),

    );
  }

  Widget Param_GammeGridWidget() {
    List<DaviColumn<Param_Gamme>> wColumns = [
      new DaviColumn(
          name: 'Id',
          grow: 1,
          stringValue: (row) => "${row.Param_GammeId} ${row.Param_Gamme_Ordre}"
              ""),
      new DaviColumn(name: 'Fabriquant', grow: 18, stringValue: (row) => "${row.Param_Gamme_FAB_Lib}"),
      new DaviColumn(name: 'Presssion', grow: 1, stringValue: (row) => "${row.Param_Gamme_PRS_Lib}"),
      new DaviColumn(name: 'Classes', grow: 1, stringValue: (row) => "${row.Param_Gamme_CLF_Lib}"),
      new DaviColumn(name: 'Maniabilite', grow: 18, stringValue: (row) => "${row.Param_Gamme_MOB_Lib}"),
      new DaviColumn(name: 'Modèle', grow: 18, stringValue: (row) => "${row.Param_Gamme_PDT_Lib}"),
      new DaviColumn(name: 'Charge', grow: 1, stringValue: (row) => "${row.Param_Gamme_POIDS_Lib}"),
      new DaviColumn(name: 'Gamme', grow: 18, stringValue: (row) => "${row.Param_Gamme_GAM_Lib}"),
      new DaviColumn(name: 'Ref', grow: 1, stringValue: (row) => "${row.Param_Gamme_REF}"),
    ];

    print("Param_GammeGridWidget");
    DaviModel<Param_Gamme>? _model;

    _model = DaviModel<Param_Gamme>(rows: DbTools.ListParam_Gammesearchresult, columns: wColumns);

    return new DaviTheme(
        child: new Davi<Param_Gamme>(
          _model,
          visibleRowsCount: 18,
          onRowTap: (paramGamme) => _onRowTap(context, paramGamme),
        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************

  void _onRowTap(BuildContext context, Param_Gamme paramGamme) {
    setState(() {
      wParam_Gamme = paramGamme;

      GetFab(wParam_Gamme.Param_Gamme_FAB_Lib);
      GetPrs(wParam_Gamme.Param_Gamme_PRS_Lib);
      GetClf(wParam_Gamme.Param_Gamme_CLF_Lib);
      GetMob(wParam_Gamme.Param_Gamme_MOB_Lib);
      GetGam(wParam_Gamme.Param_Gamme_GAM_Lib);
      GetPdt(wParam_Gamme.Param_Gamme_PDT_Lib);
      isK = wParam_Gamme.Param_Gamme_POIDS_Lib.contains("K");
      String wpoidsLib = wParam_Gamme.Param_Gamme_POIDS_Lib.replaceAll("Kg", "").replaceAll("L", "").trim();
      GetPoids(wpoidsLib);

      print("_onRowTap ${wParam_Gamme.Param_GammeId}");
    });
  }

  Widget _buildDelete(BuildContext context, DaviRow<Param_Gamme> rowData) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 18.0,
      ),
      onPressed: () async {
        DbTools.delParam_Gamme(rowData.data);
        await Reload();
      },
    );
  }

  Widget DropdownButtonOrgane() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un organe',
        style: gColors.bodyTitle1_N_Gr,
      ),
      items: ListParam_ParamOrgane.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodyTitle1_N_Gr,
            ),
          )).toList(),
      value: selectedValueOrgane,
      onChanged: (value) {
        setState(() {
          selectedValueOrganeID = ListParam_ParamOrganeID[ListParam_ParamOrgane.indexOf(value!)];
          selectedValueOrgane = value;

          print("selectedValueOrgane $selectedValueOrganeID $selectedValueOrgane");
          Reload();
        });
      },
      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
      buttonDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black26,
        ),
        color: Colors.white,
      ),
      buttonHeight: 30,
      buttonWidth: 350,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetDesc(String value) {
    if (value.isEmpty) {
      selectedValueDesc = ListDesc[0];
      selectedValueDescID = ListDescID[0];
      return;
    }

    int wIdx = ListDesc.indexOf(value);
    print("GetDesc |$value| $wIdx ${ListDesc.length}");

    selectedValueDescID = ListDescID[wIdx];
    selectedValueDesc = value;
    setState(() {});
  }

  void GetFab(String value) {
    if (value.isEmpty) {
      selectedValueFab = ListFab[0];
      selectedValueFabID = ListFabID[0];
      return;
    }

    int wIdx = ListFab.indexOf(value);
    print("GetFab |$value| $wIdx ${ListFab.length}");

    selectedValueFabID = ListFabID[wIdx];
    selectedValueFab = value;
    setState(() {});
  }

  Widget DropdownButtonFab() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un Fabriquant',
        style: gColors.bodySaisie_N_G,
      ),
      items: ListFab.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValueFab,
      onChanged: (value) {
        GetFab(value!);
      },
      buttonHeight: 50,
      buttonWidth: 220,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetPrs(String value) {
    if (value.isEmpty) {
      selectedValuePrs = ListPrs[0];
      selectedValuePrsID = ListPrsID[0];
      return;
    }

    selectedValuePrsID = ListPrsID[ListPrs.indexOf(value)];
    selectedValuePrs = value;
    setState(() {});
  }

  Widget DropdownButtonPrs() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: ListPrs.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValuePrs,
      onChanged: (value) {
        GetPrs(value!);
      },
      buttonHeight: 50,
      buttonWidth: 120,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetClf(String value) {
    if (value.isEmpty) {
      selectedValueClf = ListClf[0];
      selectedValueClfID = ListClfID[0];
      return;
    }

    selectedValueClfID = ListClfID[ListClf.indexOf(value)];
    selectedValueClf = value;
    setState(() {});
  }

  Widget DropdownButtonClf() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: ListClf.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValueClf,
      onChanged: (value) {
        GetClf(value!);
      },
      buttonHeight: 50,
      buttonWidth: 120,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetMob(String value) {
    if (value.isEmpty) {
      selectedValueMob = ListMob[0];
      selectedValueMobID = ListMobID[0];
      return;
    }

    int wIdx = ListMob.indexOf(value);
    print("GetMob |$value| $wIdx ${ListMob.length}");

    selectedValueMobID = ListMobID[wIdx];
    selectedValueMob = value;
    setState(() {});
  }

  Widget DropdownButtonMob() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: ListMob.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValueMob,
      onChanged: (value) {
        GetMob(value!);
      },
      buttonHeight: 50,
      buttonWidth: 220,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetGam(String value) {
    if (value.isEmpty) {
      selectedValueGam = ListGam[0];
      selectedValueGamID = ListGamID[0];
      return;
    }

    int wIdx = ListGam.indexOf(value);
    print("GetGam |$value| $wIdx ${ListGam.length}");

    selectedValueGamID = ListGamID[wIdx];

    selectedValueGam = value;
    setState(() {});
  }

  Widget DropdownButtonGam() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: ListGam.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValueGam,
      onChanged: (value) {
        GetGam(value!);
      },
      buttonHeight: 50,
      buttonWidth: 300,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetPdt(String value) {
    if (value.isEmpty) {
      selectedValuePdt = ListPdt[0];
      selectedValuePdtID = ListPdtID[0];
      return;
    }

    selectedValuePdtID = ListPdtID[ListPdt.indexOf(value)];
    selectedValuePdt = value;
    setState(() {});
  }

  Widget DropdownButtonPdt() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: ListPdt.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValuePdt,
      onChanged: (value) {
        GetPdt(value!);
      },
      buttonHeight: 50,
      buttonWidth: 220,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  void GetPoids(String value) {
    if (value.isEmpty) {
      selectedValuePoids = ListPoids[0];
      selectedValuePoidsID = ListPoidsID[0];
      isK = true;
      return;
    }

    selectedValuePoidsID = ListPoidsID[ListPoids.indexOf(value)];
    selectedValuePoids = value;
    setState(() {});
  }

  Widget DropdownButtonPoids() {
    selectedValuePoids = selectedValuePoids.replaceAll("Kg", "").replaceAll("L", "").trim();

    print("selectedValuePoids $selectedValuePoids");
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: ListPoids.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
      value: selectedValuePoids,
      onChanged: (value) {
        GetPoids(value!);
      },
      buttonHeight: 50,
      buttonWidth: 100,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }

  final Param_Saisie_RefController = TextEditingController();
  Widget _buildFieldText(BuildContext context, Param_Gamme paramGamme) {
    Param_Saisie_RefController.text = paramGamme.Param_Gamme_REF;
    return TextFormField(
      controller: Param_Saisie_RefController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }
}
