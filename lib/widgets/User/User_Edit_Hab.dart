
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/Tools/Srv_User_Hab.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

import 'package:flutter/services.dart';

class User_Edit_Hab extends StatefulWidget {
  final User user;
  final Image wImage;
  const User_Edit_Hab({Key? key, required this.user, required this.wImage}) : super(key: key);

  @override
  User_Edit_HabState createState() => User_Edit_HabState();
}

class User_Edit_HabState extends State<User_Edit_Hab> {
  bool isLoad = false;

  bool selPrev = false;
  bool selCor = false;
  bool selInstall = false;

  final FocusNode _focusNode = FocusNode();
  String? _message;

  bool isShiftPressed = false;
  bool isCtrlPressed = false;

  Future Reload() async {
    await DbTools.addUser_Hab(widget.user.UserID);
    await DbTools.getUser_Hab(widget.user.UserID);

    DbTools.ListUser_Hab.forEach((element) {
      print("element ${element.Desc()}");
    });

    isLoad = true;

    setState(() {});
  }

  void initLib() async {
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
    return Scaffold(
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
                    "Vérif+ : Edition Habilitations / Utilisateur ",
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
        body: !isLoad
            ? Container()
            : Column(
                children: [
                  Entete(),
                  Selection(),
                  Expanded(
                    child: Container(
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
                        child: User_Hab_GridWidget(),
                      ),
                    ),
                  ),
                ],
              ));
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Entete() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black26,
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10,
          ),
          ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(20), // Image radius
              child: widget.wImage,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 0, 0),
            child: Text(
              "Code Comm : ",
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: Text(
              "${widget.user.User_Matricule}",
              style: gColors.bodySaisie_B_B,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 6, 0, 0),
            child: Text(
              "Nom : ",
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: Text(
              "${widget.user.User_Nom} ${widget.user.User_Prenom}",
              style: gColors.bodySaisie_B_B,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(60, 6, 0, 0),
            child: Text(
              "Famille : ",
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: Text(
              "${widget.user.User_Famille}",
              style: gColors.bodySaisie_B_B,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 6, 0, 0),
            child: Text(
              "Fonction : ",
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: Text(
              "${widget.user.User_Fonction}",
              style: gColors.bodySaisie_B_B,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 6, 0, 0),
            child: Text(
              "Service : ",
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: Text(
              "${widget.user.User_Service}",
              style: gColors.bodySaisie_B_B,
            ),
          ),
        ],
      ),
    );
  }

  Widget User_Hab_GridWidget() {
    List<DaviColumn<User_Hab>> wColumns = [
      new DaviColumn(name: 'Id', width: 50, stringValue: (row) => "${row.User_HabID}"),
      new DaviColumn(name: 'Groupe', grow: 1, stringValue: (row) => "${row.Param_Hab_Grp}"),
      new DaviColumn(name: 'Modèle', grow: 1, stringValue: (row) => "${row.Param_Hab_PDT}"),
      new DaviColumn(
          name: '  Maint Prev',
          width: 100,
          resizable: false,
          sortable: false,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center,
          cellBuilder: (BuildContext context, DaviRow<User_Hab> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Hab_MaintPrev,
              onChanged: (bool? value) async {
                row.data.User_Hab_MaintPrev = (value == true);
                await DbTools.setUser_Hab(row.data);
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
          cellBuilder: (BuildContext context, DaviRow<User_Hab> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Hab_MaintCorrect,
              onChanged: (bool? value) async {
                row.data.User_Hab_MaintCorrect = (value == true);
                await DbTools.setUser_Hab(row.data);
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
          cellBuilder: (BuildContext context, DaviRow<User_Hab> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Hab_Install,
              onChanged: (bool? value) async {
                row.data.User_Hab_Install = (value == true);
                await DbTools.setUser_Hab(row.data);
                setState(() {});
              },
            );
          }),
    ];

    print("Param_GammeGridWidget");
    DaviModel<User_Hab>? _model;

    _model = DaviModel<User_Hab>(rows: DbTools.ListUser_Hab, columns: wColumns);

    return new DaviTheme(
        child: new Davi<User_Hab>(
          _model,
//          visibleRowsCount: 18,
          rowColor: _rowColor,

          onRowTap: (userHab) => _onRowTap(context, userHab),
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
  Color? _rowColor(DaviRow<User_Hab> row) {
    if (row.data.User_Hab_Sel) {
      return gColors.LinearGradient3;
    }

    return null;
  }

  void _onRowTap(BuildContext context, User_Hab userHab) async {
    print(isShiftPressed);

    if (isCtrlPressed) {
      DbTools.ListUser_Hab.forEach((element) {
        element.User_Hab_Sel = false;
        userHab.User_Hab_Sel = !userHab.User_Hab_Sel;
      });
    } else if (isShiftPressed) {
      int sel = DbTools.ListUser_Hab.indexOf(userHab);
      int first = -1;
      int i = 0;
      DbTools.ListUser_Hab.forEach((element) {
        if (element.User_Hab_Sel) {
          first = i;
          return;
        }
        i++;
      });

      if (first < sel) {
        int i = 0;
        DbTools.ListUser_Hab.forEach((element) {
          if (i >= first && i <= sel) {
            element.User_Hab_Sel = true;
          }
          i++;
        });
      } else if (first > sel) {
        int i = 0;
        DbTools.ListUser_Hab.forEach((element) {
          if (i >= sel && i <= first) {
            element.User_Hab_Sel = true;
          }
          i++;
        });
      } else {
        userHab.User_Hab_Sel = !userHab.User_Hab_Sel;
      }
    } else {
      userHab.User_Hab_Sel = !userHab.User_Hab_Sel;
    }
    setState(() {});
  }

  //********************************************
  //********************************************
  //********************************************

  Widget Selection() {
    bool isSel = false;
    DbTools.ListUser_Hab.forEach((element) {
      if (element.User_Hab_Sel) {
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
              DbTools.ListUser_Hab.forEach((element) async {
                if (element.User_Hab_Sel) {
                  element.User_Hab_MaintPrev = selPrev;
                  element.User_Hab_MaintCorrect = selCor;
                  element.User_Hab_Install = selInstall;
                  await DbTools.setUser_Hab(element);
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
              DbTools.ListUser_Hab.forEach((element) {
                element.User_Hab_Sel = true;
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

              DbTools.ListUser_Hab.forEach((element) {
                element.User_Hab_Sel = false;
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
}
