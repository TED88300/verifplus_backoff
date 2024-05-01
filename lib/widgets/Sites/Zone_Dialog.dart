import 'package:flutter/material.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/Sites/Zone_Interv.dart';

class Zone_Dialog extends StatefulWidget {
  const Zone_Dialog({Key? key}) : super(key: key);

  @override
  State<Zone_Dialog> createState() => _Zone_DialogState();
}

class _Zone_DialogState extends State<Zone_Dialog> with SingleTickerProviderStateMixin {
  String Title = "";
  double screenWidth = 0;
  Future initLib() async {
    setState(() {});
  }

  void initState() {
    print("initState >");
    initLib();
    super.initState();
    Title = "Interventions";
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
                        style: gColors.bodyTitle1_B_Wr,
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
      Zone_Interv(),
      Zone_Interv(),
  //    Zone_Ctact(),
    ];
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

//      Expanded(child:
        FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        gColors.Txt(80, "Zone", "#${DbTools.gZone.ZoneId} ${DbTools.gZone.Zone_Nom}"),
                      ],
                    ),
                    Container(height: 10),
                    Row(
                      children: [
                        gColors.Txt(80, "Adresse", "${DbTools.gZone.Zone_Adr1} ${DbTools.gZone.Zone_CP} ${DbTools.gZone.Zone_Ville}"),
                      ],
                    ),
                  ],
                )
                //)
                ));
  }
}
