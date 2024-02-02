import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class NF074_Pieces_Det_Inc_screen extends StatefulWidget {
  @override
  _NF074_Pieces_Det_Inc_screenState createState() => _NF074_Pieces_Det_Inc_screenState();
}

class _NF074_Pieces_Det_Inc_screenState extends State<NF074_Pieces_Det_Inc_screen> with TickerProviderStateMixin {
  int iboucle = 0;
  late AnimationController acontroller;
  bool iStrfExp = false;
  bool iStrfImp = false;

  bool isLoad = false;
//  List<EasyTableColumn<Param_Param>> wColumns = [];

  Future Reload() async {
    await DbTools.getNF074_Pieces_Det_IncAll();
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListNF074_Pieces_Det_Incsearchresult.clear();
    DbTools.ListNF074_Pieces_Det_Incsearchresult.addAll(DbTools.ListNF074_Pieces_Det_Inc);

    print("DbTools.ListNF074_Pieces_Det_Incsearchresult ${DbTools.ListNF074_Pieces_Det_Incsearchresult.length}");
    setState(() {});
  }

  void initLib() async {
    await DbTools.getParam_ParamAll();


    Reload();
  }

  void initState() {
    super.initState();
    initLib();
    acontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      //print("setSt 2");
      setState(() {});
    });
    acontroller.repeat(reverse: true);
    acontroller.stop();

  }

  @override
  void dispose() {
    acontroller.dispose();
    super.dispose();
  }


  void onSetState() async {
    print("Parent onMaj() Filtre()");
    Filtre();
  }

  void onSetStateOn() async {
    setState(() {
      acontroller.forward();
      acontroller.repeat(reverse: true);
      iStrfExp = true;

    });


  }

  void onSetStateOff() async {
    setState(() {
      acontroller.stop();
      iStrfExp = false;
    });

    Reload();
  }



  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Row(children: [
                  Container(
                    width: 8,
                  ),
                  iStrfExp
                      ? CircularProgressIndicator(
                    value: acontroller.value,
                    semanticsLabel: 'Circular progress indicator',
                  )
                      :InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_open,
                          color:  Colors.red ,
                          size: 24.0,
                        ),
                        Container(
                          width: 8,
                        ),
                        Text(
                          "Export Pieces_Det_Inc sur serveur",
                          style: gColors.bodySaisie_N_G,
                        )
                      ],
                    ),
                    onTap: () async {


                          String wTable = "Pieces_Det_Inc";
                          await Upload.UploadSrvCsvPicker(wTable, onSetStateOn, onSetStateOff);

                          print("iStrfExp B ${iStrfExp}");
                        }
                  ),

                  Spacer(),

                  Text(
                    iStrfExp ? "Export ${iboucle} / ${DbTools.ListNF074_Pieces_Det_Inc.length}" : "Pieces_Det_Inc ${DbTools.ListNF074_Pieces_Det_Inc.length}",
                    style: gColors.bodySaisie_N_G,
                  ),
                  Container(
                    width: 12,
                  ),


                ]),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          iStrfExp ? Container() : Param_Saisie_ParamGridWidget(),
        ],
      ),
    );
  }

  Widget Param_Saisie_ParamGridWidget() {
    List<EasyTableColumn<NF074_Pieces_Det_Inc>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_Det_IncId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PRS}"),

      new EasyTableColumn(name: 'CodeArticlePD1', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_CodeArticlePD1}"),
      new EasyTableColumn(name: 'DescriptionPD1', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DescriptionPD1}"),
    ];

 //   print("NF074_Pieces_Det_IncGridWidget");
    EasyTableModel<NF074_Pieces_Det_Inc>? _model;

    _model = EasyTableModel<NF074_Pieces_Det_Inc>(rows: DbTools.ListNF074_Pieces_Det_Incsearchresult, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det_Inc>(
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

  void _onRowTap(BuildContext context, NF074_Pieces_Det_Inc paramHab) {
    setState(() {
    });
  }
}
