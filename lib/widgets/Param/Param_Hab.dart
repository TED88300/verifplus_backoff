import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Hab.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Param_Hab_screen extends StatefulWidget {

  @override
  _Param_Hab_screenState createState() => _Param_Hab_screenState();
}

class _Param_Hab_screenState extends State<Param_Hab_screen> {
  Param_Hab wParam_Hab = Param_Hab.Param_HabInit();
  String Title = "Verif+ : Paramètres Habilitation ";

  static List<String> ListParam_GrpHab = [];
  static List<String> ListParam_GrpHabID = [];
  String selectedValueGrpHab = "";
  String selectedValueGrpHabID = "";


//  List<EasyTableColumn<Param_Param>> wColumns = [];

  Future Reload() async {
    await DbTools.getParam_HabAll();
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListParam_Habsearchresult.clear();
    DbTools.ListParam_Habsearchresult.addAll(DbTools.ListParam_Hab);

    print("DbTools.ListParam_Habsearchresult ${DbTools.ListParam_Habsearchresult.length}");
    setState(() {});
  }


  void initLib() async {



    await DbTools.getParam_ParamAll();

    ListParam_GrpHab.clear();
    ListParam_GrpHabID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("GrpHab") == 0) {
        ListParam_GrpHab.add(element.Param_Param_Text);
        ListParam_GrpHabID.add(element.Param_Param_ID);
      }
    });
    selectedValueGrpHab = ListParam_GrpHab[0];
    selectedValueGrpHabID = ListParam_GrpHabID[0];

    print ("ListParam_GrpHab ${ListParam_GrpHab.toString()}");



    Reload();
  }

  void initState() {
    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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



                  Row(children: [
                    InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: wParam_Hab.Param_HabId != 0 ? Colors.black : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Hab.Param_Hab_Ordre > 1) {
                          DbTools.ListParam_Habsearchresult.forEach((element) {
                            print("AVANT ${element.Param_HabId}");
                          });

                          DbTools.ListParam_Habsearchresult.forEach((element) {
                            if (element.Param_Hab_Ordre == wParam_Hab.Param_Hab_Ordre - 1) {
                              element.Param_Hab_Ordre = wParam_Hab.Param_Hab_Ordre;
                              DbTools.setParam_Hab(element);
                            } else if (element.Param_Hab_Ordre == wParam_Hab.Param_Hab_Ordre) {
                              element.Param_Hab_Ordre = wParam_Hab.Param_Hab_Ordre - 1;
                              DbTools.setParam_Hab(element);
                              wParam_Hab = element;
                            }
                          });

                          DbTools.ListParam_Habsearchresult.forEach((element) {
                            print("APRES ${element.Param_HabId}  ${element.Param_Hab_Ordre}");
                          });
                          //wParam_Hab.Param_Hab_Ordre = wParam_Hab.Param_Hab_Ordre - 1;
                          Reload();
                          setState(() {});
                        }
                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: wParam_Hab.Param_HabId != 0 ? Colors.black : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Hab.Param_Hab_Ordre < DbTools.ListParam_Saisie_Paramsearchresult.length) {
                          Param_Hab tmpparamHab = Param_Saisie_Param.Param_Saisie_ParamInit();

                          DbTools.ListParam_Habsearchresult.forEach((element) {
                            print("AVANT ${element.Param_HabId}  ${element.Param_Hab_Ordre}");
                          });

                          for (int i = DbTools.ListParam_Habsearchresult.length - 1; i >= 0; i--) {
                            Param_Hab element = DbTools.ListParam_Habsearchresult[i];
                            if (element.Param_Hab_Ordre == wParam_Hab.Param_Hab_Ordre) {
                              element.Param_Hab_Ordre = wParam_Hab.Param_Hab_Ordre + 1;
                              DbTools.setParam_Hab(element);
                              tmpparamHab = element;
                            } else if (element.Param_Hab_Ordre == wParam_Hab.Param_Hab_Ordre + 1) {
                              element.Param_Hab_Ordre = wParam_Hab.Param_Hab_Ordre;
                              DbTools.setParam_Hab(element);
                            }
                          }

                          DbTools.ListParam_Habsearchresult.forEach((element) {
                            print("APRES ${element.Param_HabId}  ${element.Param_Hab_Ordre}");
                          });
                          //wParam_Hab.Param_Hab_Ordre = wParam_Hab.Param_Hab_Ordre - 1;
                          Reload();
                          setState(() {});
                          wParam_Hab = tmpparamHab;
                        }
                      },
                    ),



                    Container(
                      width: 8,
                    ),
                    Container(
                      width: 320,
                      child: _buildFieldPDTText(context, wParam_Hab),
                    ),

                    Container(
                      width: 8,
                    ),
                    Container(
                      width: 320,
                      child: DropdownButtonGrpHab(),
                    ),



                    Container(
                      width: 8,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.check,
                        color: wParam_Hab.Param_HabId != 0 ? Colors.blue : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Hab.Param_HabId != 0) {
                          wParam_Hab.Param_Hab_PDT = Param_Hab_PDT_TextController.text;
                          wParam_Hab.Param_Hab_Grp = selectedValueGrpHab;
                          await DbTools.setParam_Hab(wParam_Hab);
                          await Reload();
                          wParam_Hab = Param_Hab.Param_HabInit();
                        }
                      },
                    ),
                    Container(
                      width: 1,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.delete,
                        color: wParam_Hab.Param_HabId != 0 ? Colors.red : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Hab.Param_HabId != 0) {
                          await DbTools.delParam_Hab(wParam_Hab);
                          await Reload();
                          wParam_Hab = Param_Hab.Param_HabInit();
                        }
                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.green,
                        size: 24.0,
                      ),
                      onTap: () async {
                        Param_Hab paramHab = Param_Hab.Param_HabInit();
                        await DbTools.addParam_Hab(paramHab);
                        paramHab.Param_HabId = DbTools.gLastID;
                        await DbTools.setParam_Hab(paramHab);
                        await Reload();
                        wParam_Hab = paramHab;
                        print("_onRowTap ${paramHab.Param_Hab_PDT}");
                      },
                    ),
                  ]),
                  Row(
                    children: [
                      Container(
                        width: 50,
                      ),


                      Container(
                        width: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Param_Saisie_ParamGridWidget(),




          ],
        ),

    );
  }



  final Param_Hab_PDT_LigneTextController = TextEditingController();

  Widget _buildLigneFieldPdt(BuildContext context, RowData<Param_Hab> data) {


    return TextFormField(
      key: Key(data.row.Param_Hab_PDT),
//      controller:  TextEditingController()..text = data.row.Param_Hab_PDT,
      initialValue: data.row.Param_Hab_PDT,
      onChanged: (value) => _onFieldChangeLabel(value, data.row),
      style: gColors.bodySaisie_B_B,
    );
  }
  void _onFieldChangeLabel(String value, Param_Hab paramHab) async {
    paramHab.Param_Hab_PDT = value;
    await DbTools.setParam_Hab(paramHab);
//    setState(() {});
  }


  Widget Param_Saisie_ParamGridWidget() {
    List<EasyTableColumn<Param_Hab>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.Param_HabId} ${row.Param_Hab_Ordre}"),
      new EasyTableColumn(name: 'Modèle', grow: 12, cellBuilder: _buildLigneFieldPdt,),
      new EasyTableColumn(name: 'Groupe', grow: 12, stringValue: (row) => "${row.Param_Hab_Grp}"),
    ];

    print("Param_HabGridWidget");
    EasyTableModel<Param_Hab>? _model;

    _model = EasyTableModel<Param_Hab>(rows: DbTools.ListParam_Habsearchresult, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<Param_Hab>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (paramHab) => _onRowTap(context, paramHab),
        ),
        data: EasyTableThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColor: Colors.black, expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************

  void GetGrpHab(String value) {
    if (value.isEmpty) {
      selectedValueGrpHab = ListParam_GrpHab[0];
      selectedValueGrpHabID = ListParam_GrpHabID[0];
      return;
    }

    selectedValueGrpHabID = ListParam_GrpHabID[ListParam_GrpHab.indexOf(value)];
    selectedValueGrpHab = value;
    setState(() {});
  }

  Widget DropdownButtonGrpHab() {


    print ("ListParam_GrpHab ${ListParam_GrpHab.toString()}");
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: ListParam_GrpHab.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
          value: selectedValueGrpHab,
          onChanged: (value) {
            GetGrpHab(value!);
          },
          buttonHeight: 50,
          buttonWidth: 120,
          dropdownMaxHeight: 250,
          itemHeight: 32,
        ));
  }


//**********************************
//**********************************
//**********************************

  void _onRowTap(BuildContext context, Param_Hab paramHab) {
    setState(() {
      wParam_Hab = paramHab;
      print("_onRowTap ${wParam_Hab.Param_Hab_PDT}");
    });
  }

  final Param_Hab_PDT_TextController = TextEditingController();
  Widget _buildFieldPDTText(BuildContext context, Param_Hab paramHab) {
    print(">>>>>>>>> Param_Hab_PDT_TextController ${paramHab.Param_Hab_PDT}");
    Param_Hab_PDT_TextController.text = paramHab.Param_Hab_PDT;
    return TextFormField(
      controller: Param_Hab_PDT_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }


  Widget _buildDelete(BuildContext context, RowData<Param_Saisie_Param> rowData) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 18.0,
      ),
      onPressed: () async {
        DbTools.delParam_Saisie_Param(rowData.row);
        await Reload();
      },
    );
  }


}
