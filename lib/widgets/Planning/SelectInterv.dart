// SELECTION INTERVENTION

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Clients.dart';
import 'package:verifplus_backoff/Tools/Srv_Groupes.dart';
import 'package:verifplus_backoff/Tools/Srv_Interventions.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/Tools/Srv_Zones.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

typedef selChanged = void Function(selChangedDetails pickerChangedDetails);

class selChangedDetails {
  selChangedDetails({this.depot, this.client, this.groupe, this.site, this.zone, this.intervention});
  final String? depot;
  final Client? client;
  final Groupe? groupe;
  final Site? site;
  final Zone? zone;
  final Intervention? intervention;
}

class SelectInter extends StatefulWidget {
  const SelectInter({required this.onChanged});
  final selChanged onChanged;

  @override
  State<StatefulWidget> createState() => SelectInterState();
}

class SelectInterState extends State<SelectInter> {
  final Search_Client_TextController = TextEditingController();
  final Search_Site_TextController = TextEditingController();

  String selDepot = "";
  List<String> ListDepot = [];

  Client selClient = Client.ClientInit();
  List<Client> ListClient = [];

  Groupe selGroupe = Groupe.GroupeInit();
  List<Groupe> ListGroupe = [];

  Site selSite = Site.SiteInit();
  List<Site> ListSite = [];

  Zone selZone = Zone.ZoneInit();
  List<Zone> ListZone = [];

  Intervention selIntervention = Intervention.InterventionInit();
  List<Intervention> ListIntervention = [];

  Future FlitreClient() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    await DbTools.getClientRech(Search_Client_TextController.text);
    print(">>>>>> ${DbTools.ListClient.length}");
    ListClient.addAll(DbTools.ListClient);

    setState(() {});
  }

  Future FlitreSite() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    print(">>>>>> FlitreSite");

    await DbTools.getSiteRech(Search_Site_TextController.text);
    print(">>>>>> ${DbTools.ListSite.length}");
    ListSite.addAll(DbTools.ListSite);
    print(">>>>>> ${ListSite.length}");
    setState(() {});
  }

  Future Relaod() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    if (selDepot.isNotEmpty) {
      await DbTools.getClientDepotp(selDepot);
      print(">>>>>> ${DbTools.ListClient.length}");
      ListClient.addAll(DbTools.ListClient);

      if (ListClient.length == 1) selClient = ListClient[0];

      if (selClient.ClientId > 0) {
        await DbTools.getGroupesClient(selClient.ClientId);
        print(">>>>>> ${DbTools.ListGroupe.length}");
        ListGroupe.addAll(DbTools.ListGroupe);

        if (ListGroupe.length == 1) selGroupe = ListGroupe[0];

        if (selGroupe.GroupeId > 0) {
          await DbTools.getSitesGroupe(selGroupe.GroupeId);
          print(">>>>>> ${DbTools.ListSite.length}");
          ListSite.addAll(DbTools.ListSite);

          if (ListSite.length == 1) selSite = ListSite[0];

          if (selSite.SiteId > 0) {
            await DbTools.getZonesSite(selSite.SiteId);
            print(">>>>>> ${DbTools.ListZone.length}");
            ListZone.addAll(DbTools.ListZone);

            if (ListZone.length == 1) selZone = ListZone[0];

            if (selZone.ZoneId > 0) {
              await DbTools.getInterventionsZone(selSite.SiteId);
              print(">>>>>> ${DbTools.ListIntervention.length}");
              ListIntervention.addAll(DbTools.ListIntervention);
            }
          }
        }
      }
    }
    setState(() {});
  }

  void initLib() async {
    await DbTools.initListFam();
    await DbTools.getAdresseType("AGENCE");
    ListDepot.clear();
    DbTools.ListAdresse.forEach((wAdresse) {
      ListDepot.add(wAdresse.Adresse_Nom);
    });
    await Relaod();
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: gColors.wTheme,
        child: AlertDialog(
          title: Container(
            width: 400,
            color: gColors.primary,
            child: Row(
              children: [
                Container(
                  width: 10,
                ),
                InkWell(
                  child: SizedBox(
                      height: 30.0,
                      child: new Image.asset(
                        'assets/images/AppIcow.png',
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Text(
                  "Recherche Intervention",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_W,
                ),
                Spacer(),
                Container(
                  width: 40,
                ),
              ],
            ),
          ),
          content: Container(
              width: 2000,
              height: 500,
              child: Row(
                children: [
                  listDepots(),
                  SizedBox(
                    width: 10,
                  ),
                  listClients(),
                  SizedBox(
                    width: 10,
                  ),
                  listGroupes(),
                  SizedBox(
                    width: 10,
                  ),
                  listSites(),
                  SizedBox(
                    width: 10,
                  ),
                  listZones(),
                  SizedBox(
                    width: 10,
                  ),
                  listInterventions(),
                ],
              )),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.onChanged(selChangedDetails(depot: selDepot, client: selClient, groupe: selGroupe, site: selSite, zone: selZone, intervention: selIntervention));
                });

                // ignore: always_specify_types
                Future.delayed(const Duration(milliseconds: 200), () {
                  // When task is over, close the dialog
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: gColors.primaryGreen,
              ),
              child: Text(
                'Valider',
                style: gColors.bodySaisie_B_W,
                //    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ));
  }

  Widget listDepots() {
    double h = 500;
    return Column(
      children: [
        Container(
          width: 200,
          height: 32,
        ),
        Container(
          width: 200,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Agences",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              Container(
                  width: 200,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListDepot.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String wDepot = ListDepot[index];
                      return new Container(
                        decoration: new BoxDecoration(
                          color: (wDepot == selDepot) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wDepot == selDepot),
                          selectedColor: Colors.white,
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(wDepot),
                          onTap: () async {
                            if (selDepot != wDepot)
                              selDepot = wDepot;
                            else
                              selDepot = "";
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget listClients() {
    double h = 500;
    double W = 350;
    return Container(
      width: W,
      height: h,
      decoration: BoxDecoration(
          color: gColors.white,
          border: Border.all(
            color: gColors.primary,
          )),
      child: Column(
        children: [
          TextFormField(
            controller: Search_Client_TextController,
            decoration: gColors.wRechInputDecorationSelPlanning,
            onChanged: (String? value) async {
              if (Search_Client_TextController.text.length >= 2) {
                selDepot = "";
                FlitreClient();
              }
            },
            style: gColors.bodySaisie_B_B,
          ),
          Container(
            width: W,
            height: 20,
            color: gColors.primary,
            child: Text(
              "Clients",
              textAlign: TextAlign.center,
              style: gColors.bodySaisie_B_W,
            ),
          ),
          Container(
              width: W,
              height: h - 54,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ListClient.length,
                itemBuilder: (BuildContext context, int index) {
                  final Client wClient = ListClient[index];
                  return new Container(
                    decoration: new BoxDecoration(
                      color: (wClient.ClientId == selClient.ClientId) ? Colors.blue : Colors.white,
                    ),
                    child: ListTile(
                      dense: true,
                      selected: (wClient.ClientId == selClient.ClientId),
                      selectedColor: Colors.white,
                      visualDensity: VisualDensity(vertical: -4),
                      title: Text(wClient.Client_Nom),
                      onTap: () async {
                        if (selClient.ClientId != wClient.ClientId) {
                          selClient = wClient;
                          Search_Client_TextController.text = "";
                          selDepot = selClient.Client_Depot;
                        } else
                          selClient = Client.ClientInit();
                        await Relaod();
                      },
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget listGroupes() {
    double h = 500;
    return Column(
      children: [
        Container(
          width: 200,
          height: 32,
        ),
        Container(
          width: 200,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Groupes",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              Container(
                  width: 200,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListGroupe.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Groupe wGroupe = ListGroupe[index];
                      return new Container(
                        decoration: new BoxDecoration(
                          color: (wGroupe.GroupeId == selGroupe.GroupeId) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wGroupe.GroupeId == selGroupe.GroupeId),
                          selectedColor: Colors.white,
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(wGroupe.Groupe_Nom),
                          onTap: () async {
                            if (selGroupe.GroupeId != wGroupe.GroupeId)
                              selGroupe = wGroupe;
                            else
                              selGroupe = Groupe.GroupeInit();
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget listSites() {
    double h = 500;
    double w = 390;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
          color: gColors.white,
          border: Border.all(
            color: gColors.primary,
          )),
      child: Column(
        children: [
          TextFormField(
            controller: Search_Site_TextController,
            decoration: gColors.wRechInputDecorationSelPlanning,
            onChanged: (String? value) async {
              if (Search_Site_TextController.text.length >= 2) {
                selDepot = "";
                FlitreSite();
              }
            },
            style: gColors.bodySaisie_B_B,
          ),
          Container(
            width: w,
            height: 20,
            color: gColors.primary,
            child: Text(
              "Sites",
              textAlign: TextAlign.center,
              style: gColors.bodySaisie_B_W,
            ),
          ),
          Container(
              width: w,
              height: h - 54,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ListSite.length,
                itemBuilder: (BuildContext context, int index) {
                  final Site wSite = ListSite[index];
                  return new Container(
                    decoration: new BoxDecoration(
                      color: (wSite.SiteId == selSite.SiteId) ? Colors.blue : Colors.white,
                    ),
                    child: ListTile(
                      dense: true,
                      selected: (wSite.SiteId == selSite.SiteId),
                      selectedColor: Colors.white,
                      visualDensity: VisualDensity(vertical: -4),
                      title: Text(wSite.Site_Nom),
                      onTap: () async {
                        if (selSite.SiteId != wSite.SiteId) {
                          selSite = wSite;
                          Search_Site_TextController.text = "";
                          await DbTools.getGroupe(selSite.Site_GroupeId);
                          selGroupe = DbTools.gGroupe;
                          await DbTools.getClient(selGroupe.Groupe_ClientId);
                          selClient = DbTools.gClient;
                          selDepot = selClient.Client_Depot;
                        } else
                          selSite = Site.SiteInit();
                        await Relaod();
                      },
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget listZones() {
    double h = 500;
    return Column(
      children: [
        Container(
          width: 200,
          height: 32,
        ),
        Container(
          width: 200,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Zones",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              Container(
                  width: 200,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListZone.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Zone wZone = ListZone[index];
                      return new Container(
                        decoration: new BoxDecoration(
                          color: (wZone.ZoneId == selZone.ZoneId) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wZone.ZoneId == selZone.ZoneId),
                          selectedColor: Colors.white,
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(wZone.Zone_Nom),
                          onTap: () async {
                            if (selZone.ZoneId != wZone.ZoneId)
                              selZone = wZone;
                            else
                              selZone = Zone.ZoneInit();
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget listInterventions() {
    double h = 500;
    double w = 400;

    return Column(
      children: [
        Container(
          width: 200,
          height: 32,
        ),
        Container(
          width: w,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: w,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Interventions",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              Container(
                  width: w,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListIntervention.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Intervention wIntervention = ListIntervention[index];
                      String wDate = "----/----/-------";
                      if (wIntervention.Intervention_Date!.isNotEmpty) wDate = wIntervention.Intervention_Date!;
                      return new Container(
                        decoration: new BoxDecoration(
                          color: (wIntervention.InterventionId == selIntervention.InterventionId) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wIntervention.InterventionId == selIntervention.InterventionId),
                          selectedColor: Colors.white,
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text("[${wIntervention.InterventionId}] ${wDate} ${wIntervention.Intervention_Type} ${wIntervention.Intervention_Parcs_Type} ${wIntervention.Intervention_Status}"),
                          onTap: () async {
                            if (selIntervention.InterventionId != wIntervention.InterventionId)
                              selIntervention = wIntervention;
                            else
                              selIntervention = Intervention.InterventionInit();
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }
}
