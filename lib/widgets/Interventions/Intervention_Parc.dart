import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Ent.dart';
import 'package:verifplus_backoff/widgetTools/Filtre.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

 DataGridController dataGridController = DataGridController();


//*********************************************************************
//*********************************************************************
//*********************************************************************

class Parc_EntInfoDataGridSource extends DataGridSource {

  Parc_EntInfoDataGridSource() {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = <DataGridRow>[];
  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = DbTools.ListParc_Ent.map<DataGridRow>((Parc_Ent parc_Ent) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName:     'id'      , value: parc_Ent.ParcsId),
        DataGridCell<String>(columnName:  'desc'  , value: parc_Ent.Parcs_Date_Desc),

      ]);
    }).toList();
  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    double t = 5;
    double b = 3;

    Color selectedRowTextColor = Colors.white;
    Color textColor = dataGridController.selectedRows.contains(row)  ? selectedRowTextColor : Colors.black;

    Color backgroundColor = Colors.transparent;
    return DataGridRowAdapter(color: backgroundColor, cells: <Widget>[
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft,textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
    ]);
  }
}

//*********************************************************************
//*********************************************************************
//*********************************************************************

class Intervention_Parc extends StatefulWidget {
  const Intervention_Parc({Key? key}) : super(key: key);

  @override
  State<Intervention_Parc> createState() => _Intervention_ParcState();
}

class _Intervention_ParcState extends State<Intervention_Parc> {

  List<double> dColumnWidth = [
    80,
    130,
  ];

  Parc_EntInfoDataGridSource parc_EntInfoDataGridSource = Parc_EntInfoDataGridSource();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  List<String?>? Parcs_ColsTitle = [];
  final Search_TextController = TextEditingController();

  List<String> subTitleArray = [
    "Ext",
    "Ria",
  ];
  List<String> subLibArray = ["zz"];
  List<GrdBtn> lGrdBtn = [];
  List<GrdBtnGrp> lGrdBtnGrp = [];
  List<Param_Param> ListParam_ParamTypeOg = [];


  List<GridColumn> getColumns() {
    return <GridColumn>[
      FiltreTools.SfGridColumn('id'        ,           'ID'      , dColumnWidth[0 ], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('desc'       ,           'Organes'     , double.nan, dColumnWidth[1], Alignment.centerLeft, wColumnWidthMode :ColumnWidthMode.lastColumnFill),
    ];

  }

  void Resize(ColumnResizeUpdateDetails args)
  {
    setState(() {
      if (args.column.columnName ==      'id'         ) dColumnWidth[0 ] = args.width;
      else if (args.column.columnName == 'desc'     ) dColumnWidth[1 ] = args.width;
    });
  }


  Future Reload() async {

    DbTools.gContact = Contact.ContactInit();
    Search_TextController.text = "";
    await DbTools.getContactSite(DbTools.gSite.SiteId);
    
    await DbTools.getParc_EntID(DbTools.gIntervention.InterventionId!);
    print("ListParc_Ent lenght DbTools.gIntervention.InterventionId ${DbTools.ListParc_Ent.length} ${DbTools.gIntervention.InterventionId}");

    await DbTools.getParc_DescID(DbTools.gIntervention.InterventionId!);
    print("ListParc_Desc lenght ${DbTools.ListParc_Desc.length}");

    await DbTools.getParam_Saisie_Base("Audit");
    DbTools.ListParam_Audit_Base.clear();
    DbTools.ListParam_Audit_Base.addAll(DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie_Base("Verif");
    DbTools.ListParam_Verif_Base.clear();
    DbTools.ListParam_Verif_Base.addAll(DbTools.ListParam_Saisie_Base);

    await DbTools.getParam_Saisie_Base("Desc");
    String DescAff = "";

    DbTools.ListParam_Saisie.sort(DbTools.affSort2Comparison);

    int countCol = 0;
    Parcs_ColsTitle!.clear();
    DbTools.ListParam_Saisie.forEach((element) async {
      if (element.Param_Saisie_Affichage.compareTo("COL") == 0) {
        countCol++;
        Parcs_ColsTitle!.add(element.Param_Saisie_Affichage_Titre);
      }
    });


    print ("subLibArray ${subLibArray.length}");

    int index = subLibArray.indexWhere((element) => element.compareTo(DbTools.ParamTypeOg) == 0);
    print ("index $index DbTools.ParamTypeOg ${DbTools.ParamTypeOg}");
    DbTools.OrgLib = subLibArray[index];

    await DbTools.getParam_Saisie(subTitleArray[index], "Desc");

    String DescAffnewParam = "";
    DbTools.getParam_ParamMemDet("Param_Div", "${subTitleArray[index]}_Desc");
    if (DbTools.ListParam_Param.length > 0) DescAffnewParam = DbTools.ListParam_Param[0].Param_Param_Text;

    print(">>>>>>>>>>> DescAffnewParam $DescAffnewParam");
    //DescAffnewParam PDT POIDS PRS MOB / ZNE EMP NIV / ANN / FAB
    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(DbTools.ListParam_Saisie_Base);

    
    print("DbTools.glfParcs_Ent.length ${DbTools.ListParc_Ent.length}");

    DbTools.ListParc_Ent.forEach((elementEnt) async {
      DescAff = DescAffnewParam;
      List<String?>? parcsCols = [];
      listparamSaisieTmp.forEach((element) async {
        if (element.Param_Saisie_Affichage.compareTo("DESC") == 0) {

          print(">>>>>>>>> element.Param_Saisie_ID ${element.Param_Saisie_ID}");

          if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_FREQ_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
            print(">>>>>>>>> ANN ${elementEnt.Parcs_ANN_Id!} ---> ${elementEnt.Parcs_ANN_Label!}");
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_ANN_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_NIV_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_ZNE_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_EMP_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_LOT_Label!, element.Param_Saisie_ID)}");
          } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_SERIE_Label!, element.Param_Saisie_ID)}");
          } else {
            bool trv = false;

            DbTools.ListParc_Desc.forEach((element2) {
//                          print("glfParcs_Desc.Param_Saisie_Affichage2 ${element2.ParcsDesc_ParcsId} ${element2.ParcsDesc_Type}");

              if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
//                  print("element.Param_Saisie_Affichage ${elementEnt.ParcsId} ${element.Param_Saisie_ID}");
//                  print("element.Param_Saisie_Affichage2 ${element2.ParcsDesc_ParcsId} ${element2.ParcsDesc_Type}");
                DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}");
                trv = true;
              }
            });
            if (!trv)
              {
                DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "");

              }
          }
        }

        if (element.Param_Saisie_Affichage.compareTo("COL") == 0) {
          DbTools.ListParc_Desc.forEach((element2) {
            if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              parcsCols.add(element2.ParcsDesc_Lib);
            }
          });
        }
      });

      if (DescAff.compareTo(DescAffnewParam) == 0) DescAff = "";
      String wTmp = DescAff;
      wTmp = wTmp.replaceAll("---", "");
      wTmp = wTmp.replaceAll("/", "");
      wTmp = wTmp.replaceAll(" ", "");

      if (wTmp.length == 0) DescAff = "";
      elementEnt.Parcs_Date_Desc = DescAff;
      elementEnt.Parcs_Cols = parcsCols;

      print("DescAff $DescAff");



      String parcsdescTypeDesc = "";
      String parcsdescTypePdt = "";
      Parc_Desc parcDescDesc = Parc_Desc(0,0,"","","");
      Parc_Desc parcDescPdt = Parc_Desc(0,0,"","","");

      DbTools.ListParc_Desc.forEach((element2) {
        if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId) {
          if (element2.ParcsDesc_Type!.compareTo("DESC") == 0) {
            parcsdescTypeDesc = element2.ParcsDesc_Lib!;
            parcDescDesc = element2;
          }

          if (element2.ParcsDesc_Type!.compareTo("PDT") == 0) {
            parcsdescTypePdt = element2.ParcsDesc_Lib!;
            parcDescPdt = element2;
          }
        }
      });

      bool parcsMaintprev = true;
      bool parcsMaintcorrect = true;
      bool parcsInstall = true;



      bool Maj = false;
      if (elementEnt.Parcs_MaintPrev != parcsMaintprev) {
        elementEnt.Parcs_MaintPrev = parcsMaintprev;
        Maj = true;
      }
      if (elementEnt.Parcs_MaintCorrect != parcsMaintcorrect) {
        elementEnt.Parcs_MaintCorrect = parcsMaintcorrect;
        Maj = true;
      }
      if (elementEnt.Parcs_Install != parcsInstall) {
        elementEnt.Parcs_Install = parcsInstall;
        Maj = true;
      }
    });

    parc_EntInfoDataGridSource.handleRefresh();
    setState(() {});

  }

  Future Filtre() async {
    DbTools.ListContactsearchresult.clear();
    DbTools.ListContactsearchresult.addAll(DbTools.ListContact);
    setState(() {});
  }


  @override
  void initLib() async {
    Reload();
  }

  void initState() {
    lGrdBtnGrp.add(GrdBtnGrp(GrdBtnGrpId: 4, GrdBtnGrp_Color: Colors.black, GrdBtnGrp_ColorSel: Colors.black, GrdBtnGrp_Txt_Color: Colors.white, GrdBtnGrp_Txt_ColorSel: Colors.red, GrdBtnGrpSelId: [0], GrdBtnGrpType: 0));
    subTitleArray.clear();
    ListParam_ParamTypeOg.clear();
    subTitleArray.clear();
    ListParam_ParamTypeOg.clear();

    int i = 0;
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
//        print("element ${element.Param_Param_ID}  ${element.Param_Param_Text}");
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          lGrdBtn.add(GrdBtn(GrdBtnId: i++, GrdBtn_GroupeId: 4, GrdBtn_Label: element.Param_Param_ID));
          subTitleArray.add(element.Param_Param_ID);
          subLibArray.add(element.Param_Param_Text);
          ListParam_ParamTypeOg.add(element);
        }
      }
    });

    DbTools.ParamTypeOg = subLibArray[0];

    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.black26,
          ),
        ),      child: Column(children: [
        ToolsBar(context),

        SizedBox(
            height: MediaQuery.of(context).size.height - 422,
            child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: gColors.secondary,
                  selectionColor : gColors.backgroundColor,
                ),
                child: SfDataGrid(
                  //*********************************
                  onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) async {
                    Selindex = parc_EntInfoDataGridSource.dataGridRows.indexOf(addedRows.last);

                    Reload();
                  },
                  onFilterChanged: (DataGridFilterChangeDetails details) {
                    countfilterConditions = parc_EntInfoDataGridSource.filterConditions.length;
                    print("onFilterChanged  countfilterConditions ${countfilterConditions}");
                    setState(() {});
                  },
                  onCellTap: (DataGridCellTapDetails details) {
                    wColSel = details.rowColumnIndex.columnIndex;
                  },

                  //*********************************

                  allowSorting: true,
                  allowFiltering: true,
                  source: parc_EntInfoDataGridSource,
                  columns: getColumns(),
                  headerRowHeight: 35,
                  rowHeight: 28,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  selectionMode: SelectionMode.single,
                  controller: dataGridController,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                    Resize( args);
                    return true;
                  },
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fill,
                ))),
        Container(
          height: 10,
        ),
      ]),
      );
  }


  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        child: Column(
          children: [
            Row(
              children: [

                CommonAppBar.SquareRoundIcon(context, 30, 8, countfilterConditions <= 0 ? Colors.black12 : gColors.secondarytxt, Colors.white, Icons.filter_list, ToolsBarSupprFilter, tooltip: "Supprimer les filtres"),
              ],
            ),
          ],
        ));
  }


  void ToolsBarSupprFilter() async {
    parc_EntInfoDataGridSource.clearFilters();
    countfilterConditions = 0;
    setState(() {});
  }


}
