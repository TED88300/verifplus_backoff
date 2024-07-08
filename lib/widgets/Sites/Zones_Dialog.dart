import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/Contacts/Ctact_Zone.dart';
import 'package:verifplus_backoff/widgets/Sites/Zones_Zone.dart';


class Zones_Dialog extends StatefulWidget {
  final Site site;
  const Zones_Dialog({Key? key, required this.site}) : super(key: key);

  @override
  State<Zones_Dialog> createState() => _Zones_DialogState();
}

class _Zones_DialogState extends State<Zones_Dialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  Future initLib() async {
    await DbTools.getGroupeID(widget.site.Site_GroupeId);
    await DbTools.getContactClientAdrType(DbTools.gClient.ClientId, DbTools.gSite.SiteId, "SITE");


    setState(() {});
  }

  void initState() {
    print("initState >");
    initLib();
    super.initState();
    Title = "Zone";
    print("initState <");
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    print("screenWidth $screenWidth");

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


  void onMaj() async {
    print("Parent onMaj()");
    setState(() {});
  }

  Widget Content(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//        ToolsBar(context),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContentDetailCadre(context),
              (DbTools.gViewCtact.isNotEmpty) ?
              Ctact_Zone(onMaj : onMaj,) :
              Zones_Zone(onMaj : onMaj,)
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
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 100),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Client #${DbTools.gClient.ClientId} ${DbTools.gClient.Client_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
              Container(
                width: 400,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 100),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Groupe #${DbTools.gGroupe.GroupeId} ${DbTools.gGroupe.Groupe_Nom}',
                  style: gColors.bodyTitle1_B_Wr,
                ),
              ),
              Container(
                width: 600,
                margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 100),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: gColors.LinearGradient1,
                child: Text(
                  'Site #${widget.site.SiteId} ${widget.site.Site_Nom}',
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

//      Expanded(child:
        FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child:

                Row(children: [

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
                    ],
                  ),

                  Container(width: 50),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          gColors.Txt(80, "Contact", "${DbTools.gContact.Contact_Prenom} ${DbTools.gContact.Contact_Nom}"),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        children: [
                          gColors.Txt(80, "Portable", "${DbTools.gContact.Contact_Tel2}"),
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        children: [
                          gColors.Txt(80, "eMail", "${DbTools.gContact.Contact_eMail}"),
                        ],
                      ),
                    ],
                  )

                ],)



                //)
                ));
  }
}
