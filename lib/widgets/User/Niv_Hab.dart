
import 'package:davi/davi.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Niveau_Hab.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/Tools/Srv_User_Hab.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Niv_Hab extends StatefulWidget {
  @override
  Niv_HabState createState() => Niv_HabState();
}

class Niv_HabState extends State<Niv_Hab> {
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
        await DbTools.addUser_Hab(user.UserID);
        await DbTools.getUser_Hab(user.UserID);
        await DbTools.getNiveau_Hab(user.User_NivHabID);

        for (int uh = 0; uh < DbTools.ListUser_Hab.length; uh++) {
          User_Hab userHab = DbTools.ListUser_Hab[uh];

          for (int uh = 0; uh < DbTools.ListNiveau_Hab.length; uh++) {
            Niveau_Hab niveauHab = DbTools.ListNiveau_Hab[uh];
            if (userHab.User_Hab_Param_HabID == niveauHab.Niveau_Hab_Param_HabID) {
              userHab.User_Hab_MaintPrev = niveauHab.Niveau_Hab_MaintPrev;
              userHab.User_Hab_MaintCorrect = niveauHab.Niveau_Hab_MaintCorrect;
              userHab.User_Hab_Install = niveauHab.Niveau_Hab_Install;
              await DbTools.setUser_Hab(userHab);
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
      await DbTools.addNiveau_Hab(NivID);
      await DbTools.getNiveau_Hab(NivID);

      DbTools.ListNiveau_Hab.forEach((element) {
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
    return !isLoad
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
                  child: Niveau_Hab_GridWidget(),
                ),
              ),
            ],
          );
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Niveau_Hab_GridWidget() {
    List<DaviColumn<Niveau_Hab>> wColumns = [
      new DaviColumn(name: 'Id', width: 50, stringValue: (row) => "${row.Niveau_HabID}"),
      new DaviColumn(name: 'Groupe', grow: 1, stringValue: (row) => "${row.Param_Hab_Grp}"),
      new DaviColumn(name: 'Modèle', grow: 1, stringValue: (row) => "${row.Param_Hab_PDT}"),
      new DaviColumn(
          name: '  Maint Prev',
          width: 100,
          resizable: false,
          sortable: false,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center,
          cellBuilder: (BuildContext context, DaviRow<Niveau_Hab> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.Niveau_Hab_MaintPrev,
              onChanged: (bool? value) async {
                row.data.Niveau_Hab_MaintPrev = (value == true);
                await DbTools.setNiveau_Hab(row.data);
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
          cellBuilder: (BuildContext context, DaviRow<Niveau_Hab> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.Niveau_Hab_MaintCorrect,
              onChanged: (bool? value) async {
                row.data.Niveau_Hab_MaintCorrect = (value == true);
                await DbTools.setNiveau_Hab(row.data);
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
          cellBuilder: (BuildContext context, DaviRow<Niveau_Hab> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.Niveau_Hab_Install,
              onChanged: (bool? value) async {
                row.data.Niveau_Hab_Install = (value == true);
                await DbTools.setNiveau_Hab(row.data);
                setState(() {});
              },
            );
          }),
    ];

    print("Param_GammeGridWidget");
    DaviModel<Niveau_Hab>? _model;

    _model = DaviModel<Niveau_Hab>(rows: DbTools.ListNiveau_Hab, columns: wColumns);

    return new DaviTheme(
        child: new Davi<Niveau_Hab>(
          _model,
          visibleRowsCount: 24,
          rowColor: _rowColor,
          onRowTap: (niveauHab) => _onRowTap(context, niveauHab),
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
  Color? _rowColor(DaviRow<Niveau_Hab> row) {
    if (row.data.Niveau_Hab_Sel) {
      return gColors.LinearGradient3;
    }

    return null;
  }

  void _onRowTap(BuildContext context, Niveau_Hab userHab) async {
    print(isShiftPressed);

    if (isCtrlPressed) {
      DbTools.ListNiveau_Hab.forEach((element) {
        element.Niveau_Hab_Sel = false;
        userHab.Niveau_Hab_Sel = !userHab.Niveau_Hab_Sel;
      });
    } else if (isShiftPressed) {
      int sel = DbTools.ListNiveau_Hab.indexOf(userHab);
      int first = -1;
      int i = 0;
      DbTools.ListNiveau_Hab.forEach((element) {
        if (element.Niveau_Hab_Sel) {
          first = i;
          return;
        }
        i++;
      });

      if (first < sel) {
        int i = 0;
        DbTools.ListNiveau_Hab.forEach((element) {
          if (i >= first && i <= sel) {
            element.Niveau_Hab_Sel = true;
          }
          i++;
        });
      } else if (first > sel) {
        int i = 0;
        DbTools.ListNiveau_Hab.forEach((element) {
          if (i >= sel && i <= first) {
            element.Niveau_Hab_Sel = true;
          }
          i++;
        });
      } else {
        userHab.Niveau_Hab_Sel = !userHab.Niveau_Hab_Sel;
      }
    } else {
      userHab.Niveau_Hab_Sel = !userHab.Niveau_Hab_Sel;
    }
    setState(() {});
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Selection() {
    bool isSel = false;
    DbTools.ListNiveau_Hab.forEach((element) {
      if (element.Niveau_Hab_Sel) {
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
              DbTools.ListNiveau_Hab.forEach((element) async {
                if (element.Niveau_Hab_Sel) {
                  element.Niveau_Hab_MaintPrev = selPrev;
                  element.Niveau_Hab_MaintCorrect = selCor;
                  element.Niveau_Hab_Install = selInstall;
                  await DbTools.setNiveau_Hab(element);
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
              DbTools.ListNiveau_Hab.forEach((element) {
                element.Niveau_Hab_Sel = true;
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
              DbTools.ListNiveau_Hab.forEach((element) {
                element.Niveau_Hab_Sel = false;
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
}
