import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Srv_User.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/User/User_Edit.dart';

class User_Liste extends StatefulWidget {
  @override
  User_ListeState createState() => User_ListeState();
}

class User_ListeState extends State<User_Liste> {
  Future Reload() async {
    await DbTools.getUserAll();

    DbTools.ListUser.forEach((element) {
      DbTools.ListParam_Param.forEach((param) {
        if (param.Param_Param_Type.compareTo("NivHab") == 0) {
          if (param.Param_ParamId == element.User_NivHabID) {
            element.User_NivHab = param.Param_Param_ID;
          }
        }
      });
    });

    DbTools.ListUser.forEach((element) {
      DbTools.ListParam_Param.forEach((param) {
        if (param.Param_Param_Type.compareTo("TypeUser") == 0) {
          if (param.Param_ParamId == element.User_TypeUserID) {
            element.User_TypeUser = param.Param_Param_ID;
          }
        }
      });
    });

    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();

    await Reload();
  }

  void initState() {
    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    return
      UserGridWidget();
  }

  //********************************************
  //********************************************
  //********************************************

  Widget UserGridWidget() {
    List<DaviColumn<User>> wColumns = [
      new DaviColumn(
          name: 'Id',
          width: 60,
          stringValue: (row) => "${row.UserID}"
              ""),
      new DaviColumn(
          name: 'Actif',
          width: 50,
          cellBuilder: (BuildContext context, DaviRow<User> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Actif,
              onChanged: (bool? value) {},
            );
          }),

      //cellBuilder: (context, row) =>  Checkbox(checkColor: Colors.red, value: row.data.User_Actif),),

      new DaviColumn(name: 'Matricule', width: 90, stringValue: (row) => "${row.User_Matricule}"),
      new DaviColumn(name: 'Type', width: 100, stringValue: (row) => row.User_TypeUser),
      new DaviColumn(name: 'Niveau', width: 90, stringValue: (row) => row.User_NivHab),

      new DaviColumn(
          name: 'Isolé',
          width: 50,
          cellBuilder: (BuildContext context, DaviRow<User> row) {
            return Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return gColors.primary;
              }),
              value: row.data.User_Niv_Isole,
              onChanged: (bool? value) {},
            );
          }),

      new DaviColumn(name: 'Agence', grow: 18, stringValue: (row) => "${row.User_Depot}"),
      new DaviColumn(name: 'Nom', grow: 18, stringValue: (row) => "${row.User_Nom}"),
      new DaviColumn(name: 'Prénom', grow: 18, stringValue: (row) => "${row.User_Prenom}"),
      new DaviColumn(name: 'Code postal', stringValue: (row) => "${row.User_Cp}"),
      new DaviColumn(name: 'Ville', grow: 18, stringValue: (row) => "${row.User_Ville}"),
      new DaviColumn(name: 'Tel', grow: 6, stringValue: (row) => "${row.User_Tel}"),
      new DaviColumn(name: 'Mail', grow: 8, stringValue: (row) => "${row.User_Mail}"),
    ];

    print("Param_GammeGridWidget");
    DaviModel<User>? _model;

    _model = DaviModel<User>(rows: DbTools.ListUser, columns: wColumns);

    return new DaviTheme(
        child: new Davi<User>(
          _model,
          visibleRowsCount: 32,
          onRowTap: (User) => _onRowTap(context, User),
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

  void _onRowTap(BuildContext context, User user) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => User_Edit(user: user)));
    Reload();
  }
}
