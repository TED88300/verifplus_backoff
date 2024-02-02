import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class NF074_Ctrl_screen extends StatefulWidget {
  @override
  _NF074_Ctrl_screenState createState() => _NF074_Ctrl_screenState();
}

class _NF074_Ctrl_screenState extends State<NF074_Ctrl_screen> with TickerProviderStateMixin {

  bool iSGammesArticles = false;
  bool iSPiecesActionArticles1 = false;
  bool iSPiecesActionArticles2 = false;
  bool iSPiecesActionArticles3 = false;

  bool isMixteProduitArticles1 = false;
  bool isMixteProduitArticles2 = false;
  bool isMixteProduitArticles3 = false;

  bool isPieceDetArticles1 = false;
  bool isPieceDetArticles2 = false;
  bool isPieceDetArticles3 = false;

  bool isPieceDetIncArticles1 = false;
  bool isPieceDetIncArticles2 = false;
  bool isPieceDetIncArticles3 = false;


  Future Reload() async {
    await Filtre();
  }

  Future Filtre() async {
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
  void dispose() {
    super.dispose();
  }

  void ToolsBarCtrl_GammesArticles() async {
    await DbTools.getNF074_CtrlGammesArticles();
    iSGammesArticles = true;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    await Reload();
  }

  void ToolsBarCtrl_PiecesActionArticles1() async {
    await DbTools.getNF074_CtrlPiecesActionsArticles1();
    iSPiecesActionArticles1 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    await Reload();
  }

  void ToolsBarCtrl_PiecesActionArticles2() async {
    await DbTools.getNF074_CtrlPiecesActionsArticles2();
    iSPiecesActionArticles2 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;

    await Reload();
  }

  void ToolsBarCtrl_PiecesActionArticles3() async {
    await DbTools.getNF074_CtrlPiecesActionsArticles3();
    iSPiecesActionArticles3 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;

    await Reload();
  }

  void ToolsBarCtrl_MixteProduitArticles1() async {
    await DbTools.getNF074_CtrlMixteProduitArticles1();
    isMixteProduitArticles1 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;

    await Reload();
  }

  void ToolsBarCtrl_MixteProduitArticles2() async {
    await DbTools.getNF074_CtrlMixteProduitArticles2();
    isMixteProduitArticles2 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;

    await Reload();
  }

  void ToolsBarCtrl_MixteProduitArticles3() async {
    await DbTools.getNF074_CtrlMixteProduitArticles3();
    isMixteProduitArticles3 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    await Reload();
  }

  void ToolsBarCtrl_PieceDetArticles1() async {
    await DbTools.getNF074_CtrlPieceDetArticles1();
    isPieceDetArticles1 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    await Reload();
  }


  void ToolsBarCtrl_PieceDetArticles2() async {
    await DbTools.getNF074_CtrlPieceDetArticles2();
    isPieceDetArticles2 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles3 = false;
    await Reload();
  }

  void ToolsBarCtrl_PieceDetArticles3() async {
    await DbTools.getNF074_CtrlPieceDetArticles3();
    isPieceDetArticles3 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    await Reload();
  }

  void ToolsBarCtrl_PieceDetIncArticles1() async {
    await DbTools.getNF074_CtrlPieceDetIncArticles1();
    isPieceDetIncArticles1 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles2 = false;
    isPieceDetIncArticles3 = false;
    await Reload();
  }

  void ToolsBarCtrl_PieceDetIncArticles2() async {
    await DbTools.getNF074_CtrlPieceDetIncArticles2();
    isPieceDetIncArticles2 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles3 = false;
    await Reload();
  }
  void ToolsBarCtrl_PieceDetIncArticles3() async {
    await DbTools.getNF074_CtrlPieceDetIncArticles3();
    isPieceDetIncArticles3 = true;
    iSGammesArticles = false;
    iSPiecesActionArticles1 = false;
    iSPiecesActionArticles2 = false;
    iSPiecesActionArticles3 = false;
    isMixteProduitArticles1 = false;
    isMixteProduitArticles2 = false;
    isMixteProduitArticles3 = false;
    isPieceDetArticles1 = false;
    isPieceDetArticles2 = false;
    isPieceDetArticles3 = false;
    isPieceDetIncArticles1 = false;
    isPieceDetIncArticles2 = false;
    await Reload();
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
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, iSGammesArticles ? Colors.indigo : Colors.black12, !iSGammesArticles ?  Colors.black : Colors.white, "Gammes Articles EBP", ToolsBarCtrl_GammesArticles ,tooltip : "Gammes Articles non créer dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, iSPiecesActionArticles1 ? Colors.indigo : Colors.black12, !iSPiecesActionArticles1 ?  Colors.black : Colors.white, "Pièces Action 1 Articles EBP", ToolsBarCtrl_PiecesActionArticles1 ,tooltip : "Pièces Actions Articles 1 non créées dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, iSPiecesActionArticles2 ? Colors.indigo : Colors.black12, !iSPiecesActionArticles2 ?  Colors.black : Colors.white, "Pièces Action 2 Articles EBP", ToolsBarCtrl_PiecesActionArticles2 ,tooltip : "Pièces Actions Articles 2 non créées dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, iSPiecesActionArticles3 ? Colors.indigo : Colors.black12,!iSPiecesActionArticles3 ?  Colors.black :  Colors.white, "Pièces Action 3 Articles EBP", ToolsBarCtrl_PiecesActionArticles3 ,tooltip : "Pièces Actions Articles 3 non créées dans EBP" ),

                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isMixteProduitArticles1 ? Colors.indigo : Colors.black12,!isMixteProduitArticles1 ?  Colors.black :  Colors.white, "Mixte Produit 1 Artticles EBP", ToolsBarCtrl_MixteProduitArticles1 ,tooltip : "Mixte Produit  Articles 1 non créés dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isMixteProduitArticles2 ? Colors.indigo : Colors.black12, !isMixteProduitArticles2 ?  Colors.black : Colors.white, "Mixte Produit 2 Artticles EBP", ToolsBarCtrl_MixteProduitArticles2 ,tooltip : "Mixte Produit  Articles 2 non créés dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isMixteProduitArticles3 ? Colors.indigo : Colors.black12, !isMixteProduitArticles3 ?  Colors.black : Colors.white, "Mixte Produit 3 Artticles EBP", ToolsBarCtrl_MixteProduitArticles3 ,tooltip : "Mixte Produit  Articles 3 non créés dans EBP" ),

                ]),
                Container(
                  height: 10,
                ),

                Row(children: [

                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isPieceDetArticles1 ? Colors.indigo : Colors.black12, !isPieceDetArticles1 ?  Colors.black : Colors.white, "Pièce Det 1 Artticles EBP", ToolsBarCtrl_PieceDetArticles1 ,tooltip : "Pièce Det  Articles 1 non créés dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isPieceDetArticles2 ? Colors.indigo : Colors.black12, !isPieceDetArticles2 ?  Colors.black : Colors.white, "Pièce Det 2 Artticles EBP", ToolsBarCtrl_PieceDetArticles2 ,tooltip : "Pièce Det  Articles 2 non créés dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isPieceDetArticles3 ? Colors.indigo : Colors.black12, !isPieceDetArticles3 ?  Colors.black : Colors.white, "Pièce Det 3 Artticles EBP", ToolsBarCtrl_PieceDetArticles3 ,tooltip : "Pièce Det  Articles 3 non créés dans EBP" ),

                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isPieceDetIncArticles1 ? Colors.indigo : Colors.black12, !isPieceDetIncArticles1 ?  Colors.black : Colors.white, "Pièce Det Inc 1 Artticles EBP", ToolsBarCtrl_PieceDetIncArticles1 ,tooltip : "Pièce Det Inc  Articles 1 non créés dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isPieceDetIncArticles2 ? Colors.indigo : Colors.black12, !isPieceDetIncArticles2 ?  Colors.black : Colors.white, "Pièce Det Inc 2 Artticles EBP", ToolsBarCtrl_PieceDetIncArticles2 ,tooltip : "Pièce Det Inc  Articles 2 non créés dans EBP" ),
                  Container(width: 8,),
                  CommonAppBar.BtnRoundtext(context, isPieceDetIncArticles3 ? Colors.indigo : Colors.black12, !isPieceDetIncArticles3 ?  Colors.black : Colors.white, "Pièce Det Inc 3 Artticles EBP", ToolsBarCtrl_PieceDetIncArticles3 ,tooltip : "Pièce Det Inc  Articles 3 non créés dans EBP" ),


                ]),


              ],
            ),
          ),
          Container(
            height: 10,
          ),
          !iSGammesArticles ? Container() : GammesArticles_GridWidget(),
          !iSPiecesActionArticles1 ? Container() : Param_Saisie_ParamGridWidget1(),
          !iSPiecesActionArticles2 ? Container() : Param_Saisie_ParamGridWidget2(),
          !iSPiecesActionArticles3 ? Container() : Param_Saisie_ParamGridWidget3(),
          !isMixteProduitArticles1 ? Container() : Mixte_ProduitArticles_GridWidget1(),
          !isMixteProduitArticles2 ? Container() : Mixte_ProduitArticles_GridWidget2(),
          !isMixteProduitArticles3 ? Container() : Mixte_ProduitArticles_GridWidget3(),

          !isPieceDetArticles1 ? Container() : Piece_DetArticles_GridWidget1(),
          !isPieceDetArticles2 ? Container() : Piece_DetArticles_GridWidget2(),
          !isPieceDetArticles3 ? Container() : Piece_DetArticles_GridWidget3(),

          !isPieceDetIncArticles1 ? Container() : Piece_Det_IncArticles_GridWidget1(),
          !isPieceDetIncArticles2 ? Container() : Piece_Det_IncArticles_GridWidget2(),
          !isPieceDetIncArticles3 ? Container() : Piece_Det_IncArticles_GridWidget3(),

        ],
      ),
    );
  }



  Widget Piece_Det_IncArticles_GridWidget1() {
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

    _model = EasyTableModel<NF074_Pieces_Det_Inc>(rows: DbTools.ListNF074_Pieces_Det_Inc, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det_Inc>(
          _model,
          visibleRowsCount: 24,
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



  Widget Piece_Det_IncArticles_GridWidget2() {
    List<EasyTableColumn<NF074_Pieces_Det_Inc>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_Det_IncId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PRS}"),

      new EasyTableColumn(name: 'CodeArticlePD2', grow: 3, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_CodeArticlePD2}"),
      new EasyTableColumn(name: 'DescriptionPD2', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DescriptionPD2}"),
    ];

    //   print("NF074_Pieces_Det_IncGridWidget");
    EasyTableModel<NF074_Pieces_Det_Inc>? _model;

    _model = EasyTableModel<NF074_Pieces_Det_Inc>(rows: DbTools.ListNF074_Pieces_Det_Inc, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det_Inc>(
          _model,
          visibleRowsCount: 24,
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




  Widget Piece_Det_IncArticles_GridWidget3() {
    List<EasyTableColumn<NF074_Pieces_Det_Inc>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_Det_IncId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PRS}"),

      new EasyTableColumn(name: 'CodeArticlePD3', grow: 3, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_CodeArticlePD3}"),
      new EasyTableColumn(name: 'DescriptionPD3', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DescriptionPD3}"),
    ];

    //   print("NF074_Pieces_Det_IncGridWidget");
    EasyTableModel<NF074_Pieces_Det_Inc>? _model;

    _model = EasyTableModel<NF074_Pieces_Det_Inc>(rows: DbTools.ListNF074_Pieces_Det_Inc, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det_Inc>(
          _model,
          visibleRowsCount: 24,
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





  Widget Piece_DetArticles_GridWidget1() {
    List<EasyTableColumn<NF074_Pieces_Det>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_DetId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PRS}"),

      new EasyTableColumn(name: 'CodeArticlePD1', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_CodeArticlePD1}"),
      new EasyTableColumn(name: 'DescriptionPD1', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_DescriptionPD1}"),
    ];

    //   print("NF074_Pieces_DetGridWidget");
    EasyTableModel<NF074_Pieces_Det>? _model;

    _model = EasyTableModel<NF074_Pieces_Det>(rows: DbTools.ListNF074_Pieces_Det, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det>(
          _model,
          visibleRowsCount: 24,
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



  Widget Piece_DetArticles_GridWidget2() {
    List<EasyTableColumn<NF074_Pieces_Det>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_DetId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PRS}"),

      new EasyTableColumn(name: 'CodeArticlePD2', grow: 3, stringValue: (row) => "${row.NF074_Pieces_Det_CodeArticlePD2}"),
      new EasyTableColumn(name: 'DescriptionPD2', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_DescriptionPD2}"),
    ];

    //   print("NF074_Pieces_DetGridWidget");
    EasyTableModel<NF074_Pieces_Det>? _model;

    _model = EasyTableModel<NF074_Pieces_Det>(rows: DbTools.ListNF074_Pieces_Det, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det>(
          _model,
          visibleRowsCount: 24,
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




  Widget Piece_DetArticles_GridWidget3() {
    List<EasyTableColumn<NF074_Pieces_Det>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_DetId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_PRS}"),

      new EasyTableColumn(name: 'CodeArticlePD3', grow: 3, stringValue: (row) => "${row.NF074_Pieces_Det_CodeArticlePD3}"),
      new EasyTableColumn(name: 'DescriptionPD3', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Det_DescriptionPD3}"),
    ];

    //   print("NF074_Pieces_DetGridWidget");
    EasyTableModel<NF074_Pieces_Det>? _model;

    _model = EasyTableModel<NF074_Pieces_Det>(rows: DbTools.ListNF074_Pieces_Det, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Det>(
          _model,
          visibleRowsCount: 24,
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




  Widget Mixte_ProduitArticles_GridWidget1() {
    List<EasyTableColumn<NF074_Mixte_Produit>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Mixte_ProduitId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Mixte_Produit_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_POIDS}"),


      new EasyTableColumn(name: 'CodeArticlePD1', grow: 2, stringValue: (row) => "${row.NF074_Mixte_Produit_CodeArticlePD1}"),
      new EasyTableColumn(name: 'DescriptionPD1', grow: 8, stringValue: (row) => "${row.NF074_Mixte_Produit_DescriptionPD1}"),
    ];

    //   print("NF074_Mixte_ProduitGridWidget");
    EasyTableModel<NF074_Mixte_Produit>? _model;

    _model = EasyTableModel<NF074_Mixte_Produit>(rows: DbTools.ListNF074_Mixte_Produit, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Mixte_Produit>(
          _model,
          visibleRowsCount: 24,
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

  Widget Mixte_ProduitArticles_GridWidget2() {
    List<EasyTableColumn<NF074_Mixte_Produit>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Mixte_ProduitId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Mixte_Produit_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_POIDS}"),


      new EasyTableColumn(name: 'CodeArticlePD2', grow: 2, stringValue: (row) => "${row.NF074_Mixte_Produit_CodeArticlePD2}"),
      new EasyTableColumn(name: 'DescriptionPD2', grow: 8, stringValue: (row) => "${row.NF074_Mixte_Produit_DescriptionPD2}"),
    ];

    //   print("NF074_Mixte_ProduitGridWidget");
    EasyTableModel<NF074_Mixte_Produit>? _model;

    _model = EasyTableModel<NF074_Mixte_Produit>(rows: DbTools.ListNF074_Mixte_Produit, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Mixte_Produit>(
          _model,
          visibleRowsCount: 24,
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

  Widget Mixte_ProduitArticles_GridWidget3() {
    List<EasyTableColumn<NF074_Mixte_Produit>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Mixte_ProduitId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Mixte_Produit_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_POIDS}"),


      new EasyTableColumn(name: 'CodeArticlePD3', grow: 2, stringValue: (row) => "${row.NF074_Mixte_Produit_CodeArticlePD3}"),
      new EasyTableColumn(name: 'DescriptionPD3', grow: 8, stringValue: (row) => "${row.NF074_Mixte_Produit_DescriptionPD3}"),
    ];

    //   print("NF074_Mixte_ProduitGridWidget");
    EasyTableModel<NF074_Mixte_Produit>? _model;

    _model = EasyTableModel<NF074_Mixte_Produit>(rows: DbTools.ListNF074_Mixte_Produit, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Mixte_Produit>(
          _model,
          visibleRowsCount: 24,
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

  Widget Param_Saisie_ParamGridWidget1() {
    List<EasyTableColumn<NF074_Pieces_Actions>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_ActionsId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Actions_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_PRS}"),
      new EasyTableColumn(name: 'CodeArticlePD1', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Actions_CodeArticlePD1}"),
      new EasyTableColumn(name: 'DescriptionPD1', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Actions_DescriptionPD1}"),
    ];

    //   print("NF074_Pieces_ActionsGridWidget");
    EasyTableModel<NF074_Pieces_Actions>? _model;

    _model = EasyTableModel<NF074_Pieces_Actions>(rows: DbTools.ListNF074_Pieces_Actions, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Actions>(
          _model,
          visibleRowsCount: 24,
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

  Widget Param_Saisie_ParamGridWidget2() {
    List<EasyTableColumn<NF074_Pieces_Actions>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_ActionsId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Actions_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_PRS}"),
      new EasyTableColumn(name: 'CodeArticlePD2', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Actions_CodeArticlePD2}"),
      new EasyTableColumn(name: 'DescriptionPD2', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Actions_DescriptionPD2}"),
    ];

    //   print("NF074_Pieces_ActionsGridWidget");
    EasyTableModel<NF074_Pieces_Actions>? _model;

    _model = EasyTableModel<NF074_Pieces_Actions>(rows: DbTools.ListNF074_Pieces_Actions, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Actions>(
          _model,
          visibleRowsCount: 24,
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
  Widget Param_Saisie_ParamGridWidget3() {
    List<EasyTableColumn<NF074_Pieces_Actions>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_ActionsId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Actions_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Actions_PRS}"),
      new EasyTableColumn(name: 'CodeArticlePD3', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Actions_CodeArticlePD3}"),
      new EasyTableColumn(name: 'DescriptionPD3', grow: 8, stringValue: (row) => "${row.NF074_Pieces_Actions_DescriptionPD3}"),
    ];

    //   print("NF074_Pieces_ActionsGridWidget");
    EasyTableModel<NF074_Pieces_Actions>? _model;

    _model = EasyTableModel<NF074_Pieces_Actions>(rows: DbTools.ListNF074_Pieces_Actions, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Pieces_Actions>(
          _model,
          visibleRowsCount: 24,
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

  Widget GammesArticles_GridWidget() {
    List<EasyTableColumn<NF074_Gammes>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_GammesId} "),
      new EasyTableColumn(name: 'Ref', grow: 2, stringValue: (row) => "${row.NF074_Gammes_REF}"),
      new EasyTableColumn(name: 'Codf', grow: 2, stringValue: (row) => "${row.NF074_Gammes_CODF}"),
      new EasyTableColumn(name: 'Fabricant', grow: 6, stringValue: (row) => "${row.NF074_Gammes_FAB}"),
      new EasyTableColumn(name: 'Clé', grow: 12, stringValue: (row) => "${row.NF074_Gammes_DESC} / ${row.NF074_Gammes_PRS} / ${row.NF074_Gammes_CLF} / ${row.NF074_Gammes_MOB} / ${row.NF074_Gammes_PDT} / ${row.NF074_Gammes_POIDS} / ${row.NF074_Gammes_GAM}"),
      new EasyTableColumn(name: 'Certif', grow: 2, stringValue: (row) => "${row.NF074_Gammes_NCERT}"),
    ];

    //   print("NF074_GammesGridWidget");
    EasyTableModel<NF074_Gammes>? _model;

    _model = EasyTableModel<NF074_Gammes>(rows: DbTools.ListNF074_Gammes, columns: wColumns);

    return new EasyTableTheme(
        child: new EasyTable<NF074_Gammes>(
          _model,
          visibleRowsCount: 24,
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



}
