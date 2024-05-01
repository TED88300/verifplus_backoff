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

int Subindex = 0;
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
      List<DataGridCell> DataGridCells = [
        DataGridCell<int>(columnName: 'id', value: parc_Ent.ParcsId),
        DataGridCell<int>(columnName: 'ordre', value: parc_Ent.Parcs_order),
//      DataGridCell<String>(columnName:  'desc'  , value: parc_Ent.Parcs_Date_Desc),
      ];

      print("parc_Ent.Parcs_Cols ${parc_Ent.Parcs_Cols}");


      for (int i = 0; i < DbTools.lColParams.length; i++) {
        String ColParam = DbTools.lColParams[i];
        String ColParamsdata = parc_Ent.Parcs_Cols![i]!;


        if (ColParam == "DATE" && ColParamsdata.isNotEmpty)
          {
            DataGridCells.add(DataGridCell<DateTime>(columnName: 'date', value: DateTime.parse(ColParamsdata)));
          }
        else
          DataGridCells.add(DataGridCell<String>(columnName: ColParam, value: ColParamsdata));
      }


      return DataGridRow(cells: DataGridCells);
    }).toList();
  }

  @override
  Future<void> handleRefresh() async {
    buildDataGridRows();
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color selectedRowTextColor = Colors.white;
    Color textColor = dataGridController.selectedRows.contains(row) ? selectedRowTextColor : Colors.black;
    Color backgroundColor = Colors.transparent;

    List<Widget> DataGridCells = [
      FiltreTools.SfRowSel(row, 0, Alignment.centerLeft, textColor),
      FiltreTools.SfRow(row, 1, Alignment.centerLeft, textColor),
//      FiltreTools.SfRow(row, 2, Alignment.centerLeft, textColor),
    ];

    int n = 2;
    for (int i = 0; i < DbTools.lColParams.length; i++) {
      String ColParam = DbTools.lColParams[i];
      if (ColParam == "DATE")
        {
          DataGridCells.add(FiltreTools.SfRowDate(row,  n++, Alignment.centerLeft, textColor));
        }
      else
        {
          if (ColParam == "ACTION")
            {
              DataGridCells.add(FiltreTools.SfRow(row, n++, Alignment.center, textColor));
            }
          else
            DataGridCells.add(FiltreTools.SfRow(row, n++, Alignment.centerLeft, textColor));

        }
    }

    return DataGridRowAdapter(color: backgroundColor, cells: DataGridCells);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(color: gColors.secondary, alignment: Alignment.center, child: Text(summaryValue));
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
  String DescAffnewParam = "";

  List<double> dColumnWidth = [
    80,
    60,
  ];



  Parc_EntInfoDataGridSource parc_EntInfoDataGridSource = Parc_EntInfoDataGridSource();

  int wColSel = -1;
  int Selindex = -1;
  int countfilterConditions = -1;

  List<String?>? Parcs_ColsTitle = [];
  final Search_TextController = TextEditingController();

  List<String> subLibArray = [""];
  List<GrdBtn> lGrdBtn = [];
  List<GrdBtnGrp> lGrdBtnGrp = [];
  List<Param_Param> ListParam_ParamTypeOg = [];

  List<GridColumn> getColumns() {
    List<GridColumn> wGridColumn = [
      FiltreTools.SfGridColumn('id', 'ID', dColumnWidth[0], dColumnWidth[1], Alignment.centerLeft),
      FiltreTools.SfGridColumn('ordre', 'Ordre', dColumnWidth[1], dColumnWidth[1], Alignment.centerLeft),
//      FiltreTools.SfGridColumn('desc'      ,           'Organes'     , double.nan, dColumnWidth[2], Alignment.centerLeft, wColumnWidthMode :ColumnWidthMode.lastColumnFill),
    ];

    int n = 3;
    for (int i = 0; i < DbTools.lColParams.length; i++) {
      String ColParam = DbTools.lColParams[i];
      if (ColParam == "ACTION")
        wGridColumn.add(FiltreTools.SfGridColumn(ColParam, ColParam, dColumnWidth[i+2], dColumnWidth[1], Alignment.center));
      else
        wGridColumn.add(FiltreTools.SfGridColumn(ColParam, ColParam, dColumnWidth[i+2], dColumnWidth[1], Alignment.centerLeft));
    }

    return wGridColumn;
  }

  List<GridTableSummaryRow> getGridTableSummaryRow() {
    return [
      GridTableSummaryRow(
          color: gColors.secondary,
          showSummaryInRow: false,
          title: 'Cpt: {Count}',
          titleColumnSpan: 1,
          columns: [
            GridSummaryColumn(name: 'Count', columnName: 'id', summaryType: GridSummaryType.count),
          ],
          position: GridTableSummaryRowPosition.bottom),
    ];
  }

  void Resize(ColumnResizeUpdateDetails args) {
    setState(() {
      if (args.column.columnName == 'id')
        dColumnWidth[0] = args.width;
      else if (args.column.columnName == 'ordre') dColumnWidth[1] = args.width;

      else
        {
          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String ColParam = DbTools.lColParams[i];
            if (args.column.columnName == ColParam)
              {
                print("🁢🁢🁢🁢🁢🁢🁢  Resize ${args.width}");
                dColumnWidth[i+2] = args.width;
              }
          }


        }


    });
  }

  Future Reload() async {
    DbTools.gContact = Contact.ContactInit();
    Search_TextController.text = "";
    await DbTools.getContactSite(DbTools.gSite.SiteId);

    await DbTools.getParc_EntID(DbTools.gIntervention.InterventionId!);

    await DbTools.getParc_DescID(DbTools.gIntervention.InterventionId!);

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

    DbTools.OrgLib = subLibArray[Subindex];

    await DbTools.getParam_Saisie(DbTools.subTitleArray[Subindex], "Desc");

    print(">>>>>>>>>>> DescAffnewParam $DescAffnewParam");
    //DescAffnewParam PDT POIDS PRS MOB / ZNE EMP NIV / ANN / FAB
    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(DbTools.ListParam_Saisie_Base);

    print(" Nbre Ligne ${DbTools.ListParc_Ent.length}");

    for (int p = 0; p < DbTools.ListParc_Ent.length; p++) {
      Parc_Ent elementEnt = DbTools.ListParc_Ent[p];
      DbTools.lColParamsdata = List.filled(DbTools.lColParams.length, "");

      DescAff = DescAffnewParam;
      List<String?>? parcsCols = [];
      listparamSaisieTmp.forEach((element) async {
//        print(" element.Param_Saisie_ID ${element.Param_Saisie_ID} ${elementEnt.Action}");

        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_FREQ_Label!, element.Param_Saisie_ID)}");
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          print(">>>>>>>>> ANN ${elementEnt.Parcs_ANN_Id!} ---> ${elementEnt.Parcs_ANN_Label!}");

          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String lColParam = DbTools.lColParams[i];
            if (lColParam == element.Param_Saisie_ID) {
              DbTools.lColParamsdata[i] = elementEnt.Parcs_ANN_Label!;
            }
          }
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_ANN_Label!, element.Param_Saisie_ID)}");
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String lColParam = DbTools.lColParams[i];
            if (lColParam == element.Param_Saisie_ID) {
              DbTools.lColParamsdata[i] = elementEnt.Parcs_NIV_Label!;
            }
          }
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_NIV_Label!, element.Param_Saisie_ID)}");
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String lColParam = DbTools.lColParams[i];
            if (lColParam == element.Param_Saisie_ID) {
              DbTools.lColParamsdata[i] = elementEnt.Parcs_ZNE_Label!;
            }
          }
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_ZNE_Label!, element.Param_Saisie_ID)}");
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String lColParam = DbTools.lColParams[i];
            if (lColParam == element.Param_Saisie_ID) {
              DbTools.lColParamsdata[i] = elementEnt.Parcs_EMP_Label!;
            }
          }
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_EMP_Label!, element.Param_Saisie_ID)}");
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String lColParam = DbTools.lColParams[i];
            if (lColParam == element.Param_Saisie_ID) {
              DbTools.lColParamsdata[i] = elementEnt.Parcs_LOT_Label!;
            }
          }
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_LOT_Label!, element.Param_Saisie_ID)}");
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          for (int i = 0; i < DbTools.lColParams.length; i++) {
            String lColParam = DbTools.lColParams[i];
            if (lColParam == element.Param_Saisie_ID) {
              DbTools.lColParamsdata[i] = elementEnt.Parcs_SERIE_Label!;
            }
          }
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_SERIE_Label!, element.Param_Saisie_ID)}");
        } else {
          bool trv = false;


          int iColParam = 0;
          DbTools.ListParc_Desc.forEach((element2) {
//              print(" ZONE A TRAITER ELEMENT2 ${element2.ParcsDesc_Type} ${elementEnt.ParcsId}");
            if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}");
              for (int i = 0; i < DbTools.lColParams.length; i++) {
                String lColParam = DbTools.lColParams[i];
                if (lColParam == element.Param_Saisie_ID) {
                  DbTools.lColParamsdata[i] = element2.ParcsDesc_Lib!;
                }
              }
              trv = true;
            }
          });


          if (!trv) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "");
          }
        }
      });


      for (int i = 0; i < DbTools.lColParams.length; i++) {
        String lColParam = DbTools.lColParams[i];
        if (lColParam == "DATE") {
          DbTools.lColParamsdata[i] = elementEnt.Parcs_Date_Rev!;
        }
      }

      for (int i = 0; i < DbTools.lColParams.length; i++) {
        String lColParam = DbTools.lColParams[i];
        if (lColParam == "ACTION") {
          //print(" ACTION ${i} ${elementEnt.Action}");
          DbTools.lColParamsdata[i] = elementEnt.Action!;
        }
      }

      for (int i = 0; i < DbTools.lColParamsdata.length; i++) {
        String ColParam = DbTools.lColParams[i];
        String ColParamsdata = DbTools.lColParamsdata[i];

      }



      if (DescAff.compareTo(DescAffnewParam) == 0) DescAff = "";
      String wTmp = DescAff;
      wTmp = wTmp.replaceAll("---", "");
      wTmp = wTmp.replaceAll("/", "");
      wTmp = wTmp.replaceAll(" ", "");

      if (wTmp.length == 0) DescAff = "";
      elementEnt.Parcs_Date_Desc = DescAff;
      DbTools.ListParc_Ent[p].Parcs_Cols!.clear();
      DbTools.ListParc_Ent[p].Parcs_Cols!.addAll(DbTools.lColParamsdata);





      String parcsdescTypeDesc = "";
      String parcsdescTypePdt = "";
      Parc_Desc parcDescDesc = Parc_Desc(0, 0, "", "", "");
      Parc_Desc parcDescPdt = Parc_Desc(0, 0, "", "", "");

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
    }

    print("🁢🁢🁢🁢🁢🁢🁢  parc_EntInfoDataGridSource.dataGridRows.length ${parc_EntInfoDataGridSource.dataGridRows.length}");

    Filtre();
  }

  Future Filtre() async {
    DbTools.ListContactsearchresult.clear();
    DbTools.ListContactsearchresult.addAll(DbTools.ListContact);

    parc_EntInfoDataGridSource.handleRefresh();
    parc_EntInfoDataGridSource.sortedColumns.add(SortColumnDetails(name: 'ordre', sortDirection: DataGridSortDirection.ascending));
    parc_EntInfoDataGridSource.sort();
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  void initState() {

    for (int i = 0; i < DbTools.lColParamswidth.length; i++) {
      String ColParamswidth = DbTools.lColParamswidth[i];
      double iColParamswidth = double.tryParse(ColParamswidth) ?? 0;
      dColumnWidth.add(iColParamswidth);
    }


    lGrdBtnGrp.add(GrdBtnGrp(GrdBtnGrpId: 4, GrdBtnGrp_Color: Colors.black, GrdBtnGrp_ColorSel: Colors.black, GrdBtnGrp_Txt_Color: Colors.white, GrdBtnGrp_Txt_ColorSel: Colors.red, GrdBtnGrpSelId: [0], GrdBtnGrpType: 0));
    DbTools.subTitleArray.clear();
    ListParam_ParamTypeOg.clear();

    int i = 0;
    DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
//        print("element ${element.Param_Param_ID}  ${element.Param_Param_Text}");
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          lGrdBtn.add(GrdBtn(GrdBtnId: i++, GrdBtn_GroupeId: 4, GrdBtn_Label: element.Param_Param_ID));
          DbTools.subTitleArray.add(element.Param_Param_ID);
          subLibArray.add(element.Param_Param_Text);
          ListParam_ParamTypeOg.add(element);
        }
      }
    });
    DbTools.ParamTypeOg = subLibArray[0];

    Subindex = subLibArray.indexWhere((element) => element.compareTo(DbTools.ParamTypeOg) == 0);

    DbTools.getParam_ParamMemDet("Param_Div", "${DbTools.subTitleArray[Subindex]}_Desc");
    if (DbTools.ListParam_Param.length > 0) DescAffnewParam = DbTools.ListParam_Param[0].Param_Param_Text;

    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(children: [
        ToolsBar(context),
        SizedBox(
            height: MediaQuery.of(context).size.height - 422,
            child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: gColors.secondary,
                  selectionColor: gColors.backgroundColor,
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
                  tableSummaryRows: getGridTableSummaryRow(),

                  headerRowHeight: 35,
                  rowHeight: 28,
                  allowColumnsResizing: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  selectionMode: SelectionMode.single,
                  controller: dataGridController,
                  onColumnResizeUpdate: (ColumnResizeUpdateDetails args) {
                    Resize(args);
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
