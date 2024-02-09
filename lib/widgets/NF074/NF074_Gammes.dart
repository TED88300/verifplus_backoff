import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';

class NF074_Gammes_screen extends StatefulWidget {
  @override
  _NF074_Gammes_screenState createState() => _NF074_Gammes_screenState();
}

class _NF074_Gammes_screenState extends State<NF074_Gammes_screen> with TickerProviderStateMixin {
  NF074_Gammes wNF074_Gammes = NF074_Gammes.NF074_GammesInit();


  int iboucle = 0;
  late AnimationController acontroller;
  bool iStrfExp = false;
  bool iStrfImp = false;

  bool isLoad = false;
//  List<DaviColumn<Param_Param>> wColumns = [];

  Future Reload() async {
    await DbTools.getNF074_GammesAll();
    await Filtre();
  }

  Future Filtre() async {
    DbTools.ListNF074_Gammessearchresult.clear();
    DbTools.ListNF074_Gammessearchresult.addAll(DbTools.ListNF074_Gammes);

    print("DbTools.ListNF074_Gammessearchresult ${DbTools.ListNF074_Gammessearchresult.length}");
    setState(() {});
  }

  void initLib() async {

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
                          "Export Gammes sur serveur",
                          style: gColors.bodySaisie_N_G,
                        )
                      ],
                    ),
                    onTap: () async {
                          String wTable = "Gammes";
                          await Upload.UploadSrvCsvPicker(wTable, onSetStateOn, onSetStateOff);

                          print("iStrfExp B ${iStrfExp}");
                        }
                  ),

                  Spacer(),

                  Text(
                    iStrfExp ? "Export ${iboucle} / ${DbTools.ListNF074_Gammes.length}" : "Gammes ${DbTools.ListNF074_Gammes.length}",
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
    List<DaviColumn<NF074_Gammes>> wColumns = [
      new DaviColumn(name: 'Id', stringValue: (row) => "${row.NF074_GammesId} "),
      new DaviColumn(name: 'Fabricant', grow: 12, stringValue: (row) => "${row.NF074_Gammes_FAB}"),
      new DaviColumn(name: 'Clé', grow: 12, stringValue: (row) => "${row.NF074_Gammes_DESC} / ${row.NF074_Gammes_PRS} / ${row.NF074_Gammes_CLF} / ${row.NF074_Gammes_MOB} / ${row.NF074_Gammes_PDT} / ${row.NF074_Gammes_POIDS} / ${row.NF074_Gammes_GAM}"),
      new DaviColumn(name: 'Certif', grow: 1, stringValue: (row) => "${row.NF074_Gammes_NCERT}"),
      new DaviColumn(name: 'CODF', grow: 1, stringValue: (row) => "${row.NF074_Gammes_CODF}"),
    ];

 //   print("NF074_GammesGridWidget");
    DaviModel<NF074_Gammes>? _model;

    _model = DaviModel<NF074_Gammes>(rows: DbTools.ListNF074_Gammessearchresult, columns: wColumns);

    return new DaviTheme(
        child: new Davi<NF074_Gammes>(
          _model,
          visibleRowsCount: 24,
          onRowTap: (paramHab) => _onRowTap(context, paramHab),
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

  void _onRowTap(BuildContext context, NF074_Gammes paramHab) {
    setState(() {
      wNF074_Gammes = paramHab;
      print("_onRowTap ${wNF074_Gammes.NF074_Gammes_PDT}");
    });
  }
}
