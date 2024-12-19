import 'package:davi/davi.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Param_Param_Dialog {
  Param_Param_Dialog();

  static Future<void> Param_Dialog(
    BuildContext context,
    String wType,
    String wTitle,
    bool  wDef,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Param_Param_screen(
        wType: wType,
        wTitle: wTitle,
          wDef : wDef,

      ),
    );
  }
}

class Param_Param_screen extends StatefulWidget {
  final String wType;
  final  String wTitle;
  final bool  wDef;

  const Param_Param_screen({Key? key, required this.wType, required this.wTitle, required this.wDef}) : super(key: key);

  @override
  _Param_Param_screenState createState() => _Param_Param_screenState();
}

class _Param_Param_screenState extends State<Param_Param_screen> {
  Param_Param wParam_Param = Param_Param.Param_ParamInit();
  String Title = "Paramètres ";

  static List<String> ListParam_ParamColor = [];
  static List<String> ListParam_ParamColorID = [];
  String selectedValueColor = "";
  String selectedValueColorID = "";

//  List<DaviColumn<Param_Param>> wColumns = [];
  bool bReload = true;

  Future Reload() async {
    await DbTools.getParam_Param(widget.wType, bReload);
    bReload = false;
    print("getParam_Param ${DbTools.ListParam_Param.length}");

    await Filtre();

  }

  Future Filtre() async {
    DbTools.ListParam_Paramsearchresult.clear();
    DbTools.ListParam_Paramsearchresult.addAll(DbTools.ListParam_Param);
    DbTools.ListParam_Paramsearchresult.forEach((element) {
      print("DbTools ${element.Param_Param_ID} ${element.Param_ParamId}");
    });
    setState(() {});
  }

  void initLib() async {
    ListParam_ParamColor.clear();
    ListParam_ParamColorID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Color") == 0) {
        ListParam_ParamColor.add(element.Param_Param_Text);
        ListParam_ParamColorID.add(element.Param_Param_ID);
      }
    });

    print("ListParam_ParamColor ${ListParam_ParamColor.length}");

    selectedValueColor = ListParam_ParamColor[0];
    selectedValueColorID = ListParam_ParamColorID[0];

    print("selectedValueColor $selectedValueColorID $selectedValueColor");

    Reload();
  }

  void initState() {
    super.initState();
    initLib();

    Title = "Paramètres - ${widget.wTitle}";
  }

  @override
  Widget build(BuildContext context) {
    print("build ${wParam_Param.Param_Param_ID}");
    print("Param_Param_screen build ${widget.wType} -${widget.wTitle} bReload - $bReload");
    if (!bReload && DbTools.gDemndeReload) {
      Reload();
    }
    DbTools.gDemndeReload = false;

    return
      Material(child: Container(
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
              child: Row(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: wParam_Param.Param_Param_ID.isNotEmpty ? Colors.black : Colors.black12,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (wParam_Param.Param_Param_Ordre > 1) {
                        DbTools.ListParam_Paramsearchresult.forEach((element) {
                          print("AVANT ${element.Param_Param_ID}");
                        });
                        DbTools.ListParam_Paramsearchresult.forEach((element) {
                          if (element.Param_Param_Ordre == wParam_Param.Param_Param_Ordre - 1) {
                            element.Param_Param_Ordre = wParam_Param.Param_Param_Ordre;
                            DbTools.setParam_Param(element);
                          } else if (element.Param_Param_Ordre == wParam_Param.Param_Param_Ordre) {
                            element.Param_Param_Ordre = wParam_Param.Param_Param_Ordre - 1;
                            DbTools.setParam_Param(element);
                            wParam_Param = element;
                          }
                        });

                        DbTools.ListParam_Paramsearchresult.forEach((element) {
                          print("APRES ${element.Param_Param_ID}  ${element.Param_Param_Ordre}");
                        });
                        //wParam_Param.Param_Param_Ordre = wParam_Param.Param_Param_Ordre - 1;
                        Reload();
                        setState(() {});
                      }
                    },
                  ),
                  InkWell(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: wParam_Param.Param_Param_ID.isNotEmpty ? Colors.black : Colors.black12,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (wParam_Param.Param_Param_Ordre < DbTools.ListParam_Paramsearchresult.length) {
                        Param_Param tmpparamParam = Param_Param.Param_ParamInit();

                        DbTools.ListParam_Paramsearchresult.forEach((element) {
                          print("AVANT ${element.Param_Param_ID}  ${element.Param_Param_Ordre}");
                        });

                        for (int i = DbTools.ListParam_Paramsearchresult.length - 1; i >= 0; i--) {
                          Param_Param element = DbTools.ListParam_Paramsearchresult[i];

                          if (element.Param_Param_Ordre == wParam_Param.Param_Param_Ordre) {
                            element.Param_Param_Ordre = wParam_Param.Param_Param_Ordre + 1;
                            DbTools.setParam_Param(element);
                            tmpparamParam = element;
                          } else if (element.Param_Param_Ordre == wParam_Param.Param_Param_Ordre + 1) {
                            element.Param_Param_Ordre = wParam_Param.Param_Param_Ordre;
                            DbTools.setParam_Param(element);
                          }
                        }

                        DbTools.ListParam_Paramsearchresult.forEach((element) {
                          print("APRES ${element.Param_Param_ID} ${element.Param_Param_Ordre}");
                        });
                        //wParam_Param.Param_Param_Ordre = wParam_Param.Param_Param_Ordre - 1;
                        Reload();
                        setState(() {});
                        wParam_Param = tmpparamParam;
                      }
                    },
                  ),
                  Container(
                    width: 8,
                  ),
                  Container(
                    width: 90,
                    child: _buildFieldID(context, wParam_Param),
                  ),
                  Container(
                    width: 8,
                  ),
                  Container(
                    width: 580,
                    child: _buildFieldText(context, wParam_Param),
                  ),
                  Container(
                    width: 8,
                  ),
                  Container(
                    width: 10,
                  ),
                  DropdownButtonColor(),


                  if (widget.wDef)
                    Text(
                    'Défaut : ',
                    style: gColors.bodySaisie_B_B,
                  ),
                  if (widget.wDef)
                  Checkbox(
                    checkColor: Colors.white,
                    value: wParam_Param.Param_Param_Default,
                    onChanged: (bool? value) {
                      setState(() {
                        wParam_Param.Param_Param_Default = value!;
                      });
                    },
                  ),


                  Container(
                    width: 1,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.check,
                      color: wParam_Param.Param_Param_ID.isNotEmpty ? Colors.blue : Colors.black12,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (wParam_Param.Param_Param_ID.isNotEmpty) {
                        wParam_Param.Param_Param_Text = Param_Param_TextController.text;
                        wParam_Param.Param_Param_Color = selectedValueColor;
                        wParam_Param.Param_Param_ID = Param_Param_IDController.text;
                        await DbTools.setParam_Param(wParam_Param);


                        if (widget.wDef)
                          if (wParam_Param.Param_Param_Default) {
                          DbTools.ListParam_Param.forEach((element) async {
                            if (wParam_Param.Param_ParamId != element.Param_ParamId) {
                              element.Param_Param_Default = false;
                              await DbTools.setParam_Param(element);
                            }
                          });
                        }



                        await Reload();
                        wParam_Param = Param_Param.Param_ParamInit();
                      }
                    },
                  ),
                  Container(
                    width: 1,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.delete,
                      color: wParam_Param.Param_Param_ID.isNotEmpty ? Colors.red : Colors.black12,
                      size: 24.0,
                    ),
                    onTap: () async {
                      if (wParam_Param.Param_Param_ID.isNotEmpty) {
                        await DbTools.delParam_Param(wParam_Param);
                        await Reload();
                        wParam_Param = Param_Param.Param_ParamInit();
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
                      Param_Param paramParam = await Param_Param.Param_ParamInit();
                      paramParam.Param_Param_Type = widget.wType;
                      await DbTools.addParam_Param(paramParam);
                      await Reload();
                      setState(() {
                        print("wParam_Param ${DbTools.gLastID}");
                        wParam_Param = DbTools.ListParam_Paramsearchresult.firstWhere((element) => element.Param_ParamId == DbTools.gLastID);
                        print("wParam_Param $wParam_Param");


                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Param_ParamGridWidget(),


          ],
        ),

    ),);
  }


  Widget Param_ParamGridWidget() {
    List<DaviColumn<Param_Param>> wColumns = [
      new DaviColumn(
          grow: 2,
          name: 'Id',
          stringValue: (row) => "${row.Param_Param_ID} ${row.Param_Param_Ordre}"
              ""),
      new DaviColumn(name: 'Libellé', grow: 18, stringValue: (row) => row.Param_Param_Text),
      new DaviColumn(name: 'Couleur', grow: 2, stringValue: (row) => row.Param_Param_Color),

      if (widget.wDef)
      DaviColumn(
          name: 'Défaut',
          cellBuilder: (BuildContext context, DaviRow<Param_Param> data) {
            return Checkbox(
              checkColor: Colors.white,
              value: data.data.Param_Param_Default,
              onChanged: (bool? value) {

                print("   Défaut");

                setState(() {});
              },
            );
          }),

    ];

    print("Param_Param_Dialog Param_ParamGridWidget");
    DaviModel<Param_Param>? _model;
    _model = DaviModel<Param_Param>(rows: DbTools.ListParam_Paramsearchresult, columns: wColumns);
    return new DaviTheme(
        child: new Davi<Param_Param>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (paramParam) => _onRowTap(context, paramParam),
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

  void _onRowTap(BuildContext context, Param_Param paramParam) {
    setState(() {
      wParam_Param = paramParam;
      print("_onRowTap ${wParam_Param.Param_Param_ID}");

      ListParam_ParamColorID.forEach((element) {
        if (element.compareTo(wParam_Param.Param_Param_Color) == 0) {
          selectedValueColorID = element;
          selectedValueColor = ListParam_ParamColor[ListParam_ParamColorID.indexOf(element)];
        }
      });



    });
  }


  final Param_Param_TextController = TextEditingController();

  Widget _buildFieldText(BuildContext context, Param_Param paramParam) {
    print("_buildFieldText ${paramParam.Param_Param_Text} ${wParam_Param.Param_Param_Text}");
    Param_Param_TextController.text = paramParam.Param_Param_Text;
    return TextFormField(
      controller: Param_Param_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }



  final Param_Param_IDController = TextEditingController();
  Widget _buildFieldID(BuildContext context, Param_Param paramParam) {
    Param_Param_IDController.text = paramParam.Param_Param_ID;
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
      ),
      controller: Param_Param_IDController,
      style: gColors.bodySaisie_B_B,
    );
  }

  Widget _buildDelete(BuildContext context, DaviRow<Param_Param> rowData) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 18.0,
      ),
      onPressed: () async {
        DbTools.delParam_Param(rowData.data);
        await Reload();
      },
    );
  }

  Widget DropdownButtonColor() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            'Couleur',
            style: gColors.bodySaisie_N_G,
          ),
          items: ListParam_ParamColor.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodySaisie_N_G,
            ),
          )).toList(),
          value: selectedValueColor,
          onChanged: (value) {
            setState(() {
              selectedValueColorID = ListParam_ParamColorID[ListParam_ParamColor.indexOf(value!)];
              selectedValueColor = value;
              print("selectedValueColor $selectedValueColorID $selectedValueColor");
            });
          },
          buttonStyleData: const ButtonStyleData(
              height: 50,
              width: 150
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
          ),

        ));
  }


}
