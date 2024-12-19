import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_geocoding_plus/google_geocoding_plus.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus_backoff/Tools/shared_Cookies.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgets/2-login.dart';
import 'package:verifplus_backoff/widgets/Agences/Agences.dart';
import 'package:verifplus_backoff/widgets/Articles/Articles_Ebp.dart';
import 'package:verifplus_backoff/widgets/Articles/Articles_Fam_Ebp.dart';
import 'package:verifplus_backoff/widgets/Clients/Clients.dart';
import 'package:verifplus_backoff/widgets/DashBoard.dart';
import 'package:verifplus_backoff/widgets/Fourns/Fourns.dart';
import 'package:verifplus_backoff/widgets/Interventions/Interventions.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Ctrl.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Ctrl2.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Gammes.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Histo_Normes.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Mixte_Produit.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Pieces_Actions.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Pieces_Det.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Pieces_Det_Inc.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Av.dart';


import 'package:verifplus_backoff/widgets/Param/Param_Fam_Dialog.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Hab.dart';
import 'package:verifplus_backoff/widgets/Planning/Planning.dart';
import 'package:verifplus_backoff/widgets/User/Niv_Desc.dart';
import 'package:verifplus_backoff/widgets/User/Niv_Hab.dart';
import 'package:verifplus_backoff/widgets/User/User_Liste.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Gamme_Dialog.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Param_Abrev_Dialog.dart';
import 'Param/Param_Param_Dialog.dart';
import 'Param/Param_Saisie_Dialog.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool isSuperMenu = false;

  Coordinates coordinates = Coordinates();
  late Widget wPlutoMenuBar;

  String wTitre = "Back-Office";

//  Widget wAff = Planning(bAppBar : false);
  Widget wAff = Interventions();
//  Widget wAff = Clients_screen();
//  Widget wAff = fourns_screen();
//  Widget wAff = User_Liste();

  Future initLib() async {
    var googleGeocoding = GoogleGeocoding(MapTools.apiKeyMap);
    List<Component> components = [];

    var risult = await googleGeocoding.geocoding.get("10 rue du Colonel Renard 88300 Neufchateau");
    print("<>> risult ${risult!.status}");

    risult.results!.forEach((element) {
      print("<>> formattedAddress ${element.formattedAddress}");
      print("<>> geometry ${element.geometry!.location!.lat} ${element.geometry!.location!.lng}");
      print("<>> northeast ${element.geometry!.viewport!.northeast!.lat} ${element.geometry!.viewport!.northeast!.lng}");
      print("<>> southwest ${element.geometry!.viewport!.southwest!.lat} ${element.geometry!.viewport!.southwest!.lng}");
      print("<>> placeId ${element.placeId}");
    });

    print("<>> initLib");
  }

  List<PlutoMenuItem> HoverMenus = [];

  @override
  void initState() {
    String str = "#@F&L^&%U##T#T@#ER###CA@#@M*(PU@&#S%^%2324.22@*(^&";
    String result = str.replaceAll(RegExp('[^0-9.]'), '');
    print("aaaaaaaaaaaaaaaaaaaaaa  $result");
    print("initLib >");
    initLib();
    print("initLib <>>");

    print("initState");
    HoverMenus = makeMenus(context);

    wPlutoMenuBar = new PlutoMenuBar(
      mode: PlutoMenuBarMode.tap,
      backgroundColor: gColors.primary,
      activatedColor: Colors.white,
      indicatorColor: Colors.deepOrange,
      textStyle: gColors.bodyTitle1_N_Wr,
      menuIconColor: Colors.white,
      moreIconColor: Colors.white,
      menus: HoverMenus,
    );

    isSuperMenu = true;
  }

  @override
  Widget build(BuildContext context) {
    print("build Menu");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: gColors.primary,
          title: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                      if (wAff.toString().contains("Articles_Fam_Ebp")) {
                        DbTools.gArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();
                        DbTools.gDemndeReload = true;
                        wAff = Articles_Fam_Ebp();
                        setState(() {});
                      }
                    },
                  ),
                  Spacer(),
                  Container(
                    width: 230,
                  ),
                  Text(
                    "$wTitre",
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_B_W,
                  ),
                  Spacer(),
                  gColors.BtnAffUser(context),
                  InkWell(
                    child: Container(
                      width: 150,
                      child: Text(
                        "Version : ${DbTools.gVersion}",
                        style: gColors.bodySaisie_N_W,
                      ),
                    ),
                    onTap: () {
                      CookieManager cm = CookieManager.getInstance();
                      cm.addToCookie("emailLogin", "");
                      cm.addToCookie("passwordLogin", "");
                      cm.addToCookie("IsRememberLogin", "");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                ],
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 1,
              color: Colors.white,
            ),
            wPlutoMenuBar,
            wAff,
          ],
        ),
      ),
    );
  }

  void message(context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(text),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<PlutoMenuItem> makeMenus(BuildContext context) {
    return [
      PlutoMenuItem(
        title: 'Tableau de bord',
        icon: Icons.dashboard,
        onTap: () {
          wTitre = "Planning";
          setState(() {
            wAff = DashBoard();
          });
        },
      ),
      PlutoMenuItem(
        title: 'Planning',
        icon: Icons.calendar_month,
        onTap: () {
          wTitre = "Planning";
          setState(() {
//        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Planning()));
            wAff = Planning(bAppBar: false);
          });
        },
      ),
      PlutoMenuItem(
        title: 'Interventions',
        icon: Icons.list_outlined,
        onTap: () {
          wTitre = "Interventions";
          setState(() {
//        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Planning()));

            wAff = Interventions();
          });
        },
      ),
      PlutoMenuItem(
        title: 'Clients',
        icon: Icons.hive,
        children: [
          PlutoMenuItem(
            title: 'Clients',
            icon: Icons.hive,
            onTap: () {
              wTitre = "Clients";
              setState(() {
                wAff = Clients_screen();
              });
            },
          ),
          PlutoMenuItem(
            title: 'Familles Clients',
            icon: Icons.hive,
            onTap: () {
              wTitre = "Familles Client";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Param_Fam_screen(wType: "FamClient", wSsFam: false, wTitle: "Familles Client");
              });
            },
          ),
          PlutoMenuItem(
            title: "Civilités",
            icon: Icons.hive,
            onTap: () {
              wTitre = "Civilités";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Param_Fam_screen(wType: "Civ", wSsFam: false, wTitle: "Civilités");
              });
            },
          ),
          PlutoMenuItem(
            title: "Types d'adresses",
            icon: Icons.hive,
            onTap: () {
              wTitre = "Types d'adresses";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Param_Fam_screen(wType: "TypeAdr", wSsFam: false, wTitle: "Types d'adresses");
              });
            },
          ),
          PlutoMenuItem(
            title: "Statut",
            icon: Icons.hive,
            onTap: () {
              wTitre = "Statut";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Param_Fam_screen(wType: "Statut", wSsFam: false, wTitle: "Statut");
              });
            },
          ),
          PlutoMenuItem(
            title: "Agences",
            icon: Icons.hive,
            onTap: () {
              wTitre = "hive";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Agences();
              });
            },
          ),
        ],
      ),
      PlutoMenuItem(
        title: 'Fournisseurs',
        icon: Icons.list_outlined,
        onTap: () {
          wTitre = "Fournisseurs";
          setState(() {
            wAff = fourns_screen();
          });
        },
      ),
      PlutoMenuItem(
        title: 'Articles',
        icon: Icons.widgets,
        children: [
          PlutoMenuItem(
            title: 'Articles EBP',
            icon: Icons.widgets,
            onTap: () {
              wTitre = "Articles EBP";
              setState(() {
                wAff = Article_Ebp_Liste();
              });
            },
          ),
          PlutoMenuItem(
            title: 'Familles / Sous Familles EBP',
            icon: Icons.widgets,
            onTap: () {
              wTitre = "Familles / Sous Familles Ebp";
              setState(() {
                DbTools.gArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();
                DbTools.gDemndeReload = true;
                wAff = Articles_Fam_Ebp();
              });
            },
          ),

          /*
          PlutoMenuItem(
            title: 'Articles',
            icon: Icons.people,
            onTap: () {
              wTitre = "Articles";
              setState(() {
                wAff = Articles_screen();
              });
            },
          ),
          PlutoMenuItem(
            title: 'Familles / Sous Familles',
            icon: Icons.people,
            onTap: () {
              wTitre = "Familles / Sous Familles";
              setState(() {
                wAff = Param_Fam_screen(wType: "Fam", wSsFam: true, wTitle: "Familles d'article");
              });
            },
          ),
     */
        ],
      ),
      PlutoMenuItem(title: 'Utilisateurs', icon: Icons.account_circle, children: [
        PlutoMenuItem(
          title: 'Utilisateurs',
          icon: Icons.account_circle,
          onTap: () {
            wTitre = "Utilisateurs";
            setState(() {
              wAff = User_Liste();
            });
          },
        ),
        PlutoMenuItem(
          title: 'Habilitations / Niveau',
          icon: Icons.badge,
          onTap: () {
            wTitre = "Habilitations / Niveau";
            setState(() {
              wAff = Niv_Hab();
            });
          },
        ),
        PlutoMenuItem(
          title: 'Hab. Desc. / Niveau',
          icon: Icons.badge,
          onTap: () {
            wTitre = "Hab. Desc. / Niveau";
            setState(() {
              wAff = Niv_Desc();
            });
          },
        ),
        PlutoMenuItem(
          title: 'Paramètres Droits',
          icon: Icons.badge,
          children: [
            PlutoMenuItem(
              title: "Groupes Habilitations",
              icon: Icons.badge,
              onTap: () {
                wTitre = "Groupes Habilitations";
                setState(() {
                  DbTools.gDemndeReload = true;
                  wAff = Param_Param_Abrev_screen(wType: "GrpHab", wTitle: "Groupes Habilitations");
                });
              },
            ),
            PlutoMenuItem(
              title: "Niveaux Habilitations",
              icon: Icons.badge,
              onTap: () {
                wTitre = "Niveaux Habilitations";
                setState(() {
                  DbTools.gDemndeReload = true;

                  wAff = Param_Param_Abrev_screen(wType: "NivHab", wTitle: "Niveaux Habilitations");
                });
              },
            ),
            PlutoMenuItem(
              title: "Types Utilisateur",
              icon: Icons.badge,
              onTap: () {
                wTitre = "Types Utilisateur";
                setState(() {
                  DbTools.gDemndeReload = true;

                  wAff = Param_Param_Abrev_screen(wType: "TypeUser", wTitle: "Type Utilisateurs");
                });
              },
            ),
          ],
        ),
      ]),
      PlutoMenuItem(
        title: 'Paramètres',
        icon: Icons.settings,
        children: [
          PlutoMenuItem(
            title: 'Elements de base',
            children: [
              PlutoMenuItem(
                title: "Paramètres divers",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Paramètres divers";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Param_Div", wTitle: "Paramètres divers", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Types d'organe",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Types d'organe";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Organe", wTitle: "Types d'organe", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Types de saisie",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Types de saisie";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Saisie", wTitle: "Types de saisie", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Types d'intervention",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Types d'intervention";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Interv", wTitle: "Types d'intervention", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Missions",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Missions";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Missions", wTitle: "Missions", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Statuts des interventions",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Statuts des interventions";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Status_Interv", wTitle: "Statuts des interventions", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Type de Facturation",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Type de Facturation";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Fact", wTitle: "Type de Facturation" , wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Contrôles de saisie",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Contrôles de saisie";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Ctrl_Saisie", wTitle: "Contrôles de saisie", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Mode Affichage Liste",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Mode Affichage Liste";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Aff_Liste", wTitle: "Mode Affichage Liste", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Couleurs",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Couleurs";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Color", wTitle: "Couleurs", wDef: false,);
                  });
                },
              ),
              PlutoMenuItem(
                title: "Abréviations",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Abréviations";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_Abrev_screen(wType: "Abrev", wTitle: "Abréviations");
                  });
                },
              ),
            ],
          ),
          PlutoMenuItem(
            title: 'Gestion Commerciale',
            children: [

              PlutoMenuItem(
                title: "Etat Devis",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Etat Devis";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Etat_Devis", wTitle: "Etat Devis", wDef: false,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Etat Commandes",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Etat Commandes";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Etat_Commandes", wTitle: "Etat Commandes", wDef: false,);
                  });
                },
              ),


              PlutoMenuItem(
                title: "Etat Livraison",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Etat Livraison";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Etat_Livraison", wTitle: "Etat Livraison", wDef: false,);
                  });
                },
              ),

              PlutoMenuItem.divider(height: 10, color: Colors.white),

              PlutoMenuItem(
                title: "Validité du devis",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Validité du devis";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Validite_devis", wTitle: "Validité du devis", wDef: true,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Livraison prévisionnelle",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Livraison prévisionnelle";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Livraison_prev", wTitle: "Livraison prévisionnelle", wDef: true,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Mode de règlement",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Mode de règlement";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Mode_rglt", wTitle: "Mode de règlement", wDef: true,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Moyen de paiement",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Moyen de paiement";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Moyen_paiement", wTitle: "Moyen de paiement", wDef: true,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Préférence d'affichage",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Préférence d'affichage";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Pref_Aff", wTitle: "Préférence d'affichage", wDef: true,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Non-valorisé/Valorisé",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Non-valorisé/Valorisé";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Valo", wTitle: "Non-valorisé/Valorisé", wDef: true,);
                  });
                },
              ),



              PlutoMenuItem(
                title: "Relance client auto",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Relance client auto";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Rel_Auto", wTitle: "Relance client auto", wDef: true,);
                  });
                },
              ),


              PlutoMenuItem(
                title: "Relance anniversaire",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Relance anniversaire";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Rel_Anniv", wTitle: "Relance anniversaire", wDef: true,);
                  });
                },
              ),

              PlutoMenuItem(
                title: "Copie des relances",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Copie des relances";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "CopRel", wTitle: "Copie des relances", wDef: true,);
                  });
                },
              ),


              PlutoMenuItem(
                title: "Titres Devis",
                icon: Icons.settings,
                onTap: () {
                  wTitre = "Titres Devis";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "TitresRel", wTitle: "Titres Devis", wDef: true,);
                  });
                },
              ),


              PlutoMenuItem.divider(height: 10, color: Colors.white),




            ],
          ),
          PlutoMenuItem(
            title: 'Paramètres de saisie',
            icon: Icons.settings,
            onTap: () {
              wTitre = "Paramètres de saisie";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Param_Saisie_screen(wTitle: "Eléments de saisie");
              });
            },
          ),
          PlutoMenuItem(
            title: 'Gammes',
            icon: Icons.settings,
            onTap: () {
              wTitre = "Gammes";
              setState(() {
                wAff = Param_Gamme_screen(wType: "Aff_Liste", wTitle: "Gammes");
              });
            },
          ),
          PlutoMenuItem(
            title: "Habilitations",
            icon: Icons.settings,
            onTap: () {
              wTitre = "Habilitations";
              setState(() {
                wAff = Param_Hab_screen();
              });
            },
          ),
          PlutoMenuItem(
            title: "Avertissements",
            icon: Icons.settings,
            onTap: () {
              wTitre = "Avertissements";
              setState(() {
                wAff = Param_Av_screen();
              });
            },
          ),
          PlutoMenuItem.divider(height: 10, color: Colors.white),
          PlutoMenuItem(title: 'NF074', icon: Icons.logo_dev, children: [
            PlutoMenuItem(
              title: "Contrôles Articles",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Contrôles Base de données NF074 : ARTICLES";
                setState(() {
                  wAff = NF074_Ctrl_screen();
                });
              },
            ),
            PlutoMenuItem(
              title: "Contrôles Gammes",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Contrôles Base de données NF074 : Gammes";
                setState(() {
                  wAff = NF074_Ctrl2_screen();
                });
              },
            ),
            PlutoMenuItem.divider(height: 10, color: Colors.white),
            PlutoMenuItem(
              title: "Gammes",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Gammes";
                setState(() {
                  wAff = NF074_Gammes_screen();
                });
              },
            ),
            PlutoMenuItem(
              title: "Historique Norme",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Historique Norme";
                setState(() {
                  wAff = NF074_Histo_Normes_screen();
                });
              },
            ),
            PlutoMenuItem(
              title: "Produits Actions",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Produits Actions";
                setState(() {
                  wAff = NF074_Pieces_Actions_screen();
                });
              },
            ),
            PlutoMenuItem(
              title: "Pièces détachées",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Pièces détachées";
                setState(() {
                  wAff = NF074_Pieces_Det_screen();
                });
              },
            ),
            PlutoMenuItem(
              title: "Pièces dét. Inconnus",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Pièces détachées Inconnus";
                setState(() {
                  wAff = NF074_Pieces_Det_Inc_screen();
                });
              },
            ),
            PlutoMenuItem(
              title: "Mixte Produit",
              icon: Icons.logo_dev,
              onTap: () {
                wTitre = "Mixte Produit";
                setState(() {
                  wAff = NF074_Mixte_Produit_screen();
                });
              },
            ),
          ]),
        ],
      ),
    ];
  }
}
