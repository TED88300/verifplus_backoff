import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Art.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Ent.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/Organes/Organe_Audit.dart';
import 'package:verifplus_backoff/widgets/Organes/Organe_Equip.dart';
import 'package:verifplus_backoff/widgets/Organes/Organe_Pieces.dart';
import 'package:verifplus_backoff/widgets/Organes/Organe_Verif.dart';
import 'package:verifplus_backoff/widgets/Planning/Planning.dart';
import 'package:verifplus_backoff/widgetTools/gObj.dart';

class Organe_Dialog extends StatefulWidget {
  @override
  State<Organe_Dialog> createState() => _Organe_DialogState();
}

class _Organe_DialogState extends State<Organe_Dialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  double screenHeight = 0;
  String selectedUserInter = "";
  String selectedUserInterID = "";
  String selectedUserInter2 = "";
  String selectedUserInterID2 = "";
  String DescAff = "";
  String DescAffnewParam = "";

  Future initLib() async {
    await DbTools.getContactSite(DbTools.gSite.SiteId);
    await DbTools.getParc_EntID(DbTools.gIntervention.InterventionId!);
    await DbTools.getParc_DescID(DbTools.gIntervention.InterventionId!);

    await DbTools.getParam_Saisie_Base("Audit");
    DbTools.ListParam_Saisie_Base.sort(DbTools.affSort2Comparison);
    DbTools.ListParam_Audit_Base.clear();
    DbTools.ListParam_Audit_Base.addAll(DbTools.ListParam_Saisie_Base);
    await DbTools.getParam_Saisie_Base("Verif");
    DbTools.ListParam_Verif_Base.sort(DbTools.affSort2Comparison);
    DbTools.ListParam_Verif_Base.clear();
    DbTools.ListParam_Verif_Base.addAll(DbTools.ListParam_Saisie_Base);
    await DbTools.getParam_Saisie_Base("Desc");
    DbTools.ListParam_Saisie_Base.sort(DbTools.affSort2Comparison);
    DescAff = "";
    int countCol = 0;

    await DbTools.getParam_Saisie("Ext", "Desc");

    print(">>>>>>>>>>> DescAffnewParam $DescAffnewParam");
    //DescAffnewParam PDT POIDS PRS MOB / ZNE EMP NIV / ANN / FAB
    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(DbTools.ListParam_Saisie_Base);
    Parc_Ent elementEnt = DbTools.gParc_Ent;

    print(" elementEnt Parcs_CodeArticle ${elementEnt.Parcs_CodeArticle} ${elementEnt.toString()}");

    DescAff = DescAffnewParam;
    List<String?>? parcsCols = [];

    for (int i = 0; i < listparamSaisieTmp.length; i++) {
      Param_Saisie element = listparamSaisieTmp[i];
      listparamSaisieTmp[i].Param_Saisie_Value = "";

//      print(" listparamSaisieTmp ${element.Desc()}");

      if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_FREQ_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_FREQ_Label!;
      } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_ANN_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_ANN_Label!;
      } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_NIV_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_NIV_Label!;
      } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_ZNE_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_ZNE_Label!;
      } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_EMP_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_EMP_Label!;
      } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_LOT_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_LOT_Label!;
      } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
        DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(elementEnt.Parcs_SERIE_Label!, element.Param_Saisie_ID)}");
        listparamSaisieTmp[i].Param_Saisie_Value = elementEnt.Parcs_SERIE_Label!;
      } else {
        bool trv = false;


        DbTools.ListParc_Desc.forEach((element2) {
//              print(" DESC EQUIP ${element2.ParcsDesc_Type} ${elementEnt.ParcsId} ${element2.ParcsDesc_Lib!}");
          if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
            DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "${gColors.AbrevTxt_Saisie_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}");
            listparamSaisieTmp[i].Param_Saisie_Value = element2.ParcsDesc_Lib!;
            trv = true;
          }
        });
        if (!trv) {
          DescAff = DescAff.replaceAll("${element.Param_Saisie_ID}", "");
        }
      }
    };

    if (DescAff.compareTo(DescAffnewParam) == 0) DescAff = "";
    String wTmp = DescAff;
    wTmp = wTmp.replaceAll("---", "");
    wTmp = wTmp.replaceAll("/", "");
    wTmp = wTmp.replaceAll(" ", "");
    if (wTmp.length == 0) DescAff = "";

    DescAff = "N°${elementEnt.Parcs_order} ${DescAff}";
    elementEnt.Parcs_Date_Desc = DescAff;
    print("🁢🁢🁢🁢🁢🁢🁢  DescAff ${DescAff}");
    setState(() {});

    DbTools.listparamSaisieEquip.clear();
    for (int i = 0; i < listparamSaisieTmp.length; i++) {
      Param_Saisie element = listparamSaisieTmp[i];


      if (element.Param_Saisie_Controle != "Group" && element.Param_Saisie_Organe == "Base" )
          {
            DbTools.listparamSaisieEquip.add(element);
          }
      }

    for (int i = 0; i < listparamSaisieTmp.length; i++) {
      Param_Saisie element = listparamSaisieTmp[i];
      if (element.Param_Saisie_Controle != "Group" && element.Param_Saisie_Organe == "Ext" )
      {
        DbTools.listparamSaisieEquip.add(element);
      }
    }

    for (int i = 0; i < DbTools.listparamSaisieEquip.length; i++) {
      Param_Saisie element = DbTools.listparamSaisieEquip[i];
//      print(" listparamSaisieTmp ${element.DescSimpl()}");
    }



    for (int i = 0; i < DbTools.ListParam_Audit_Base.length; i++) {
      Param_Saisie element = DbTools.ListParam_Audit_Base[i];
 //     print(" Param_Saisie AUDIT ${element.Desc()}");

      DbTools.ListParc_Desc.forEach((element2) {
        if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
          DbTools.ListParam_Audit_Base[i].Param_Saisie_Value = element2.ParcsDesc_Lib!;
        }
      });
    }
    for (int i = 0; i < DbTools.ListParam_Verif_Base.length; i++) {
      Param_Saisie element = DbTools.ListParam_Verif_Base[i];

      DbTools.ListParc_Desc.forEach((element2) {
//        print(" DESC AUDIT ${element2.ParcsDesc_Type} ${elementEnt.ParcsId} ${element2.ParcsDesc_Lib!}");
        if (elementEnt.ParcsId == element2.ParcsDesc_ParcsId && element.Param_Saisie_ID == element2.ParcsDesc_Type) {
          DbTools.ListParam_Verif_Base[i].Param_Saisie_Value = element2.ParcsDesc_Lib!;
        }
      });
    }


    await DbTools.getParc_Art(elementEnt.ParcsId!);
//    print(" getParc_Art ${DbTools.ListParc_Art.length}");

    DbTools.ListParc_Art_P.clear();
    for (int i = 0; i < DbTools.ListParc_Art.length; i++) {
      Parc_Art parc_Art = DbTools.ListParc_Art[i];
      if(parc_Art.ParcsArt_Type == "P" || parc_Art.ParcsArt_Type == "V" )
        {
          DbTools.ListParc_Art_P.add(parc_Art);
        }
    }

    DbTools.ListParc_Art_M.clear();
    for (int i = 0; i < DbTools.ListParc_Art.length; i++) {
      Parc_Art parc_Art = DbTools.ListParc_Art[i];
      if(parc_Art.ParcsArt_Type == "M" )
      {
        DbTools.ListParc_Art_M.add(parc_Art);
      }
    }


    DbTools.ListParc_Art_S.clear();
    for (int i = 0; i < DbTools.ListParc_Art.length; i++) {
      Parc_Art parc_Art = DbTools.ListParc_Art[i];
      if(parc_Art.ParcsArt_Type == "Mo" || parc_Art.ParcsArt_Type == "Dn" )
      {
        DbTools.ListParc_Art_S.add(parc_Art);
      }
    }



    setState(() {});
  }

  void initState() {



    DbTools.getParam_ParamMemDet("Param_Div", "Ext_Desc");
    if (DbTools.ListParam_Param.length > 0) DescAffnewParam = DbTools.ListParam_Param[0].Param_Param_Text;

    initLib();
    super.initState();
    Title = "Intervention / Organe";
  }


  void onMaj() async {
    initLib();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    print(" build   ${DescAff}");


    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (Title.isEmpty) return Container();
    return Center(
      child: Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: gColors.white,
            appBar: AppBar(
              backgroundColor: gColors.primary,
              automaticallyImplyLeading: false,
              title: Container(
                  color: gColors.primary,
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      InkWell(
                        child: SizedBox(
                            height: 100.0,
                            width: 100.0, // fixed width and height
                            child: new Image.asset(
                              'assets/images/AppIcow.png',
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      Text(
                        Title,
                        textAlign: TextAlign.center,
                        style: gColors.bodyTitle1_B_W,
                      ),
                      Spacer(),
                      gColors.BtnAffUser(context),
                      Container(
                        width: 150,
                        child: Text(
                          "Version : ${DbTools.gVersion}",
                          style: gColors.bodySaisie_N_W,
                        ),
                      ),
                    ],
                  )),
            ),
            body: Content(context),
          )),
    );
  }

  List<Widget> widgetChildren = [];
  int sel = 0;
  Widget taBarContainer() {
    widgetChildren = [
      Organe_EquipDialog(onMaj: onMaj),
      Organe_AuditDialog(onMaj: onMaj),
      Organe_VerifDialog(onMaj: onMaj),
      Organe_PiecesDialog(wListParc_Art: DbTools.ListParc_Art_P),
      Organe_PiecesDialog(wListParc_Art: DbTools.ListParc_Art_M),
      Organe_PiecesDialog(wListParc_Art: DbTools.ListParc_Art_S),
      Organe_PiecesDialog(wListParc_Art: DbTools.ListParc_Art),
    ];

    return TabContainer(
      tabDuration: Duration(milliseconds: 600),
      color: gColors.primary,
      children: widgetChildren,
      selectedTextStyle: gColors.bodyTitle1_B_Wr,
      unselectedTextStyle: gColors.bodyTitle1_B_Gr,
      tabExtent: 40,
      tabs: [
        'Equipement',
        'Audit',
        'Vérification',
        'Pièces',
        'Mixte',
        'Services',
        'Synthèse',
      ],
    );
  }

  Widget Content(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContentDetailCadre(context),
              Container(
                width: screenWidth,
                height: screenHeight - 350,//330
//                color: Colors.red,
                child: taBarContainer(),
              ),
            ],
          )),
        ),
      ]),
    );
  }

  Widget ContentDetailCadre(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gColors.primary, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentDetail(context),
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 5,
          child: Container(
              child: Row(
            children: [
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 50),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Client #${DbTools.gClient.ClientId} ${DbTools.gClient.Client_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 50),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Groupe #${DbTools.gGroupe.GroupeId} ${DbTools.gGroupe.Groupe_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 50),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Site #${DbTools.gSite.SiteId} ${DbTools.gSite.Site_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 50),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Zone #${DbTools.gZone.ZoneId} ${DbTools.gZone.Zone_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget ContentDetail(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            width: screenWidth - 22,
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              gColors.Txt(80, "Site", "${DbTools.gSite.Site_Code} ${DbTools.gSite.Site_Nom}"),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              gColors.Txt(80, "Adresse", "${DbTools.gSite.Site_Adr1} ${DbTools.gSite.Site_CP} ${DbTools.gSite.Site_Ville}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                gColors.Txt(80, "Date", "${DbTools.gIntervention.Intervention_Date}"),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              children: [
                                gColors.Txt(80, "Organes", "${DbTools.gIntervention.Intervention_Parcs_Type}"),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              children: [
                                gColors.Txt(80, "Type", "${DbTools.gIntervention.Intervention_Type}"),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              children: [
                                gColors.Txt(80, "Remarques", "${DbTools.gIntervention.Intervention_Remarque}"),
                              ],
                            ),
                          ],
                        )),
                    Container(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                gColors.Txt(80, "Status", "${DbTools.gIntervention.Intervention_Status}"),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              children: [
                                gColors.Txt(80, "Facturation", "${DbTools.gIntervention.Intervention_Facturation}"),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              children: [
                                gColors.Txt(180, "Responsable Commercial", "${selectedUserInter}"),
                              ],
                            ),
                            Container(height: 10),
                            Row(
                              children: [
                                gColors.Txt(180, "Responsable Technique", "${selectedUserInter2}"),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                Container(
                  decoration: BoxDecoration(
                    color: gColors.white,
                    border: Border.all(color: gColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                     child:gObj.buildImage(DbTools.gParc_Ent.Parcs_CodeArticle!,120),
                    ),

                    Container(width: 10,),

                    Container(
                      width: screenWidth - 180,
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5),
                      decoration: BoxDecoration(
                        color: gColors.primary,
                        border: Border.all(color: gColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(
                        '${DescAff}',
                        style: gColors.bodyTitle1_B_Wr,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  void ToolsPlanning() async {
    print("ToolsPlanning");
    await showDialog(context: context, builder: (BuildContext context) => new Planning(bAppBar: true));
    setState(() {});
  }

  Widget wScreen(String wTxt) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$wTxt"),
            ],
          ),
        ],
      ),
    );
  }
}
