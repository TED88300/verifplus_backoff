import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class NF074_Histo_Normes_screen extends StatefulWidget {
  @override
  _NF074_Histo_Normes_screenState createState() => _NF074_Histo_Normes_screenState();
}

class _NF074_Histo_Normes_screenState extends State<NF074_Histo_Normes_screen> with TickerProviderStateMixin {
  NF074_Histo_Normes wNF074_Histo_Normes = NF074_Histo_Normes.NF074_Histo_NormesInit();



  int iboucle = 0;
  late AnimationController acontroller;
  bool iStrfExp = false;
  bool iStrfImp = false;

  bool isLoad = false;
//  List<EasyTableColumn<Param_Param>> wColumns = [];

  Future Reload() async {
    await DbTools.getNF074_Histo_NormesAll();
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListNF074_Histo_Normessearchresult.clear();
    DbTools.ListNF074_Histo_Normessearchresult.addAll(DbTools.ListNF074_Histo_Normes);

    print("DbTools.ListNF074_Histo_Normessearchresult ${DbTools.ListNF074_Histo_Normessearchresult.length}");
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
                          "Export Histo_Normes sur serveur",
                          style: gColors.bodySaisie_N_G,
                        )
                      ],
                    ),
                    onTap: () async {


                          String wTable = "Histo_Normes";
                          await Upload.UploadSrvCsvPicker(wTable, onSetStateOn, onSetStateOff);

                          print("iStrfExp B ${iStrfExp}");
                        }
                  ),

                  Spacer(),

                  Text(
                    iStrfExp ? "Export ${iboucle} / ${DbTools.ListNF074_Histo_Normes.length}" : "Histo_Normes ${DbTools.ListNF074_Histo_Normes.length}",
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
    List<EasyTableColumn<NF074_Histo_Normes>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Histo_NormesId} "),
      new EasyTableColumn(name: 'Fabricant', grow: 5, stringValue: (row) => "${row.NF074_Histo_Normes_FAB}"),
      new EasyTableColumn(name: 'Certification', grow: 3, stringValue: (row) => "${row.NF074_Histo_Normes_NCERT} "),
      new EasyTableColumn(name: 'Entrée', grow: 1, stringValue: (row) => "${row.NF074_Histo_Normes_ENTRMM}/${row.NF074_Histo_Normes_ENTRAAAA}"),
      new EasyTableColumn(name: 'Sortie', grow: 1, stringValue: (row) => "${row.NF074_Histo_Normes_SORTMM}/${row.NF074_Histo_Normes_SORTAAAA}"),
      new EasyTableColumn(name: 'RTCH/RTYP/MVOL', grow: 12, stringValue: (row) => "${row.NF074_Histo_Normes_RTCH}/${row.NF074_Histo_Normes_RTYP}/${row.NF074_Histo_Normes_MVOL}"),
      new EasyTableColumn(name: 'ADDF/QTAD/MEL', grow: 12, stringValue: (row) => "${row.NF074_Histo_Normes_ADDF}/${row.NF074_Histo_Normes_QTAD}/${row.NF074_Histo_Normes_MEL}"),



    ];

 //   print("NF074_Histo_NormesGridWidget");
    EasyTableModel<NF074_Histo_Normes>? _model;

    _model = EasyTableModel<NF074_Histo_Normes>(rows: DbTools.ListNF074_Histo_Normessearchresult, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Histo_Normes>(
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

  void _onRowTap(BuildContext context, NF074_Histo_Normes paramHab) {
    setState(() {
      wNF074_Histo_Normes = paramHab;
      print("_onRowTap ${wNF074_Histo_Normes.NF074_Histo_Normes_NCERT}");
    });
  }
}
