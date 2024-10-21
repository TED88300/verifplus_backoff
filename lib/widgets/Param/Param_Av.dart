import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Av.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Av_Dialog.dart';

class Param_Av_screen extends StatefulWidget {

  @override
  _Param_Av_screenState createState() => _Param_Av_screenState();
}

class _Param_Av_screenState extends State<Param_Av_screen> {
  Param_Av wParam_Av = Param_Av();
  String Title = "Paramètres Avertissement";

  static List<String> ListParam_GrpAv = [];
  static List<String> ListParam_GrpAvID = [];
  String selectedValueGrpAv = "";
  String selectedValueGrpAvID = "";


//  List<DaviColumn<Param_Param>> wColumns = [];

  Future Reload() async {
    await DbTools.getParam_AvAll();
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListParam_Avsearchresult.clear();
    DbTools.ListParam_Avsearchresult.addAll(DbTools.ListParam_Av);

    print("DbTools.ListParam_Avsearchresult ${DbTools.ListParam_Avsearchresult.length}");
    setState(() {});
  }


  void initLib() async {





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



                  Row(
                    children: [
                      Container(
                        width: 10,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.green,
                          size: 24.0,
                        ),
                        onTap: () async {
                          Param_Av paramAv = Param_Av();
                          await DbTools.addParam_Av(paramAv);


                          paramAv.Param_Av_No = "???";
                          paramAv.Param_Av_Det = "???";
                          paramAv.Param_Av_Proc = "???";
                          paramAv.Param_Av_Lnk = "???";



                          paramAv.Param_AvID = "${DbTools.gLastID}";
                          await DbTools.setParam_Av(paramAv);
                          await Reload();
                          DbTools.gParam_Av = paramAv;
                          await Param_Av_Dialog.Dialogs_Entete(context);
                          setState(() {});


                        },
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

  Widget Param_Saisie_ParamGridWidget() {
    List<DaviColumn<Param_Av>> wColumns = [
      new DaviColumn(name: 'Id', stringValue: (row) => "${row.Param_AvID} "),
      new DaviColumn(name: 'N°', grow: 2, stringValue: (row) => "${row.Param_Av_No}"),
      new DaviColumn(name: 'Détails', grow: 12, stringValue: (row) => "${row.Param_Av_Det}"),
      new DaviColumn(name: 'Procédures', grow: 12, stringValue: (row) => "${row.Param_Av_Proc}"),
      new DaviColumn(name: 'Liens', grow: 12, stringValue: (row) => "${row.Param_Av_Lnk}"),
    ];

    print("Param_AvGridWidget");
    DaviModel<Param_Av>? _model;

    _model = DaviModel<Param_Av>(rows: DbTools.ListParam_Avsearchresult, columns: wColumns);

    return new DaviTheme(
        child: new Davi<Param_Av>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (paramAv) => _onRowTap(context, paramAv),
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

  void _onRowTap(BuildContext context, Param_Av paramAv) async {
    DbTools.gParam_Av = paramAv;
    await Param_Av_Dialog.Dialogs_Entete(context);
    setState(() {});
  }

  final Param_Av_Det_TextController = TextEditingController();
  Widget _buildFieldPDTText(BuildContext context, Param_Av paramAv) {
    print(">>>>>>>>> Param_Av_Det_TextController ${paramAv.Param_Av_Det}");
    Param_Av_Det_TextController.text = paramAv.Param_Av_Det!;
    return TextFormField(
      controller: Param_Av_Det_TextController,
      decoration: InputDecoration(
        isDense: true,
      ),
      style: gColors.bodySaisie_B_B,
    );
  }


  Widget _buildDelete(BuildContext context, DaviRow<Param_Saisie_Param> rowData) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 18.0,
      ),
      onPressed: () async {
        DbTools.delParam_Saisie_Param(rowData.data);
        await Reload();
      },
    );
  }


}
