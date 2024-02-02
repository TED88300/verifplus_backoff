import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class NF074_Pieces_Det_screen extends StatefulWidget {
  @override
  _NF074_Pieces_Det_screenState createState() => _NF074_Pieces_Det_screenState();
}

class _NF074_Pieces_Det_screenState extends State<NF074_Pieces_Det_screen> with TickerProviderStateMixin {
  int iboucle = 0;
  late AnimationController acontroller;
  bool iStrfExp = false;
  bool iStrfImp = false;

  bool isLoad = false;
//  List<EasyTableColumn<Param_Param>> wColumns = [];

  Future Reload() async {
    await DbTools.getNF074_Pieces_DetAll();
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListNF074_Pieces_Detsearchresult.clear();
    DbTools.ListNF074_Pieces_Detsearchresult.addAll(DbTools.ListNF074_Pieces_Det);

    print("DbTools.ListNF074_Pieces_Detsearchresult ${DbTools.ListNF074_Pieces_Detsearchresult.length}");
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
                          "Export Pieces_Det sur serveur",
                          style: gColors.bodySaisie_N_G,
                        )
                      ],
                    ),
                    onTap: () async {


                          String wTable = "Pieces_Det";
                          await Upload.UploadSrvCsvPicker(wTable, onSetStateOn, onSetStateOff);

                          print("iStrfExp B ${iStrfExp}");
                        }
                  ),

                  Spacer(),

                  Text(
                    iStrfExp ? "Export ${iboucle} / ${DbTools.ListNF074_Pieces_Det.length}" : "Pieces_Det ${DbTools.ListNF074_Pieces_Det.length}",
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
    List<EasyTableColumn<NF074_Pieces_Det>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_DetId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PRS}"),

      new EasyTableColumn(name: 'CodeArticle', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_CodeArticle}"),
      new EasyTableColumn(name: 'CodeArticlePD1', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_CodeArticlePD1}"),
      new EasyTableColumn(name: 'DescriptionPD1', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_DescriptionPD1}"),
    ];

 //   print("NF074_Pieces_DetGridWidget");
    EasyTableModel<NF074_Pieces_Det>? _model;

    _model = EasyTableModel<NF074_Pieces_Det>(rows: DbTools.ListNF074_Pieces_Detsearchresult, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det>(
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

  void _onRowTap(BuildContext context, NF074_Pieces_Det paramHab) {
    setState(() {
    });
  }
}
