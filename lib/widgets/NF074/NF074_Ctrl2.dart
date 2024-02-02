import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_NF074.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';

import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class NF074_Ctrl2_screen extends StatefulWidget {
  @override
  _NF074_Ctrl2_screenState createState() => _NF074_Ctrl2_screenState();
}

class _NF074_Ctrl2_screenState extends State<NF074_Ctrl2_screen> with TickerProviderStateMixin {
  bool isGammesPiecesDet = false;
  bool isGammesPieces_Actions_PDT = false;
  bool isGammesPieces_Actions_POIDS = false;
  bool isGammesPieces_Actions_PRS = false;
  bool isGammesPieces_Actions_DESC = false;

  bool isGammesMixte_Produit_PDT = false;
  bool isGammesMixte_Produit_POIDS = false;
  bool isGammesMixte_Produit_CLF = false;
  bool isGammesMixte_Produit_DESC = false;

  bool isGammesPieces_Det_Inc_PDT = false;
  bool isGammesPieces_Det_Inc_POIDS = false;
  bool isGammesPieces_Det_Inc_PRS = false;
  bool isGammesPieces_Det_Inc_CLF = false;
  bool isGammesPieces_Det_Inc_DESC = false;

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
    await DbTools.getNF074_CtrlGammesPiecesDet();
    isGammesPiecesDet = true;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_PRS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Actions_PDT() async {
    await DbTools.getNF074_CtrlGammesPieces_Actions_PDT();
    isGammesPieces_Actions_PDT = true;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_PRS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Actions_POIDS() async {
    await DbTools.getNF074_CtrlGammesPieces_Actions_POIDS();
    isGammesPieces_Actions_POIDS = true;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_PRS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Actions_PRS() async {
    await DbTools.getNF074_CtrlGammesPieces_Actions_PRS();
    isGammesPieces_Actions_PRS = true;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Actions_DESC() async {
    await DbTools.getNF074_Pieces_ActionsAll();

    DbTools.ListNF074_Pieces_Actionssearchresult.clear();
    for (int i = 0; i < DbTools.ListNF074_Pieces_Actions.length; i++) {
      NF074_Pieces_Actions wNF074_Pieces_Actions = DbTools.ListNF074_Pieces_Actions[i];
      if (wNF074_Pieces_Actions.NF074_Pieces_Actions_DESC.isNotEmpty) {
        List<String> listNF074_Pieces_Actions_DESC = wNF074_Pieces_Actions.NF074_Pieces_Actions_DESC.split(",");

        for (int j = 0; j < listNF074_Pieces_Actions_DESC.length; j++) {
          String Pieces_Actions_DESC = listNF074_Pieces_Actions_DESC[j].trim();

          bool wTrv = await DbTools.getNF074_GammesDesc(Pieces_Actions_DESC);
          if (!wTrv) {
            print("Pieces_Actions_DESC ADD ${Pieces_Actions_DESC}");
            DbTools.ListNF074_Pieces_Actionssearchresult.add(wNF074_Pieces_Actions);
          }
        }
      }
    }

    isGammesPieces_Actions_DESC = true;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_PRS = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesMixte_Produit_PDT() async {
    await DbTools.getNF074_CtrlGammesMixte_Produit_PDT();
    isGammesMixte_Produit_PDT = false;
    isGammesPiecesDet = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesMixte_Produit_PDT = true;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesMixte_Produit_POIDS() async {
    await DbTools.getNF074_CtrlGammesMixte_Produit_POIDS();
    isGammesMixte_Produit_POIDS = false;
    isGammesPiecesDet = false;
    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = true;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesMixte_Produit_CLF() async {
    await DbTools.getNF074_CtrlGammesMixte_Produit_CLF();
    isGammesMixte_Produit_CLF = false;
    isGammesPiecesDet = false;
    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = true;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesMixte_Produit_DESC() async {
    await DbTools.getNF074_Mixte_ProduitAll();

    DbTools.ListNF074_Mixte_Produitsearchresult.clear();
    for (int i = 0; i < DbTools.ListNF074_Mixte_Produit.length; i++) {
      NF074_Mixte_Produit wNF074_Mixte_Produit = DbTools.ListNF074_Mixte_Produit[i];
      if (wNF074_Mixte_Produit.NF074_Mixte_Produit_DESC.isNotEmpty) {
//        print("DESC ${wNF074_Mixte_Produit.NF074_Mixte_Produit_DESC}");
        List<String> listNF074_Mixte_Produit_DESC = wNF074_Mixte_Produit.NF074_Mixte_Produit_DESC.split(",");

        for (int j = 0; j < listNF074_Mixte_Produit_DESC.length; j++) {
          String Mixte_Produit_DESC = listNF074_Mixte_Produit_DESC[j].trim();
          //        print("Mixte_Produit_DESC ${Mixte_Produit_DESC}");

          if (Mixte_Produit_DESC.isNotEmpty) {
            bool wTrv = await DbTools.getNF074_GammesDesc(Mixte_Produit_DESC);
            if (!wTrv) {
              DbTools.ListNF074_Mixte_Produitsearchresult.add(wNF074_Mixte_Produit);
            }
          }
        }
      }
    }

    isGammesMixte_Produit_DESC = false;
    isGammesPiecesDet = false;
    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = true;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Det_Inc_PDT() async {
    await DbTools.getNF074_CtrlGammesPieces_Det_Inc_PDT();
    isGammesPieces_Actions_PDT = false;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_PRS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = true;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Det_Inc_POIDS() async {
    await DbTools.getNF074_CtrlGammesPieces_Det_Inc_POIDS();
    isGammesPieces_Actions_POIDS = false;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_PRS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = true;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Det_Inc_PRS() async {
    await DbTools.getNF074_CtrlGammesPieces_Det_Inc_PRS();
    isGammesPieces_Actions_PRS = false;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = true;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Det_Inc_CLF() async {
    await DbTools.getNF074_Pieces_Det_IncAll();

    DbTools.ListNF074_Pieces_Det_Incsearchresult.clear();
    for (int i = 0; i < DbTools.ListNF074_Pieces_Det_Inc.length; i++) {
      NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = DbTools.ListNF074_Pieces_Det_Inc[i];
      if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CLF.isNotEmpty) {
//        print("CLF ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CLF}");
        List<String> listNF074_Pieces_Det_Inc_CLF = wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_CLF.split(",");

        for (int j = 0; j < listNF074_Pieces_Det_Inc_CLF.length; j++) {
          String Pieces_Det_Inc_CLF = listNF074_Pieces_Det_Inc_CLF[j].trim();

          if (Pieces_Det_Inc_CLF.isNotEmpty) {
//            print("Pieces_Det_Inc_CLF ${Pieces_Det_Inc_CLF}");
            bool wTrv = await DbTools.getNF074_GammesCLF(Pieces_Det_Inc_CLF);
            if (!wTrv) {
              print("Pieces_Det_Inc_CLF ADD ${Pieces_Det_Inc_CLF}");
              DbTools.ListNF074_Pieces_Det_Incsearchresult.add(wNF074_Pieces_Det_Inc);
            }
          }
        }
      }
    }
    isGammesPieces_Actions_PRS = false;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_DESC = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = true;
    isGammesPieces_Det_Inc_DESC = false;

    await Reload();
  }

  void ToolsBarCtrl_GammesPieces_Det_Inc_DESC() async {
    await DbTools.getNF074_Pieces_Det_IncAll();

    DbTools.ListNF074_Pieces_Det_Incsearchresult.clear();
    for (int i = 0; i < DbTools.ListNF074_Pieces_Det_Inc.length; i++) {
      NF074_Pieces_Det_Inc wNF074_Pieces_Det_Inc = DbTools.ListNF074_Pieces_Det_Inc[i];
      if (wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DESC.isNotEmpty) {
        print("DESC ${wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DESC}");
        List<String> listNF074_Pieces_Det_Inc_DESC = wNF074_Pieces_Det_Inc.NF074_Pieces_Det_Inc_DESC.split(",");

        for (int j = 0; j < listNF074_Pieces_Det_Inc_DESC.length; j++) {
          String Pieces_Det_Inc_DESC = listNF074_Pieces_Det_Inc_DESC[j].trim();
          print("Pieces_Det_Inc_DESC ${Pieces_Det_Inc_DESC}");

          bool wTrv = await DbTools.getNF074_GammesDesc(Pieces_Det_Inc_DESC);
          if (!wTrv) {
            DbTools.ListNF074_Pieces_Det_Incsearchresult.add(wNF074_Pieces_Det_Inc);
          }
        }
      }
    }

    isGammesPieces_Actions_DESC = false;
    isGammesPiecesDet = false;
    isGammesPieces_Actions_PDT = false;
    isGammesPieces_Actions_POIDS = false;
    isGammesPieces_Actions_PRS = false;

    isGammesMixte_Produit_PDT = false;
    isGammesMixte_Produit_POIDS = false;
    isGammesMixte_Produit_CLF = false;
    isGammesMixte_Produit_DESC = false;

    isGammesPieces_Det_Inc_PDT = false;
    isGammesPieces_Det_Inc_POIDS = false;
    isGammesPieces_Det_Inc_PRS = false;
    isGammesPieces_Det_Inc_CLF = false;
    isGammesPieces_Det_Inc_DESC = true;

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
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPiecesDet ? Colors.indigo : Colors.black12, !isGammesPiecesDet ? Colors.black : Colors.white, "Pieces Det Gammes / CODF", ToolsBarCtrl_GammesArticles, tooltip: "Pieces Det non créées dans Gammes via CODF"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Actions_PDT ? Colors.indigo : Colors.black12, !isGammesPieces_Actions_PDT ? Colors.black : Colors.white, "Pieces Action Gammes / Pdt", ToolsBarCtrl_GammesPieces_Actions_PDT, tooltip: "Pieces Action non créées dans Gammes / PDT"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Actions_POIDS ? Colors.indigo : Colors.black12, !isGammesPieces_Actions_POIDS ? Colors.black : Colors.white, "Pieces Action Gammes / Poids", ToolsBarCtrl_GammesPieces_Actions_POIDS, tooltip: "Pieces Action non créées dans Gammes / Poids"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Actions_PRS ? Colors.indigo : Colors.black12, !isGammesPieces_Actions_PRS ? Colors.black : Colors.white, "Pieces Action Gammes / Prs", ToolsBarCtrl_GammesPieces_Actions_PRS, tooltip: "Pieces Action non créées dans Gammes / Prs"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Actions_DESC ? Colors.indigo : Colors.black12, !isGammesPieces_Actions_DESC ? Colors.black : Colors.white, "Pieces Action Gammes / Desc", ToolsBarCtrl_GammesPieces_Actions_DESC, tooltip: "Pieces Action non créées dans Gammes / Desc"),
                  Container(
                    width: 8,
                  ),
                ]),
                Container(
                  height: 10,
                ),
                Row(children: [
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesMixte_Produit_PDT ? Colors.indigo : Colors.black12, !isGammesMixte_Produit_PDT ? Colors.black : Colors.white, "Mixte Produit Gammes / Pdt", ToolsBarCtrl_GammesMixte_Produit_PDT, tooltip: "Mixte Produit non créées dans Gammes / PDT"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesMixte_Produit_POIDS ? Colors.indigo : Colors.black12, !isGammesMixte_Produit_POIDS ? Colors.black : Colors.white, "Mixte Produit Gammes / Poids", ToolsBarCtrl_GammesMixte_Produit_POIDS, tooltip: "Mixte Produit non créées dans Gammes / Poids"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesMixte_Produit_CLF ? Colors.indigo : Colors.black12, !isGammesMixte_Produit_CLF ? Colors.black : Colors.white, "Mixte Produit Gammes / CLF", ToolsBarCtrl_GammesMixte_Produit_CLF, tooltip: "Mixte Produit non créées dans Gammes / CLF"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesMixte_Produit_DESC ? Colors.indigo : Colors.black12, !isGammesMixte_Produit_DESC ? Colors.black : Colors.white, "Mixte Produit Gammes / Desc", ToolsBarCtrl_GammesMixte_Produit_DESC, tooltip: "Mixte Produit non créées dans Gammes / Desc"),
                ]),
                Container(
                  height: 10,
                ),
                Row(children: [
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Det_Inc_PDT ? Colors.indigo : Colors.black12, !isGammesPieces_Det_Inc_PDT ? Colors.black : Colors.white, "Pieces Det Inc Gammes / Pdt", ToolsBarCtrl_GammesPieces_Det_Inc_PDT, tooltip: "Pieces Det Inc non créées dans Gammes / PDT"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Det_Inc_POIDS ? Colors.indigo : Colors.black12, !isGammesPieces_Det_Inc_POIDS ? Colors.black : Colors.white, "Pieces Det Inc Gammes / Poids", ToolsBarCtrl_GammesPieces_Det_Inc_POIDS, tooltip: "PiecesPieces_Det_Inc non créées dans Gammes / Poids"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Det_Inc_PRS ? Colors.indigo : Colors.black12, !isGammesPieces_Det_Inc_PRS ? Colors.black : Colors.white, "PiecesPieces_Det_Inc Gammes / Prs", ToolsBarCtrl_GammesPieces_Det_Inc_PRS, tooltip: "PiecesPieces_Det_Inc non créées dans Gammes / Prs"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Det_Inc_CLF ? Colors.indigo : Colors.black12, !isGammesPieces_Det_Inc_CLF ? Colors.black : Colors.white, "PiecesPieces_Det_Inc Gammes / CLF", ToolsBarCtrl_GammesPieces_Det_Inc_CLF, tooltip: "PiecesPieces_Det_Inc non créées dans Gammes / CLF"),
                  Container(
                    width: 8,
                  ),
                  CommonAppBar.BtnRoundtext(context, isGammesPieces_Det_Inc_DESC ? Colors.indigo : Colors.black12, !isGammesPieces_Det_Inc_DESC ? Colors.black : Colors.white, "PiecesPieces_Det_Inc Gammes / Desc", ToolsBarCtrl_GammesPieces_Det_Inc_DESC, tooltip: "PiecesPieces_Det_Inc non créées dans Gammes / Desc"),
                  Container(
                    width: 8,
                  ),
                ]),
                Container(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          !isGammesPiecesDet ? Container() : GammesArticles_GridWidget(),
          !isGammesPieces_Actions_PDT ? Container() : GammesPieces_Actions_GridWidget(),
          !isGammesPieces_Actions_POIDS ? Container() : GammesPieces_Actions_GridWidget(),
          !isGammesPieces_Actions_PRS ? Container() : GammesPieces_Actions_GridWidget(),
          !isGammesPieces_Actions_DESC ? Container() : GammesPieces_Actionssearchresult_GridWidget(),
          !isGammesMixte_Produit_PDT ? Container() : GammesMixte_Produit_GridWidget(),
          !isGammesMixte_Produit_POIDS ? Container() : GammesMixte_Produit_GridWidget(),
          !isGammesMixte_Produit_CLF ? Container() : GammesMixte_Produit_GridWidget(),
          !isGammesMixte_Produit_DESC ? Container() : GammesMixte_Produitsearchresult_GridWidget(),
          !isGammesPieces_Det_Inc_PDT ? Container() : GammesPieces_Det_Inc_GridWidget(),
          !isGammesPieces_Det_Inc_POIDS ? Container() : GammesPieces_Det_Inc_GridWidget(),
          !isGammesPieces_Det_Inc_PRS ? Container() : GammesPieces_Det_Inc_GridWidget(),
          !isGammesPieces_Det_Inc_CLF ? Container() : GammesPieces_Det_Incsearchresult_GridWidget(),
          !isGammesPieces_Det_Inc_DESC ? Container() : GammesPieces_Det_Incsearchresult_GridWidget(),
        ],
      ),
    );
  }

  Widget GammesArticles_GridWidget() {
    List<EasyTableColumn<NF074_Pieces_Det>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_DetId} "),
      new EasyTableColumn(name: 'Ref', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_CodeArticle}"),
      new EasyTableColumn(name: 'Codf', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_CODF}"),
      new EasyTableColumn(name: 'Fabricant', grow: 6, stringValue: (row) => "${row.NF074_Pieces_Det_FAB}"),
      new EasyTableColumn(name: 'Clé', grow: 12, stringValue: (row) => "${row.NF074_Pieces_Det_DESC} / ${row.NF074_Pieces_Det_PRS} / ${row.NF074_Pieces_Det_CLF} / ${row.NF074_Pieces_Det_MOB} / ${row.NF074_Pieces_Det_PDT} / ${row.NF074_Pieces_Det_POIDS} / ${row.NF074_Pieces_Det_GAM}"),
      new EasyTableColumn(name: 'Certif', grow: 2, stringValue: (row) => "${row.NF074_Pieces_Det_NCERT}"),
    ];

    //   print("NF074_GammesGridWidget");
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

  Widget GammesPieces_Actions_GridWidget() {
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

  Widget GammesPieces_Actionssearchresult_GridWidget() {
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

    _model = EasyTableModel<NF074_Pieces_Actions>(rows: DbTools.ListNF074_Pieces_Actionssearchresult, columns: wColumns);

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

  Widget GammesMixte_Produit_GridWidget() {
    List<EasyTableColumn<NF074_Mixte_Produit>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Mixte_ProduitId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Mixte_Produit_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_PDT}"),
      new EasyTableColumn(name: 'CLF', grow: 1, stringValue: (row) => "${row.NF074_Mixte_Produit_CLF}"),
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

  Widget GammesMixte_Produitsearchresult_GridWidget() {
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

    _model = EasyTableModel<NF074_Mixte_Produit>(rows: DbTools.ListNF074_Mixte_Produitsearchresult, columns: wColumns);

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

  Widget GammesPieces_Det_Inc_GridWidget() {
    List<EasyTableColumn<NF074_Pieces_Det_Inc>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_Det_IncId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PRS}"),
      new EasyTableColumn(name: 'CLF', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_CLF}"),
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

  Widget GammesPieces_Det_Incsearchresult_GridWidget() {
    List<EasyTableColumn<NF074_Pieces_Det_Inc>> wColumns = [
      new EasyTableColumn(name: 'Id', stringValue: (row) => "${row.NF074_Pieces_Det_IncId} "),
      new EasyTableColumn(name: 'DESC', grow: 5, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_DESC}"),
      new EasyTableColumn(name: 'PDT', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PDT}"),
      new EasyTableColumn(name: 'POIDS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_POIDS}"),
      new EasyTableColumn(name: 'PRS', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_PRS}"),
      new EasyTableColumn(name: 'CLF', grow: 1, stringValue: (row) => "${row.NF074_Pieces_Det_Inc_CLF}"),
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
