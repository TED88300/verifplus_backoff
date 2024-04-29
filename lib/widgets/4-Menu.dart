import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_geocoding/google_geocoding.dart';
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
import 'package:verifplus_backoff/widgets/Interventions/Interventions.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Ctrl.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Ctrl2.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Gammes.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Histo_Normes.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Mixte_Produit.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Pieces_Actions.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Pieces_Det.dart';
import 'package:verifplus_backoff/widgets/NF074/NF074_Pieces_Det_Inc.dart';
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

  Widget wAff = Clients_screen();

  Future initLib() async {
    var googleGeocoding = GoogleGeocoding(MapTools.apiKeyMap);
    List<Component> components = [];

    var risult = await googleGeocoding.geocoding.get("10 rue du Colonel Renard 88300 Neufchateau", components);
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
        preferredSize: Size.fromHeight(60.0), // here the desired height
        child: AppBar(
          backgroundColor: gColors.primary,
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
                      if (wAff.toString().contains("Articles_Fam_Ebp")) {
                        DbTools.gArticle_Fam_Ebp = Article_Fam_Ebp.Article_Fam_EbpInit();
                        DbTools.gDemndeReload = true;
                        wAff = Articles_Fam_Ebp();

                        setState(() {});
                      }
                    },
                  ),
                  Spacer(),
                  Text(
                    "$wTitre",
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_B_W,
                  ),
                  Spacer(),
                  InkWell(
                    child: Container(margin: EdgeInsets.fromLTRB(0, 0, 10, 0), height: 40, width: 40, child: DbTools.wBoxDecoration(context)),
                    onTap: () {
                      gColors.AffUser(context);


                    },
                  ),
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
        title: 'Planning',
        icon: Icons.calendar_month,
        onTap: () {
          wTitre = "Planning";
          setState(() {
//        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Planning()));

            wAff = Planning();
          });
        },
      ),
      PlutoMenuItem(
        title: 'Interventions',
        icon: Icons.apps_outlined,
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
        icon: Icons.apps_outlined,
        children: [
          PlutoMenuItem(
            title: 'Clients',
            icon: Icons.people,
            onTap: () {
              wTitre = "Clients";
              setState(() {
                wAff = Clients_screen();
              });
            },
          ),
          PlutoMenuItem(
            title: 'Familles Clients',
            icon: Icons.people,
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
            icon: Icons.people,
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
            icon: Icons.people,
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
            icon: Icons.people,
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
            icon: Icons.people,
            onTap: () {
              wTitre = "Agences";
              setState(() {
                DbTools.gDemndeReload = true;
                wAff = Agences();
              });
            },
          ),
        ],
      ),
      PlutoMenuItem(
        title: 'Articles',
        icon: Icons.apps_outlined,
        children: [
          PlutoMenuItem(
            title: 'Articles EBP',
            icon: Icons.people,
            onTap: () {
              wTitre = "Articles EBP";
              setState(() {
                wAff = Article_Ebp_Liste();
              });
            },
          ),
          PlutoMenuItem(
            title: 'Familles / Sous Familles EBP',
            icon: Icons.people,
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
      PlutoMenuItem(title: 'Utilisateurs', icon: Icons.apps_outlined, children: [
        PlutoMenuItem(
          title: 'Utilisateurs',
          icon: Icons.people,
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
              icon: Icons.list,
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
              icon: Icons.list,
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
              icon: Icons.list,
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
        icon: Icons.apps_outlined,
        children: [
          PlutoMenuItem(
            title: 'Elements de base',
            children: [
              PlutoMenuItem(
                title: "Paramètres divers",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Paramètres divers";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Param_Div", wTitle: "Paramètres divers");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Types d'organe",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Types d'organe";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Organe", wTitle: "Types d'organe");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Types de saisie",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Types de saisie";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Saisie", wTitle: "Types de saisie");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Types d'intervention",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Types d'intervention";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Interv", wTitle: "Types d'intervention");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Missions",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Missions";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Missions", wTitle: "Missions");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Status des interventions",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Status des interventions";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Status_Interv", wTitle: "Status des interventions");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Type de Facturation",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Type de Facturation";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Type_Fact", wTitle: "Type de Facturation");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Contrôles de saisie",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Contrôles de saisie";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Ctrl_Saisie", wTitle: "Contrôles de saisie");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Mode Affichage Liste",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Mode Affichage Liste";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Aff_Liste", wTitle: "Mode Affichage Liste");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Couleurs",
                icon: Icons.list,
                onTap: () {
                  wTitre = "Couleurs";
                  setState(() {
                    DbTools.gDemndeReload = true;
                    wAff = Param_Param_screen(wType: "Color", wTitle: "Couleurs");
                  });
                },
              ),
              PlutoMenuItem(
                title: "Abréviations",
                icon: Icons.list,
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
            title: 'Paramètres de saisie',
            icon: Icons.list_alt,
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
            icon: Icons.list_alt,
            onTap: () {
              wTitre = "Gammes";
              setState(() {
                wAff = Param_Gamme_screen(wType: "Aff_Liste", wTitle: "Gammes");
              });
            },
          ),
          PlutoMenuItem(
            title: "Habilitations",
            icon: Icons.list,
            onTap: () {
              wTitre = "Habilitations";
              setState(() {
                wAff = Param_Hab_screen();
              });
            },
          ),
        ],
      ),
      PlutoMenuItem(title: 'NF074', icon: Icons.apps, children: [
        PlutoMenuItem(
          title: "Contrôles Articles",
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Contrôles Base de données NF074 : ARTICLES";
            setState(() {
              wAff = NF074_Ctrl_screen();
            });
          },
        ),
        PlutoMenuItem(
          title: "Contrôles Gammes",
          icon: Icons.app_registration,
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
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Gammes";
            setState(() {
              wAff = NF074_Gammes_screen();
            });
          },
        ),
        PlutoMenuItem(
          title: "Historique Norme",
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Historique Norme";
            setState(() {
              wAff = NF074_Histo_Normes_screen();
            });
          },
        ),
        PlutoMenuItem(
          title: "Produits Actions",
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Produits Actions";
            setState(() {
              wAff = NF074_Pieces_Actions_screen();
            });
          },
        ),
        PlutoMenuItem(
          title: "Pièces détachées",
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Pièces détachées";
            setState(() {
              wAff = NF074_Pieces_Det_screen();
            });
          },
        ),
        PlutoMenuItem(
          title: "Pièces dét. Inconnus",
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Pièces détachées Inconnus";
            setState(() {
              wAff = NF074_Pieces_Det_Inc_screen();
            });
          },
        ),
        PlutoMenuItem(
          title: "Mixte Produit",
          icon: Icons.app_registration,
          onTap: () {
            wTitre = "Mixte Produit";
            setState(() {
              wAff = NF074_Mixte_Produit_screen();
            });
          },
        ),
      ]),
    ];
  }
}
