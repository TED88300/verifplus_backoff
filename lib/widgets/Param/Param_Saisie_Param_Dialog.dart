import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Param_Saisie_Param_screen extends StatefulWidget {
  final String wType;

  const Param_Saisie_Param_screen({Key? key, required this.wType}) : super(key: key);
  @override
  _Param_Saisie_Param_screenState createState() => _Param_Saisie_Param_screenState();
}

class _Param_Saisie_Param_screenState extends State<Param_Saisie_Param_screen> {
  Param_Saisie_Param wParam_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();
  String Title = "Verif+ : Paramètres ";

  static List<String> ListParam_ParamColor = [];
  static List<String> ListParam_ParamColorID = [];
  String selectedValueColor = "";
  String selectedValueColorID = "";

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    Reload();
  }


  Future Reload() async {
    await DbTools.getParam_Saisie_Param(widget.wType);
    await loadPhoto();
    await Filtre();
  }

  Future loadPhoto() async {
    String wUserImg = "Gamme_${wParam_Saisie_Param.Param_Saisie_ParamId}.jpg";
    pic =      await gColors.getImage(wUserImg);
    print("pic $wUserImg");// ${pic}");
    if (pic.length > 0) {
      wImage = Image.memory(
        pic,
        fit: BoxFit.scaleDown,
        width: 100,
        height: 100,
      );
    } else {
      wImage = Image(
        image: AssetImage('assets/images/Avatar_Org.jpg'),
        height: 100,
      );
    }

  }




  Future Filtre() async {
    DbTools.ListParam_Saisie_Paramsearchresult.clear();
    DbTools.ListParam_Saisie_Paramsearchresult.addAll(DbTools.ListParam_Saisie_Param);
    print("fin filtre");
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

    wImage =  Image(image: AssetImage('assets/images/Avatar_Org.jpg'), height: 100,);

    super.initState();
    initLib();
    Title = "Verif+ : Paramètres - ${widget.wType}";
  }

  @override
  Widget build(BuildContext context) {
    print("build ${widget.wType}");

    return Scaffold(
      backgroundColor: gColors.white,
      appBar: AppBar(
        backgroundColor: gColors.primary,
        automaticallyImplyLeading: false,
        title: Container(
            color: gColors.primary,
            child: Row(
              children: [
                Container(
                  width: 5,
                ),
                InkWell(
                  child: SizedBox(
                      height: 100.0,
                      width: 100.0, // fixed width and height
                      child: new Image.asset(
                        'assets/images/AppIcow.png',
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Text(
                  Title,
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_Wr,
                ),
                Spacer(),
                Container(
                  width: 150,
                  child: Text(
                    "Version : ${DbTools.gVersion}",
                    style: gColors.bodySaisie_N_W,
                  ),
                ),
              ],
            )),
      ),
      body: Container(
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
              child:
              Row(children: [
              Column(
                children: [
                  Row(children: [
                    InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: wParam_Saisie_Param.Param_Saisie_Param_Id.isNotEmpty ? Colors.black : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Saisie_Param.Param_Saisie_Param_Ordre > 1) {
                          for (int i = 0; i < DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
                            Param_Saisie_Param element = DbTools.ListParam_Saisie_Paramsearchresult[i];
                            print("^ AVANT ${element.Param_Saisie_Param_Ordre} ${element.Param_Saisie_Param_Id} ${element.Param_Saisie_Param_Label}");
                          }

                          for (int i = 0; i < DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
                            Param_Saisie_Param element = DbTools.ListParam_Saisie_Paramsearchresult[i];

                            if (element.Param_Saisie_Param_Ordre == wParam_Saisie_Param.Param_Saisie_Param_Ordre - 1) {
                              element.Param_Saisie_Param_Ordre = wParam_Saisie_Param.Param_Saisie_Param_Ordre;
                              await DbTools.setParam_Saisie_Param_Ordre(element);
                            } else if (element.Param_Saisie_Param_Ordre == wParam_Saisie_Param.Param_Saisie_Param_Ordre) {
                              element.Param_Saisie_Param_Ordre = wParam_Saisie_Param.Param_Saisie_Param_Ordre - 1;
                              await DbTools.setParam_Saisie_Param_Ordre(element);
                              wParam_Saisie_Param = element;
                            }
                          }

                          for (int i = 0; i < DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
                            Param_Saisie_Param element = DbTools.ListParam_Saisie_Paramsearchresult[i];
                            print("^ APRES ${element.Param_Saisie_Param_Ordre} ${element.Param_Saisie_Param_Id} ${element.Param_Saisie_Param_Label}");
                          }
                          //wParam_Saisie_Param.Param_Saisie_Param_Ordre = wParam_Saisie_Param.Param_Saisie_Param_Ordre - 1;
                          Reload();
                          setState(() {});
                        }
                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: wParam_Saisie_Param.Param_Saisie_Param_Id.isNotEmpty ? Colors.black : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Saisie_Param.Param_Saisie_Param_Ordre < DbTools.ListParam_Saisie_Paramsearchresult.length) {
                          Param_Saisie_Param tmpparamSaisieParam = Param_Saisie_Param.Param_Saisie_ParamInit();

                          for (int i = 0; i < DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
                            Param_Saisie_Param element = DbTools.ListParam_Saisie_Paramsearchresult[i];
                            print("v AVANT ${element.Param_Saisie_Param_Ordre} ${element.Param_Saisie_Param_Id} ${element.Param_Saisie_Param_Label}");
                          }

                          for (int i = DbTools.ListParam_Saisie_Paramsearchresult.length - 1; i >= 0; i--) {
                            Param_Saisie_Param element = DbTools.ListParam_Saisie_Paramsearchresult[i];

                            if (element.Param_Saisie_Param_Ordre == wParam_Saisie_Param.Param_Saisie_Param_Ordre) {
                              element.Param_Saisie_Param_Ordre = wParam_Saisie_Param.Param_Saisie_Param_Ordre + 1;
                              await DbTools.setParam_Saisie_Param_Ordre(element);
                              tmpparamSaisieParam = element;
                            } else if (element.Param_Saisie_Param_Ordre == wParam_Saisie_Param.Param_Saisie_Param_Ordre + 1) {
                              element.Param_Saisie_Param_Ordre = wParam_Saisie_Param.Param_Saisie_Param_Ordre;
                              await DbTools.setParam_Saisie_Param_Ordre(element);
                            }
                          }

                          for (int i = 0; i < DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
                            Param_Saisie_Param element = DbTools.ListParam_Saisie_Paramsearchresult[i];
                            print("v APRES ${element.Param_Saisie_Param_Ordre} ${element.Param_Saisie_Param_Id} ${element.Param_Saisie_Param_Label}");
                          }
                          //wParam_Saisie_Param.Param_Saisie_Param_Ordre = wParam_Saisie_Param.Param_Saisie_Param_Ordre - 1;
                          Reload();
                          setState(() {});
                          wParam_Saisie_Param = tmpparamSaisieParam;
                        }
                      },
                    ),
                    Container(
                      width: 8,
                    ),
                    Container(
                      width: 70,
                      child: _buildFieldID(context, wParam_Saisie_Param),
                    ),
                    Container(
                      width: 8,
                    ),
                    Container(
                      width: 320,
                      child: _buildFieldText(context, wParam_Saisie_Param),
                    ),
                    Container(
                      width: 8,
                    ),
                    Container(
                      width: 320,
                      child: _buildFieldAbrev(context, wParam_Saisie_Param),
                    ),
                    Container(
                      width: 8,
                    ),
                    Container(
                      width: 320,
                      child: _buildFieldAide(context, wParam_Saisie_Param),
                    ),
                    Container(
                      width: 8,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.check,
                        color: wParam_Saisie_Param.Param_Saisie_Param_Id.isNotEmpty ? Colors.blue : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Saisie_Param.Param_Saisie_Param_Id.isNotEmpty) {
                          wParam_Saisie_Param.Param_Saisie_Param_Label = Param_Saisie_Param_TextController.text;
                          wParam_Saisie_Param.Param_Saisie_Param_Abrev = Param_Saisie_Param_AbrevController.text;
                          wParam_Saisie_Param.Param_Saisie_Param_Aide = Param_Saisie_Param_AideController.text;
                          wParam_Saisie_Param.Param_Saisie_Param_Id = Param_Saisie_Param_IdController.text;
                          wParam_Saisie_Param.Param_Saisie_Param_Color = selectedValueColor;

                          await DbTools.setParam_Saisie_Param(wParam_Saisie_Param);

                          if (wParam_Saisie_Param.Param_Saisie_Param_Default) {
                            DbTools.ListParam_Saisie_Param.forEach((element) async {
                              if (wParam_Saisie_Param.Param_Saisie_ParamId != element.Param_Saisie_ParamId) {
                                element.Param_Saisie_Param_Default = false;
                                await DbTools.setParam_Saisie_Param(element);
                              }
                            });
                          }

                          if (wParam_Saisie_Param.Param_Saisie_Param_Init) {
                            DbTools.ListParam_Saisie_Param.forEach((element) async {
                              if (wParam_Saisie_Param.Param_Saisie_ParamId != element.Param_Saisie_ParamId) {
                                element.Param_Saisie_Param_Init = false;
                                await DbTools.setParam_Saisie_Param(element);
                              }
                            });
                          }

                          print("Check Reloads()");
                          await Reload();
                          print("Check setState()");
                          wParam_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();
                          setState(() {});
                        }
                      },
                    ),
                    Container(
                      width: 1,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.delete,
                        color: wParam_Saisie_Param.Param_Saisie_Param_Id.isNotEmpty ? Colors.red : Colors.black12,
                        size: 24.0,
                      ),
                      onTap: () async {
                        if (wParam_Saisie_Param.Param_Saisie_Param_Id.isNotEmpty) {
                          await DbTools.delParam_Saisie_Param(wParam_Saisie_Param);
                          await Reload();
                          wParam_Saisie_Param = Param_Saisie_Param.Param_Saisie_ParamInit();
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
                        Param_Saisie_Param paramSaisieParam = Param_Saisie_Param.Param_Saisie_ParamInit();
                        paramSaisieParam.Param_Saisie_Param_Id = widget.wType;
                        await DbTools.addParam_Saisie_Param(paramSaisieParam);
                        paramSaisieParam.Param_Saisie_ParamId = DbTools.gLastID;
                        await DbTools.setParam_Saisie_Param(paramSaisieParam);
                        await Reload();
                        wParam_Saisie_Param = paramSaisieParam;
                        print("_onRowTap ${paramSaisieParam.Param_Saisie_Param_Id}");
                      },
                    ),
                  ]),
                  Row(
                    children: [
                      Container(
                        width: 50,
                      ),
                      Text(
                        'Défaut : ',
                        style: gColors.bodySaisie_B_B,
                      ),
                      Checkbox(
                        checkColor: Colors.white,
                        value: wParam_Saisie_Param.Param_Saisie_Param_Default,
                        onChanged: (bool? value) {
                          setState(() {
                            wParam_Saisie_Param.Param_Saisie_Param_Default = value!;
                          });
                        },
                      ),
                      Text(
                        'Init : ',
                        style: gColors.bodySaisie_B_B,
                      ),
                      Checkbox(
                        checkColor: Colors.white,
                        value: wParam_Saisie_Param.Param_Saisie_Param_Init,
                        onChanged: (bool? value) {
                          setState(() {
                            wParam_Saisie_Param.Param_Saisie_Param_Init = value!;
                          });
                        },
                      ),
                      Container(
                        width: 10,
                      ),
                      DropdownButtonColor(),
                    ],
                  ),
                ],
              ),
                widget.wType.compareTo("GAM") == 0 ? Photo() : Container(),
              ],)

            ),
            Container(
              height: 10,
            ),
            Expanded(
              child: Param_Saisie_ParamGridWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;
  bool isLoad = false;
  late ImageProvider<Object> wImageO;


  Widget Photo() {
    String wImgPath = "${DbTools.SrvImg}Gamme_${wParam_Saisie_Param.Param_Saisie_Param_Id}.jpg";
    print("wImgPath $wImgPath");
    return Container(
        padding: EdgeInsets.fromLTRB(50, 10, 0, 10),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: Image.asset("assets/images/Photo.png"),
              onPressed: () async {
                await _startFilePicker(onSetState);

              },
            ),
            Container(width: 10),
            wImage,
            Container(width: 10),

          ],
        ));
  }

  _startFilePicker(VoidCallback onSetState) async {
    print("UploadFilePicker > Gamme_${wParam_Saisie_Param.Param_Saisie_ParamId}.jpg");
    await Upload.UploadFilePicker("Gamme_${wParam_Saisie_Param.Param_Saisie_ParamId}.jpg", onSetState);
    print("UploadFilePicker <");
    print("UploadFilePicker <<");
  }


  Widget _buildLigneFieldAbrev(BuildContext context, RowData<Param_Saisie_Param> data) {
    return TextFormField(
      initialValue: data.row.Param_Saisie_Param_Abrev,
      onChanged: (value) => _onFieldChangeAbrev(value, data.row),
      style: gColors.bodySaisie_B_B,
    );
  }

  void _onFieldChangeAbrev(String value, Param_Saisie_Param paramSaisieParam) async {
    print("_onFieldChangeAbrev");
    paramSaisieParam.Param_Saisie_Param_Abrev = value;
    await DbTools.setParam_Saisie_Param(paramSaisieParam);
    setState(() {});
  }

  Widget _buildLigneFieldLabel(BuildContext context, RowData<Param_Saisie_Param> data) {
    print("_buildLigneFieldLabel ${data.row.Param_Saisie_Param_Abrev}");
    return TextFormField(
      initialValue: data.row.Param_Saisie_Param_Label,
      onChanged: (value) => _onFieldChangeLabel(value, data.row),
      style: gColors.bodySaisie_B_B,
    );
  }

  void _onFieldChangeLabel(String value, Param_Saisie_Param paramSaisieParam) async {
    print("_onFieldChangeLabel");
    paramSaisieParam.Param_Saisie_Param_Label = value;
    await DbTools.setParam_Saisie_Param(paramSaisieParam);
    setState(() {});
  }

  Widget _buildLigneFieldAide(BuildContext context, RowData<Param_Saisie_Param> data) {
    return TextFormField(
      initialValue: data.row.Param_Saisie_Param_Aide,
      onChanged: (value) => _onFieldChangeAide(value, data.row),
      style: gColors.bodySaisie_B_B,
    );
  }

  void _onFieldChangeAide(String value, Param_Saisie_Param paramSaisieParam) async {
    print("_onFieldChangeAide");
    paramSaisieParam.Param_Saisie_Param_Aide = value;
    await DbTools.setParam_Saisie_Param(paramSaisieParam);
    setState(() {});
  }

  EasyTableModel<Param_Saisie_Param>? _model;

  Widget Param_Saisie_ParamGridWidget() {
    List<EasyTableColumn<Param_Saisie_Param>> wColumns = [
      EasyTableColumn(name: 'Id', stringValue: (row) => "${row.Param_Saisie_Param_Id} ${row.Param_Saisie_Param_Ordre}"),
      new EasyTableColumn(name: 'Libellé', grow: 12, stringValue: (row) => row.Param_Saisie_Param_Label),
      new EasyTableColumn(name: 'Abréviation', grow: 12, stringValue: (row) => row.Param_Saisie_Param_Abrev),
      new EasyTableColumn(name: 'Aide', grow: 12, stringValue: (row) => row.Param_Saisie_Param_Aide),
      new EasyTableColumn(name: 'Couleur', grow: 12, stringValue: (row) => row.Param_Saisie_Param_Color),
      EasyTableColumn(
          name: 'Défaut',
          cellBuilder: (BuildContext context, RowData<Param_Saisie_Param> data) {
            return Checkbox(
              checkColor: Colors.white,
              value: data.row.Param_Saisie_Param_Default,
              onChanged: (bool? value) {
                setState(() {});
              },
            );
          }),
      EasyTableColumn(
          name: 'Init',
          cellBuilder: (BuildContext context, RowData<Param_Saisie_Param> data) {
            return Checkbox(
              checkColor: Colors.white,
              value: data.row.Param_Saisie_Param_Init,
              onChanged: (bool? value) {
                setState(() {});
              },
            );
          }),
    ];

/*
    print("Param_Saisie_ParamGridWidget");
    for (int i = 0; i < DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
      Param_Saisie_Param wParam_Saisie_Param = DbTools.ListParam_Saisie_Paramsearchresult[i];
      print("Param_Saisie_Param_Label ${wParam_Saisie_Param.Param_Saisie_Param_Ordre} ${wParam_Saisie_Param.Param_Saisie_Param_Id} ${wParam_Saisie_Param.Param_Saisie_Param_Label}");
    }
*/

    _model = null;
    _model = EasyTableModel<Param_Saisie_Param>(rows: DbTools.ListParam_Saisie_Paramsearchresult, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<Param_Saisie_Param>(
          _model,
          visibleRowsCount: 18,
          onRowTap: (paramSaisieParam) => _onRowTap(context, paramSaisieParam),
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

  Future _onRowTap(BuildContext context, Param_Saisie_Param paramSaisieParam) async {
      wParam_Saisie_Param = paramSaisieParam;

      await loadPhoto();

      ListParam_ParamColorID.forEach((element) {
        if (element.compareTo(paramSaisieParam.Param_Saisie_Param_Color) == 0) {
          selectedValueColorID = element;
          selectedValueColor = ListParam_ParamColor[ListParam_ParamColorID.indexOf(element)];
        }
      });

      print("_onRowTap ${wParam_Saisie_Param.Param_Saisie_Param_Id}");
      setState(() {
    });
  }

  final Param_Saisie_Param_TextController = TextEditingController();
  Widget _buildFieldText(BuildContext context, Param_Saisie_Param paramSaisieParam) {
    Param_Saisie_Param_TextController.text = paramSaisieParam.Param_Saisie_Param_Label;
    return TextFormField(
      controller: Param_Saisie_Param_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_Param_AbrevController = TextEditingController();
  Widget _buildFieldAbrev(BuildContext context, Param_Saisie_Param paramSaisieParam) {
    Param_Saisie_Param_AbrevController.text = paramSaisieParam.Param_Saisie_Param_Abrev;
    return TextFormField(
      controller: Param_Saisie_Param_AbrevController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_Param_AideController = TextEditingController();
  Widget _buildFieldAide(BuildContext context, Param_Saisie_Param paramSaisieParam) {
/*
    print("_buildFieldAide > ${param_Saisie_Param.Param_Saisie_Param_Aide} ${wParam_Saisie_Param.Param_Saisie_Param_Aide}");
*/
    Param_Saisie_Param_AideController.text = paramSaisieParam.Param_Saisie_Param_Aide;
    return TextFormField(
      controller: Param_Saisie_Param_AideController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }

  final Param_Saisie_Param_IdController = TextEditingController();
  Widget _buildFieldID(BuildContext context, Param_Saisie_Param paramSaisieParam) {
    Param_Saisie_Param_IdController.text = paramSaisieParam.Param_Saisie_Param_Id;
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
      ),
      controller: Param_Saisie_Param_IdController,
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
      buttonHeight: 50,
      buttonWidth: 150,
      dropdownMaxHeight: 250,
      itemHeight: 32,
    ));
  }
}
