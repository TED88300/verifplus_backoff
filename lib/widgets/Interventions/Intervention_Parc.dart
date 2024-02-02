import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Contacts.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Desc.dart';
import 'package:verifplus_backoff/Tools/Srv_Parcs_Ent.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class Intervention_Parc extends StatefulWidget {
  const Intervention_Parc({Key? key}) : super(key: key);

  @override
  State<Intervention_Parc> createState() => _Intervention_ParcState();
}

class _Intervention_ParcState extends State<Intervention_Parc> {

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





    Filtre();

  }

  Future Filtre() async {
    List<Contact> ListContactsearchresultTmp = [];
    ListContactsearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListContactsearchresultTmp.addAll(DbTools.ListContact);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      DbTools.ListContact.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Desc().toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListContactsearchresultTmp.add(element);
        }
      });
    }

    DbTools.ListContactsearchresult.clear();
    DbTools.ListContactsearchresult.addAll(ListContactsearchresultTmp);





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
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: ParcGridWidget(),
                ),
              ),







            ],
          ),
        ],
      ),
    );
  }

  
  Widget ParcGridWidget() {
    List<EasyTableColumn<Parc_Ent>> wColumns = [

      new EasyTableColumn(name: 'Id', width: 60, stringValue: (row) => "${row.ParcsId}"),
      new EasyTableColumn(name: 'Organe', grow: 10, stringValue: (row) => "${row.Parcs_Date_Desc}"),


    ];
    print("ParcGridWidget ${DbTools.ListParc_Ent.length}");
    EasyTableModel<Parc_Ent>? _model;
    _model = EasyTableModel<Parc_Ent>(rows: DbTools.ListParc_Ent, columns: wColumns);
    return new EasyTableTheme(
        child: new EasyTable<Parc_Ent>(visibleRowsCount: 16, _model, onRowTap: (Contact) async {

        }),
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
