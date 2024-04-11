import 'package:davi/davi.dart';
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
//  List<DaviColumn<Param_Param>> wColumns = [];

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
                  InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color:  Colors.red ,
                            size: 24.0,
                          ),
                          Container(
                            width: 8,
                          ),
                          Text(
                            "Purge ",
                            style: gColors.bodySaisie_N_G,
                          )
                        ],
                      ),
                      onTap: () async {

                        for (int i = 0; i < DbTools.ListNF074_Histo_Normes.length; i++) {
                          var element = DbTools.ListNF074_Histo_Normes[i];
                          if (element.NF074_Histo_Normes_NCERT.contains("  "))
                            {
                              String  R = element.NF074_Histo_Normes_NCERT.replaceAll("  ", " ");
                              print("element.NF074_Histo_Normes_NCERT.replaceAll("  ", " ") ${R}");

                              element.NF074_Histo_Normes_NCERT = R;
                              DbTools.setNF074_Histo_Normes(element);

                            }
                        }

                        Reload();


                      }
                  ),
                  Container(
                    width: 36,
                  ),

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
    List<DaviColumn<NF074_Histo_Normes>> wColumns = [
      new DaviColumn(name: 'Id', stringValue: (row) => "${row.NF074_Histo_NormesId} "),
      new DaviColumn(name: 'Fabricant', grow: 5, stringValue: (row) => "${row.NF074_Histo_Normes_FAB}"),
      new DaviColumn(name: 'Certification', grow: 3, stringValue: (row) => "${row.NF074_Histo_Normes_NCERT} "),
      new DaviColumn(name: 'Entrée', grow: 1, stringValue: (row) => "${row.NF074_Histo_Normes_ENTRMM}/${row.NF074_Histo_Normes_ENTRAAAA}"),
      new DaviColumn(name: 'Sortie', grow: 1, stringValue: (row) => "${row.NF074_Histo_Normes_SORTMM}/${row.NF074_Histo_Normes_SORTAAAA}"),
      new DaviColumn(name: 'RTCH/RTYP/MVOL', grow: 12, stringValue: (row) => "${row.NF074_Histo_Normes_RTCH}/${row.NF074_Histo_Normes_RTYP}/${row.NF074_Histo_Normes_MVOL}"),
      new DaviColumn(name: 'ADDF/QTAD/MEL', grow: 12, stringValue: (row) => "${row.NF074_Histo_Normes_ADDF}/${row.NF074_Histo_Normes_QTAD}/${row.NF074_Histo_Normes_MEL}"),



    ];

 //   print("NF074_Histo_NormesGridWidget");
    DaviModel<NF074_Histo_Normes>? _model;

    _model = DaviModel<NF074_Histo_Normes>(rows: DbTools.ListNF074_Histo_Normessearchresult, columns: wColumns);

    return new DaviTheme(
        child: new Davi<NF074_Histo_Normes>(
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

  void _onRowTap(BuildContext context, NF074_Histo_Normes paramHab) {
    setState(() {
      wNF074_Histo_Normes = paramHab;
      print("_onRowTap ${wNF074_Histo_Normes.NF074_Histo_Normes_NCERT}");
    });
  }
}
