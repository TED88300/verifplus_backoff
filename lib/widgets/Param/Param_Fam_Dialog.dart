import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Param_Dialog.dart';

class Param_Fam_Dialog {
  Param_Fam_Dialog();

  static Future<void> Param_Dialog(
    BuildContext context,
    String wType,
    String wTitle,
    bool wSsFam,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Param_Fam_screen(
        wType: wType,
        wTitle: wTitle,
        wSsFam: wSsFam,
      ),
    );
  }
}

class Param_Fam_screen extends StatefulWidget {
  final String wType;
  final String wTitle;
  final bool wSsFam;

  const Param_Fam_screen({Key? key, required this.wType, required this.wSsFam, required this.wTitle}) : super(key: key);

  @override
  _Param_Fam_screenState createState() => _Param_Fam_screenState();
}

class _Param_Fam_screenState extends State<Param_Fam_screen> {
  Param_Param wParam_Param = Param_Param.Param_ParamInit();
  String Title = "Paramètres ";
  bool bReload = true;

  Future Reload() async {
    await DbTools.getParam_Param(widget.wType, bReload);
    bReload = false;
//    print("getParam_Param ${DbTools.ListParam_Param.length}");
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListParam_Paramsearchresult.clear();
    DbTools.ListParam_Paramsearchresult.addAll(DbTools.ListParam_Param);
    DbTools.ListParam_Paramsearchresult.forEach((element) {
      print("DbTools ${element.Param_Param_ID}");
    });
    setState(() {});
  }

  void initLib() async {
    Reload();
  }

  void initState() {
    super.initState();
    print("Param_Fam_screen initState ${widget.wType} - ${widget.wTitle}");
    initLib();

    Title = "Paramètres - ${widget.wTitle}";
  }

  @override
  Widget build(BuildContext context) {
    if (!bReload && DbTools.gDemndeReload) {
      Reload();
    }

    DbTools.gDemndeReload = false;

    print("Param_Fam_screen build ${widget.wType} -${widget.wTitle} bReload - $bReload");

    return Container(
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
                  width: 70,
                  child: _buildFieldID(context, wParam_Param),
                ),
                Container(
                  width: 8,
                ),
                Container(
                  width: 280,
                  child: _buildFieldText(context, wParam_Param),
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
                      wParam_Param.Param_Param_ID = Param_Param_IDController.text;
                      await DbTools.setParam_Param(wParam_Param);
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
                    wParam_Param = await DbTools.getParam_ParamID(DbTools.gLastID);
                    await Reload();
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
    );
  }

  @override
  Widget buildvp(BuildContext context) {
    print("build ${wParam_Param.Param_Param_ID}");

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
                gColors.BtnAffUser(context),
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
                    width: 70,
                    child: _buildFieldID(context, wParam_Param),
                  ),
                  Container(
                    width: 8,
                  ),
                  Container(
                    width: 280,
                    child: _buildFieldText(context, wParam_Param),
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
                        wParam_Param.Param_Param_ID = Param_Param_IDController.text;
                        await DbTools.setParam_Param(wParam_Param);
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
                      wParam_Param = await DbTools.getParam_ParamID(DbTools.gLastID);
                      await Reload();
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Expanded(
              child: Param_ParamGridWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget Param_ParamGridWidget() {
    List<DaviColumn<Param_Param>> wColumns = [
      new DaviColumn(
          grow: 2,
          name: 'Id',
          stringValue: (row) => "${row.Param_Param_ID} ${row.Param_Param_Ordre}"
              ""),
      DaviColumn(
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<Param_Param> data) {
            return InkWell(
              child: const Icon(Icons.list_alt, size: 16),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "${data.data.Param_Param_ID}", wTitle: "Sous Familles d'article : ${data.data.Param_Param_Text}", wDef: false,)));
              },
            );
          }),
      new DaviColumn(name: 'Libellé', grow: 18, stringValue: (row) => row.Param_Param_Text),
    ];

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
    });
  }

  final Param_Param_TextController = TextEditingController();

  Widget _buildFieldText(BuildContext context, Param_Param paramParam) {
//    print("_buildFieldText ${param_Param.Param_Param_Text} ${wParam_Param.Param_Param_Text}");
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

  /*Widget _buildDelete(BuildContext context, DaviRow<Param_Param> rowData) {
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
  }*/
}
