
import 'package:davi/davi.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Niveau_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/Tools/Srv_User_Desc.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Niv_Desc extends StatefulWidget {
  @override
  Niv_DescState createState() => Niv_DescState();
}

class Niv_DescState extends State<Niv_Desc> {
  bool isLoad = false;
  bool selPrev = false;
  bool selCor = false;
  bool selInstall = false;

  bool inprogress = false;

  int NivID = -1;

  final FocusNode _focusNode = FocusNode();
  String? _message;

  bool isShiftPressed = false;
  bool isCtrlPressed = false;

  static List<String> ListParam_ParamNiveau = [];
  static List<String> ListParam_ParamNiveauID = [];
  String selectedValueNiveau = "";
  String selectedValueNiveauID = "";

  Future Assign() async {
    await DbTools.getUserAll();
    for (int u = 0; u < DbTools.ListUser.length; u++) {
      User user = DbTools.ListUser[u];

      if (!user.User_Niv_Isole) {
        print(">>>>>>>>>> user ${user.UserID} ${user.User_Nom} ${user.User_Niv_Isole}");
        await DbTools.addUser_Desc(user.UserID);
        await DbTools.getUser_Desc(user.UserID);
        await DbTools.getNiveau_Desc(user.User_NivHabID);
        for (int uh = 0; uh < DbTools.ListUser_Desc.length; uh++) {
          User_Desc userDesc = DbTools.ListUser_Desc[uh];
          for (int uh = 0; uh < DbTools.ListNiveau_Desc.length; uh++) {
            Niveau_Desc niveauDesc = DbTools.ListNiveau_Desc[uh];
            if (userDesc.User_Desc_Param_DescID == niveauDesc.Niveau_Desc_Param_DescID) {
              userDesc.User_Desc_MaintPrev = niveauDesc.Niveau_Desc_MaintPrev;
              userDesc.User_Desc_MaintCorrect = niveauDesc.Niveau_Desc_MaintCorrect;
              userDesc.User_Desc_Install = niveauDesc.Niveau_Desc_Install;
              await DbTools.setUser_Desc(userDesc);
            }
          }
        }
      }
    }
  }

  Future Reload() async {
    print("selectedValueNiveauID $selectedValueNiveauID");
    if (selectedValueNiveauID.compareTo("") != 0) {
      NivID = int.parse(selectedValueNiveauID);
      await DbTools.addNiveau_Desc(NivID);
      await DbTools.getNiveau_Desc(NivID);

      DbTools.ListNiveau_Desc.forEach((element) {
        print("element ${element.Desc()}");
      });

      isLoad = true;
    }

    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();

    ListParam_ParamNiveau.clear();
    ListParam_ParamNiveauID.clear();
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("NivHab") == 0) {
        print("element ${element.Desc()}");
        ListParam_ParamNiveau.add(element.Param_Param_Text);
        ListParam_ParamNiveauID.add(element.Param_ParamId.toString());
      }
    });
    print("ListParam_ParamNiveau ${ListParam_ParamNiveau.length}");
    selectedValueNiveau = ListParam_ParamNiveau[0];
    selectedValueNiveauID = ListParam_ParamNiveauID[0];

    await Reload();
  }

  void initState() {
    super.initState();
    initLib();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    setState(() {
      isShiftPressed = event.isShiftPressed;
      isCtrlPressed = event.isControlPressed;
    });
    return event.logicalKey == LogicalKeyboardKey.keyQ ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return
      !isLoad
            ? Container()
            : Column(
                children: [
                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      DropdownButtonNiveau(),
                      Container(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: Text(
                          ">>> PROPAGER <<<",
                          style: gColors.bodyText_S_B,
                        ),
                        onPressed: () async {
                          inprogress = true;
                          setState(() {});
                          await Assign();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gColors.primary,
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      inprogress ? CircularProgressIndicator() : Container(),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Selection(),
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      child: Focus(
                        focusNode: _focusNode,
                        onKey: _handleKeyEvent,
                        child: Niveau_Desc_GridWidget(),
                      ),
                    ),

                ],
              );
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Niveau_Desc_GridWidget() {
    List<DaviColumn<Niveau_Desc>> wColumns = [
      new DaviColumn(name: 'Id', width: 50, stringValue: (row) => "${row.Niveau_DescID}"),
      new DaviColumn(name: 'Description', grow: 1, stringValue: (row) => "${row.Param_Saisie_Param_Label}"),
      new DaviColumn(
          name: '  Maint Prev',
          width: 100,
          resizable: false,
          sortable: false,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center,
          cellBuilder: (BuildContext context, DaviRow<Niveau_Desc> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.Niveau_Desc_MaintPrev,
              onChanged: (bool? value) async {
                row.data.Niveau_Desc_MaintPrev = (value == true);
                await DbTools.setNiveau_Desc(row.data);
                setState(() {});
              },
            );
          }),
      new DaviColumn(
          name: '   Maint Cor',
          resizable: false,
          sortable: false,
          width: 100,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center,
          cellBuilder: (BuildContext context, DaviRow<Niveau_Desc> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.Niveau_Desc_MaintCorrect,
              onChanged: (bool? value) async {
                row.data.Niveau_Desc_MaintCorrect = (value == true);
                await DbTools.setNiveau_Desc(row.data);
                setState(() {});
              },
            );
          }),
      new DaviColumn(
          name: '       Install',
          resizable: false,
          sortable: false,
          width: 100,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center,
          cellBuilder: (BuildContext context, DaviRow<Niveau_Desc> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.Niveau_Desc_Install,
              onChanged: (bool? value) async {
                row.data.Niveau_Desc_Install = (value == true);
                await DbTools.setNiveau_Desc(row.data);
                setState(() {});
              },
            );
          }),
    ];

    print("Param_GammeGridWidget");
    DaviModel<Niveau_Desc>? _model;

    _model = DaviModel<Niveau_Desc>(rows: DbTools.ListNiveau_Desc, columns: wColumns);

    return new DaviTheme(
        child: new Davi<Niveau_Desc>(
          _model,
          visibleRowsCount: 24,
          rowColor: _rowColor,

          onRowTap: (niveauDesc) => _onRowTap(context, niveauDesc),
        ),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }

//**********************************
//**********************************
//**********************************
  Color? _rowColor(DaviRow<Niveau_Desc> row) {
    if (row.data.Niveau_Desc_Sel) {
      return gColors.LinearGradient3;
    }

    return null;
  }

  void _onRowTap(BuildContext context, Niveau_Desc nivDesc) async {
    print(isShiftPressed);

    if (isCtrlPressed) {
      DbTools.ListNiveau_Desc.forEach((element) {
        element.Niveau_Desc_Sel = false;
        nivDesc.Niveau_Desc_Sel = !nivDesc.Niveau_Desc_Sel;
      });
    } else if (isShiftPressed) {
      int sel = DbTools.ListNiveau_Desc.indexOf(nivDesc);
      int first = -1;
      int i = 0;
      DbTools.ListNiveau_Desc.forEach((element) {
        if (element.Niveau_Desc_Sel) {
          first = i;
          return;
        }
        i++;
      });

      if (first < sel) {
        int i = 0;
        DbTools.ListNiveau_Desc.forEach((element) {
          if (i >= first && i <= sel) {
            element.Niveau_Desc_Sel = true;
          }
          i++;
        });
      } else if (first > sel) {
        int i = 0;
        DbTools.ListNiveau_Desc.forEach((element) {
          if (i >= sel && i <= first) {
            element.Niveau_Desc_Sel = true;
          }
          i++;
        });
      } else {
        nivDesc.Niveau_Desc_Sel = !nivDesc.Niveau_Desc_Sel;
      }
    } else {
      nivDesc.Niveau_Desc_Sel = !nivDesc.Niveau_Desc_Sel;
    }
    setState(() {});
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Selection() {
    bool isSel = false;
    DbTools.ListNiveau_Desc.forEach((element) {
      if (element.Niveau_Desc_Sel) {
        isSel = true;
        return;
      }
    });

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black26,
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10,
          ),
          ElevatedButton(
            child: Text(
              "Appliquer",
              style: gColors.bodyText_S_B,
            ),
            onPressed: () async {
              DbTools.ListNiveau_Desc.forEach((element) async {
                if (element.Niveau_Desc_Sel) {
                  element.Niveau_Desc_MaintPrev = selPrev;
                  element.Niveau_Desc_MaintCorrect = selCor;
                  element.Niveau_Desc_Install = selInstall;
                  await DbTools.setNiveau_Desc(element);
                }
              });
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSel ? null : Colors.grey,
            ),
          ),
          Container(
            width: 10,
          ),
          ElevatedButton(
            child: Text(
              "Sélectionner tout",
              style: gColors.bodyText_S_B,
            ),
            onPressed: () async {
              DbTools.ListNiveau_Desc.forEach((element) {
                element.Niveau_Desc_Sel = true;
              });

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSel ? null : Colors.grey,
            ),
          ),
          Container(
            width: 10,
          ),
          ElevatedButton(
            child: Text(
              "Raz Sélection",
              style: gColors.bodyText_S_B,
            ),
            onPressed: () async {
              DbTools.ListNiveau_Desc.forEach((element) {
                element.Niveau_Desc_Sel = false;
              });

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSel ? null : Colors.grey,
            ),
          ),
          Spacer(),
          Container(
            width: 100,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: selPrev,
              onChanged: (bool? value) async {
                selPrev = (value == true);
                setState(() {});
              },
            ),
          ),
          Container(
            width: 100,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: selCor,
              onChanged: (bool? value) async {
                selCor = (value == true);

                setState(() {});
              },
            ),
          ),
          Container(
            width: 100,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: selInstall,
              onChanged: (bool? value) async {
                selInstall = (value == true);

                setState(() {});
              },
            ),
          ),
          Container(
            width: 15,
          ),
        ],
      ),
    );
  }

  Widget DropdownButtonNiveau() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      hint: Text(
        'Séléctionner un Niveau',
        style: gColors.bodyTitle1_N_Gr,
      ),
      items: ListParam_ParamNiveau.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              "  $item",
              style: gColors.bodyTitle1_N_Gr,
            ),
          )).toList(),
      value: selectedValueNiveau,
      onChanged: (value) {
        setState(() {
          selectedValueNiveauID = ListParam_ParamNiveauID[ListParam_ParamNiveau.indexOf(value!)];
          selectedValueNiveau = value;
          print("selectedValueNiveau $selectedValueNiveauID $selectedValueNiveau");
          Reload();
        });
      },
          buttonStyleData: const ButtonStyleData(
            padding: const EdgeInsets.only(left: 14, right: 14),
            height: 30,
            width: 350,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
          ),


        ));
  }
}
