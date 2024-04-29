import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Intervenants_Dialog {
  Intervenants_Dialog();

  static Future<void> Intervenants_dialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Intervenants(),
    );
  }
}

class Intervenants extends StatefulWidget {
  @override
  State<Intervenants> createState() => _IntervenantsState();
}

class UserSelected {
  bool Sel = false;
  int UserID = 0;
  String Nom = "";
}

class _IntervenantsState extends State<Intervenants> {
  String wTitle = "";

  List<UserSelected> List_UserInter = [];

  void initLib() async {
    List_UserInter.clear();
    for (int i = 0; i < DbTools.ListUser.length; i++) {
      var element = DbTools.ListUser[i];
      UserSelected wUserSelected = UserSelected();
      wUserSelected.Sel = DbTools.gIntervention.Intervention_Intervenants!.contains("${element.UserID}");
      wUserSelected.Nom = "${element.User_Nom} ${element.User_Prenom}";
      wUserSelected.UserID = element.UserID;
      List_UserInter.add(wUserSelected);
    }
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 400;
    double height = 380; //MediaQuery.of(context).size.height - 200;
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
                "Intervention",
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
          width: width,
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
                "Intervenants",
                style: gColors.bodyTitle1_B_G.copyWith(decoration: TextDecoration.underline),
              ),
              Container(
                height: 20,
              ),
              Expanded(
                child: UserGridWidget(),
              ),
              Container(
                height: 20,
              ),
              new ElevatedButton(
                onPressed: () async {
                  String wTmp = "";
                  for (int i = 0; i < List_UserInter.length; i++) {
                    var element = List_UserInter[i];
                    if (element.Sel) wTmp = "$wTmp, ${element.UserID}";
                  }

                  DbTools.gIntervention.Intervention_Intervenants = wTmp;
                  await DbTools.setIntervention(DbTools.gIntervention);

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

  Widget UserGridWidget() {
    List<DaviColumn<UserSelected>> wColumns = [
      DaviColumn(
          pinStatus: PinStatus.left,
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<UserSelected> aInterUser) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: aInterUser.data.Sel,
              onChanged: (bool? value) async {
                aInterUser.data.Sel = (value == true);
//                setState(() {});
              },
            );
          }),
      new DaviColumn(name: 'Nom', width: 330, stringValue: (row) => "${row.Nom}"),
    ];

    DaviModel<UserSelected>? _model;
    _model = DaviModel<UserSelected>(rows: List_UserInter, columns: wColumns);
    return new DaviTheme(
        child: new Davi<UserSelected>(visibleRowsCount: 16, _model, onRowTap: (String) async {}),
        data: DaviThemeData(
          header: HeaderThemeData(color: gColors.secondary, bottomBorderHeight: 2, bottomBorderColor: gColors.LinearGradient3),
          headerCell: HeaderCellThemeData(height: 24, alignment: Alignment.center, textStyle: gColors.bodySaisie_B_B, resizeAreaWidth: 3, resizeAreaHoverColor: Colors.black, sortIconColors: SortIconColors.all(Colors.black), expandableName: false),
          cell: CellThemeData(
            contentHeight: 24,
            textStyle: gColors.bodySaisie_N_G,
          ),
        ));
  }
}
