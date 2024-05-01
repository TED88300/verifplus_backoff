import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/buttons_tabbar.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/Interventions/Intervention_Parc.dart';


class Intervention_Dialog extends StatefulWidget {
  final Site site;
  const Intervention_Dialog({Key? key, required this.site}) : super(key: key);

  @override
  State<Intervention_Dialog> createState() => _Intervention_DialogState();
}

class _Intervention_DialogState extends State<Intervention_Dialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;

  String selectedUserInter = "";
  String selectedUserInterID = "";

  String selectedUserInter2 = "";
  String selectedUserInterID2 = "";

  Future initLib() async {
    await DbTools.getGroupeID(widget.site.Site_GroupeId);

    selectedUserInter = DbTools.List_UserInter[0];
    selectedUserInterID = DbTools.List_UserInterID[0];

    selectedUserInter2 = DbTools.List_UserInter[0];
    selectedUserInterID2 = DbTools.List_UserInterID[0];

    if (DbTools.gIntervention.Intervention_Responsable!.isNotEmpty) {
      DbTools.getUserid(DbTools.gIntervention.Intervention_Responsable!);
      selectedUserInter = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter $selectedUserInter");
      selectedUserInterID = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter)];
    }

    if (DbTools.gIntervention.Intervention_Responsable2!.isNotEmpty) {
      DbTools.getUserid(DbTools.gIntervention.Intervention_Responsable2!);
      selectedUserInter2 = "${DbTools.gUser.User_Nom} ${DbTools.gUser.User_Prenom}";
      print("selectedUserInter2 $selectedUserInter2");
      selectedUserInterID2 = DbTools.List_UserInterID[DbTools.List_UserInter.indexOf(selectedUserInter2)];
    }


    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
    Title = "Intervention";
  }


  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
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

  List<Widget> _getChildren1 = [];
  int sel = 0;


  Widget Content(BuildContext context) {
    _getChildren1 = [
      Intervention_Parc( ),

    ];
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContentDetailCadre(context),
              _getChildren1[sel],
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
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
    return
        FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Container(

                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child:
                Row(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                  Container(width: 500, child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          gColors.Txt(80, "Site", "${widget.site.Site_Code} ${widget.site.Site_Nom}"),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        children: [
                          gColors.Txt(80, "Adresse", "${widget.site.Site_Adr1} ${widget.site.Site_CP} ${widget.site.Site_Ville}"),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        children: [
                          gColors.Txt(80, "", ""),
                        ],
                      ),
                    ],
                  ),),
                Container(width: 500, child:
                Column(
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

                    Container(width: 500, child:
                    Column(
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




                ],)
                )




        );
  }






}
