import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:intl/intl.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Param.dart';
import 'package:verifplus_backoff/Tools/Srv_Param_Saisie_Param.dart';
import 'package:verifplus_backoff/widgets/Articles/Articles.dart';
import 'package:verifplus_backoff/widgets/Clients/Clients.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Fam_Dialog.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Hab.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Param_Dialog.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Saisie_Dialog.dart';
import 'package:verifplus_backoff/widgets/User/Niv_Desc.dart';
import 'package:verifplus_backoff/widgets/User/Niv_Hab.dart';
import 'package:verifplus_backoff/widgets/User/User_Liste.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Gamme_Dialog.dart';
import 'package:verifplus_backoff/widgets/Param/Param_Param_Abrev_Dialog.dart';

class gColors {
  static late ThemeData wTheme;

  static Color backgroundColor = const Color.fromRGBO(0, 116, 227, 1);

  static double MediaQuerysizewidth = 0;

  static const Color primary = Color(0xFF1c3561);
  static const Color secondary = Color(0xFFe3ebfa);

  static const Color primaryGreen = Color(0xFF2e942b);
  static const Color secondarytxt = Color(0xFFa9b5da);

  static const Color secondaryF = Color(0xFF0c5302);
  static const Color secondaryF2 = Color(0xFF0a4702);
  static const Color LinearGradient1 = primary; //Color(0xFFaaaaaa);
  static const Color LinearGradient2 = Color(0xFFf6f6f6);
  static const Color LinearGradient3 = Color(0xFFe6e6e6);
  static const Color LinearGradient4 = Color(0xFFf6f6f6);
  static const Color TextColor1 = Color(0xFF222222);
  static const Color TextColor2 = Color(0xFF555555);
  static const Color TextColor3 = Color(0xFFFFFFFF);
  static const Color white = Colors.white;
  static const Color grey = Colors.black;
  static const Color greyLight = Color(0xFFf1f1f1);
  static const Color transparent = Colors.transparent;
  static const Color trspWhite = Color(0xFFEEEEEE);

  static const Color tks = Color(0xFFEE4444);

  static const double height_Line = 40.0;

  static const Color GrdBtn_Colors1 = Color(0xFFfdbdfe);
  static const Color GrdBtn_Colors1Sel = Color(0xFF857afd);
  static const Color GrdBtn_Colors2 = Color(0xFFc3ffc1);
  static const Color GrdBtn_Colors3 = Color(0xFFe0e0e0);
  static const Color GrdBtn_Colors3sel = Color(0xFF888888);

  static const Color GrdBtn_Colors4 = Color(0xFFfce1c1);
  static const Color GrdBtn_Colors4sel = Color(0xFFfbc182);

  static Random random = new Random();
  static int ImageRandom = random.nextInt(10444) + 1;

  static List<PlutoMenuItem> HoverMenus = [];

  static InputDecoration wRechInputDecoration = InputDecoration(
    filled: true,
    fillColor: gColors.LinearGradient4,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: gColors.LinearGradient4,
        width: 2.0,
      ),
    ),
    hintText: 'Recherche',
    isDense: true,
    contentPadding: EdgeInsets.fromLTRB(8, 12, 0, 12),
  );

  static InputDecoration wRechInputDecorationSelPlanning = InputDecoration(
    filled: true,
    fillColor: gColors.LinearGradient4,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(1.0),
      borderSide: BorderSide(
        color: gColors.primary,
        width: 0.5,
      ),
    ),
    hintText: 'Recherche',
    isDense: true,
    contentPadding: EdgeInsets.fromLTRB(8, 12, 0, 12),
  );

  static Widget wPlutoMenuBar = PlutoMenuBar(
    mode: PlutoMenuBarMode.tap,
    backgroundColor: gColors.primary,
    activatedColor: Colors.white,
    indicatorColor: Colors.deepOrange,
    textStyle: gColors.bodyTitle1_N_Wr,
    menuIconColor: Colors.white,
    moreIconColor: Colors.white,
    menus: gColors.HoverMenus,
  );

  static List<PlutoMenuItem> makeMenus(BuildContext context) {
    return [
      PlutoMenuItem(
        title: 'Clients',
        icon: Icons.apps_outlined,
        children: [
          PlutoMenuItem(
            title: 'Clients',
            icon: Icons.people,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Clients_screen()));
            },
          ),
          PlutoMenuItem(
            title: 'Familles Clients',
            icon: Icons.people,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Fam_screen(wType: "FamClient", wSsFam: false, wTitle: "Familles Client")));
            },
          ),
          PlutoMenuItem(
            title: "Types d'adresses",
            icon: Icons.people,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Fam_screen(wType: "TypeAdr", wSsFam: false, wTitle: "Types d'adresses")));
            },
          ),
        ],
      ),
      PlutoMenuItem(
        title: 'Articles',
        icon: Icons.apps_outlined,
        children: [
          PlutoMenuItem(
            title: 'Articles',
            icon: Icons.people,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Articles_screen()));
            },
          ),
          PlutoMenuItem(
            title: 'Familles / Sous Familles',
            icon: Icons.people,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Fam_screen(wType: "Fam", wSsFam: true, wTitle: "Familles d'article")));
            },
          ),
        ],
      ),
      PlutoMenuItem(title: 'Utilisateurs', icon: Icons.apps_outlined, children: [
        PlutoMenuItem(
          title: 'Utilisateurs',
          icon: Icons.people,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => User_Liste()));
          },
        ),
        PlutoMenuItem(
          title: 'Habilitations / Niveau',
          icon: Icons.badge,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Niv_Hab()));
          },
        ),
        PlutoMenuItem(
          title: 'Hab. Desc. / Niveau',
          icon: Icons.badge,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Niv_Desc()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_Abrev_screen(wType: "GrpHab", wTitle: "Groupes Habilitations")));
              },
            ),
            PlutoMenuItem(
              title: "Niveaux Habilitations",
              icon: Icons.list,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_Abrev_screen(wType: "NivHab", wTitle: "Niveaux Habilitations")));
              },
            ),
            PlutoMenuItem(
              title: "Type Utilisateur",
              icon: Icons.list,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_Abrev_screen(wType: "TypeUser", wTitle: "Type Utilisateurs")));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Param_Div", wTitle: "Paramètres divers")));
                },
              ),
              PlutoMenuItem(
                title: "Types d'organe",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Type_Organe", wTitle: "Types d'organe")));
                },
              ),
              PlutoMenuItem(
                title: "Types de saisie",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Type_Saisie", wTitle: "Types de saisie")));
                },
              ),
              PlutoMenuItem(
                title: "Contrôles de saisie",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Ctrl_Saisie", wTitle: "Contrôles de saisie")));
                },
              ),
              PlutoMenuItem(
                title: "Mode Affichage Liste",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Aff_Liste", wTitle: "Mode Affichage Liste")));
                },
              ),
              PlutoMenuItem(
                title: "Couleurs",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_screen(wType: "Color", wTitle: "Couleurs")));
                },
              ),
              PlutoMenuItem(
                title: "Abréviations",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Param_Abrev_screen(wType: "Abrev", wTitle: "Abréviations")));
                },
              ),
            ],
          ),
          PlutoMenuItem(
            title: 'Paramètres de saisie',
            icon: Icons.list_alt,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Saisie_screen(wTitle: "Eléments de saisie")));
            },
          ),
          PlutoMenuItem(
            title: 'Gammes',
            icon: Icons.list_alt,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Gamme_screen(wType: "Aff_Liste", wTitle: "Gammes")));
            },
          ),
          PlutoMenuItem(
            title: "Habilitations",
            icon: Icons.list,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Param_Hab_screen()));
            },
          ),
        ],
      ),
    ];
  }

  static var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: gColors.bodyTitle1_B_tks,
      overlayColor: Color(0x88000000),
      alertElevation: 20,
      alertAlignment: Alignment.center);

  static Widget wWidgetImage = Container();

  static Future<Widget> wBoxDecoration() async {
    Uint8List pic = Uint8List.fromList([0]);
    late ImageProvider wImage;

    String wUserImgPath = "${DbTools.SrvImg}User_${DbTools.gUserLogin.User_Matricule}.jpg";
    pic = await gColors.networkImageToByte(wUserImgPath);
    print("pic $wUserImgPath $pic");
    if (pic.length > 0) {
      wImage = MemoryImage(pic);
    } else {
      wImage = AssetImage('assets/images/Avatar.png');
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: wImage, fit: BoxFit.fill),
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget gCircle(Color wColor) {
    return Container(width: 20, height: 20, decoration: BoxDecoration(color: wColor, shape: BoxShape.circle));
  }

  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;
    final lowDivisor = 6;
    final highDivisor = 5;
    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }

  static double wNorm = 14;

  static TextStyle get bodyTitle1_B_P => TextStyle(
        color: secondaryF2,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_B => TextStyle(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_W => TextStyle(
        color: white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Pr => TextStyle(
        color: secondaryF2,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_N_Wr => TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );
  static TextStyle get bodyTitle20_B_Wr => TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_tks => TextStyle(
        color: tks,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get bodyTitle1_B_Green => TextStyle(
        color: Colors.green,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_S => TextStyle(
        color: secondary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Sr => TextStyle(
        color: secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_G => TextStyle(
        color: grey,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Wr => TextStyle(
        color: white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_B_Gr => TextStyle(
        color: grey,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyTitle1_N_Gr => TextStyle(
        color: grey,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_B => TextStyle(
        color: TextColor1,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get bodySaisie_B_tks => TextStyle(
        color: tks,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_B_G => TextStyle(
        color: grey,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_N_G => TextStyle(
        color: grey,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_N_W => TextStyle(
        color: white,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_W => TextStyle(
        color: white,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_N_S => TextStyle(
        color: secondary,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySaisie_B_S => TextStyle(
        color: secondary,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySaisie_N_B => TextStyle(
        color: Colors.black,
        fontSize: wNorm,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyText_B_G => TextStyle(
        color: grey,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_B_B => TextStyle(
        color: primary,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_S_B => TextStyle(
        color: secondary,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_S_O => TextStyle(
        color: Colors.deepOrangeAccent,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyText_B_R => TextStyle(
        color: tks,
        fontSize: wNorm,
        fontWeight: FontWeight.bold,
      );

  static Widget wLabel(var aIcon, String aLabel, String aData) {
    return Row(
      children: [
        aIcon == null
            ? Container()
            : Icon(
                aIcon,
                color: Colors.grey,
              ),
        SizedBox(
          width: 2,
        ),
        Container(
          child: Text(
            aLabel,
            style: bodySaisie_N_G,
          ),
        ),
        Expanded(
          child: Text(
            aData,
            textAlign: TextAlign.right,
            style: bodyText_B_B,
          ),
        ),
      ],
    );
  }

  static Widget wLabelTitle(var aIcon, String aLabel, String aData) {
    return Row(
      children: [
        aIcon == null
            ? Container()
            : Icon(
                aIcon,
                color: Colors.grey,
              ),
        SizedBox(
          width: 2,
        ),
        Container(
          child: Text(
            aLabel,
            style: bodyText_B_B,
          ),
        ),
        Expanded(
          child: Text(
            aData,
            textAlign: TextAlign.right,
            style: bodyText_B_B,
          ),
        ),
      ],
    );
  }

  static Widget wLabel2(var aIcon, String aLabel, String aData) {
    return Row(
      children: [
        aIcon == null
            ? Container()
            : Icon(
                aIcon,
                color: Colors.grey,
              ),
        SizedBox(
          width: 2,
        ),
        Container(
          child: Text(
            aLabel,
            style: bodyTitle1_B_Pr,
          ),
        ),
      ],
    );
  }

  static Widget wNumber(String aLabel, String aData) {
    return Row(
      children: [
        SizedBox(
          width: 50,
        ),
        Icon(
          Icons.local_offer,
          color: Colors.grey,
        ),
        SizedBox(
          width: 2,
        ),
        Container(
          width: 60,
          child: Text(
            aLabel,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Expanded(
          child: Text(
            aData,
            textAlign: TextAlign.right,
            style: gColors.bodyText_B_B,
          ),
        ),
      ],
    );
  }

  static Widget wDoubleLigne() {
    return Column(
      children: [
        SizedBox(height: 8.0),
        Container(
          height: 1,
          color: gColors.primary,
        ),
        Container(
          height: 2,
        ),
        Container(
          height: 1,
          color: gColors.primary,
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  static Widget wSimpleLigne() {
    return Column(
      children: [
        SizedBox(height: 16.0),
        Container(
          height: 1,
          color: gColors.LinearGradient2,
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  static Widget wLigne() {
    return Column(
      children: [
        Container(
          height: 1,
          color: gColors.TextColor2,
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  static Widget wSimpleLigneRouge() {
    return Column(
      children: [
        Container(
          height: 1,
          color: gColors.secondary,
        ),
      ],
    );
  }

  static Widget LabelTextWidget(String txt, Color ColorTxt, double width, double padd) {
    return Container(
      width: width,
      height: 20,
      padding: EdgeInsets.fromLTRB(0, padd, 8, 0),
      child: Text(
        txt,
        style: gColors.bodySaisie_B_W.copyWith(fontSize: 14, color: ColorTxt),
        //textAlign: TextAlign.right,
      ),
    );
  }

  static Widget LabelTextWidgetBold(String txt, Color ColorTxt, double width, double padd) {
    return Container(
      width: width,
      height: 20,
      padding: EdgeInsets.fromLTRB(0, padd, 8, 0),
      child: Text(
        txt,
        style: gColors.bodyTitle1_B_Gr.copyWith(color: ColorTxt),
        //textAlign: TextAlign.right,
      ),
    );
  }

  static Widget DataTextWidget(String txt, Color ColorTxt, double width, double padd) {
    return Container(
      width: width,
      height: 20,
      padding: EdgeInsets.fromLTRB(0, padd, 0, 0),
      child: Text(
        txt,
        style: gColors.bodySaisie_N_W.copyWith(fontSize: 14, color: ColorTxt),
      ),
    );
  }

  static Widget CadreTextWidget(String txt, Color Color1, Color Color2, Color ColorTxt, double width, double p) {
    return Container(
      width: width,
      color: Color1,
      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
      child: Container(
        color: Color2,
        padding: EdgeInsets.fromLTRB(p, p, p, p),
        child: Text(
          txt,
          style: gColors.bodySaisie_N_W.copyWith(color: ColorTxt),
        ),
      ),
    );
  }

  static Widget BtnAffUser(BuildContext context) {
    String wDate = DateFormat('EEEE dd MMM yyyy', 'fr').format(DateTime.now());
    wDate = wDate.replaceRange(
      0,
      1,
      wDate.substring(0, 1).toUpperCase(),
    );
    return InkWell(
      child: Row(
        children: [
          Text(
            "${wDate}",
            style: gColors.bodySaisie_N_W,
          ),
          Container(margin: EdgeInsets.fromLTRB(10, 0, 10, 0), height: 40, width: 40, child: DbTools.wBoxDecoration(context)),
        ],
      ),
      onTap: () {
        AffUser(context);
      },
    );
  }

  static AffUser(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                DbTools.wBoxDecoration(context),
                SizedBox(height: 8.0),
                Container(color: Colors.grey, height: 1.0),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Utilisateur",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ]),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('N° matricule : '),
                        Spacer(),
                        Text(DbTools.gUserLogin.User_Matricule),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Prénom : '),
                        Spacer(),
                        Text(DbTools.gUserLogin.User_Prenom),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Nom : '),
                        Spacer(),
                        Text(DbTools.gUserLogin.User_Nom),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Type : '),
                        Spacer(),
                        Text(DbTools.gUserLoginTypeUser),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Text(DbTools.gVersion,
                    style: TextStyle(
                      fontSize: 12,
                    )),
                Container(
                  width: 90,
                ),
                ElevatedButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  static AffUser_Mat(BuildContext context) async {
    Uint8List pic = Uint8List.fromList([0]);

    String wUserImg = "User_${DbTools.gUser.User_Matricule}.jpg";

    pic = await gColors.getImage(wUserImg);
    late ImageProvider wImage;
    if (pic.length > 0) {
      wImage = MemoryImage(pic);
    }

    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(image: wImage, fit: BoxFit.fill),
                    color: Colors.white,
//        shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(color: Colors.grey, height: 1.0),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Collaborateur",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ]),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('N° matricule : '),
                        Spacer(),
                        Text(DbTools.gUser.User_Matricule),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Prénom : '),
                        Spacer(),
                        Text(DbTools.gUser.User_Prenom),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Nom : '),
                        Spacer(),
                        Text(DbTools.gUser.User_Nom),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Type : '),
                        Spacer(),
                        Text(DbTools.gUser.User_TypeUser),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Text(DbTools.gVersion,
                    style: TextStyle(
                      fontSize: 12,
                    )),
                Container(
                  width: 90,
                ),
                ElevatedButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static Future<bool> fileExist(String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(DbTools.SrvUrl.toString()));
      request.fields.addAll({'zasq': 'fileExist', 'file': '$url'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Uint8List r = await response.stream.toBytes();

        return r.length > 0;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Uint8List> getImage(String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(DbTools.SrvUrl.toString()));
      request.fields.addAll({'zasq': 'getImage', 'img': '$url'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        return new Uint8List(0);
      }
    } catch (e) {
      return new Uint8List(0);
    }
  }

  static Future<Uint8List> getDoc(String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(DbTools.SrvUrl.toString()));
      request.fields.addAll({'zasq': 'getDoc', 'doc': '$url'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        return new Uint8List(0);
      }
    } catch (e) {
      return new Uint8List(0);
    }
  }

  static Future<Uint8List> networkImageToByte(String path) async {
    print("networkImageToByte");
    try {
//      var response = await http.get(Uri.parse(path.toString()));

      String wParam = "${path.toString()}";
      print("networkImageToByte A $wParam");

      var uri2 = Uri.parse(wParam);

      http.Response response = await http.get(uri2, headers: {"Access-Control-Allow-Origin": "*", 'Content-Type': 'application/json', 'Accept': '*/*'});

      print("networkImageToByte B");
      if (response.statusCode == 200) {
        print("networkImageToByte 200");
        return response.bodyBytes;
      } else {
        print("networkImageToByte Error");
        return new Uint8List(0);
      }
    } catch (e) {
      print("networkImageToByte Error $e");

      return new Uint8List(0);
    }
  }

  static Widget TxtField(double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {int Ligne = 1, String sep = " : "}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth == -1
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_N_G,
                ),
              )
            : Container(
                width: lWidth,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_N_G,
                ),
              ),
        Container(
          width: 12,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            sep,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Container(
            width: wWidth * 6,
            child: TextFormField(
              minLines: Ligne,
              maxLines: Ligne,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              controller: textEditingController,
              style: gColors.bodySaisie_B_B,
            )),
        Container(
          width: 20,
        ),
      ],
    );
  }

  static Widget TxtFieldCalc(double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {int Ligne = 1, String sep = " : "}) {
    double calcWidth = wWidth - lWidth - 26;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth < 0
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
                ),
              )
            : Container(
                width: lWidth,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
                ),
              ),
        Container(
          width: 12,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            sep,
            style: gColors.bodySaisie_B_G,
          ),
        ),
        Container(
            width: calcWidth,
            child: TextFormField(
              minLines: Ligne,
              maxLines: Ligne,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              controller: textEditingController,
              style: gColors.bodySaisie_B_B,
            )),
      ],
    );
  }

  static Widget TxtFieldMax(double lWidth, double wWidth, String wLabel, TextEditingController textEditingController, {int Ligne = 1, String sep = " : "}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lWidth == -1
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
                ),
              )
            : Container(
                width: lWidth,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  wLabel,
                  style: gColors.bodySaisie_B_G,
                ),
              ),
        Container(
          width: 12,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(
            sep,
            style: gColors.bodySaisie_B_G,
          ),
        ),
        Expanded(
            child: Container(
                width: wWidth * 6,
                child: TextFormField(
                  minLines: Ligne,
                  maxLines: Ligne,
                  decoration: InputDecoration(
                    isDense: true,
                  ),
                  controller: textEditingController,
                  style: gColors.bodySaisie_B_B,
                ))),
        Container(
          width: 20,
        ),
      ],
    )
        //)
        ;
  }

  static Widget TxtNum(double lWidth, String wLabel, int wValue) {
    var formatter = NumberFormat('#,##,###.00');
    return Row(
      children: [
        Container(
          //  width: lWidth,
          child: Text(
            wLabel,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Text(
          " : ",
          style: gColors.bodySaisie_B_B,
        ),
        Text(
          "  ${formatter.format(wValue).replaceAll(',', ' ')}€",
          style: wValue >= 0 ? gColors.bodySaisie_B_B : gColors.bodySaisie_B_tks,
        ),
        Container(
          width: 20,
        ),
      ],
    );
  }

  static Widget Txt(double lWidth, String wLabel, String wValue, {double tWidth = -1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: lWidth,
          child: Text(
            wLabel,
            style: gColors.bodySaisie_N_G,
          ),
        ),
        Text(
          ":",
          style: gColors.bodySaisie_N_B,
        ),
        Container(
          width: tWidth > 0 ? tWidth : null,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(
            "$wValue",
            style: gColors.bodySaisie_B_B,
            overflow: tWidth > 0 ? TextOverflow.ellipsis : TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  static Widget Txt2(double lWidth, String wLabel, String wValue, {double tWidth = -1}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: lWidth,
          child: Text(
            wLabel,
            style: gColors.bodyTitle1_B_Gr,
          ),
        ),
        Text(
          " : ",
          style: gColors.bodyTitle1_B_Gr,
        ),
        Container(
          width: tWidth > 0 ? tWidth : null,
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(
            "$wValue",
            style: gColors.bodyTitle1_N_Gr,
            overflow: tWidth > 0 ? TextOverflow.ellipsis : TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  static Widget TxtColumn(double lWidth, String wLabel, String wValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: lWidth,
              child: Text(
                wLabel,
                style: gColors.bodySaisie_N_G,
              ),
            ),
            Text(
              " : ",
              style: gColors.bodySaisie_N_B,
            ),
          ],
        ),
        Text(
          "$wValue",
          style: gColors.bodySaisie_B_B,
        ),
      ],
    );
  }

  static Widget CheckBoxField(double lWidth, double wWidth, String wLabel, bool initValue, Function(bool? boolValue) onChanged) {
    return Container(
      child: Row(
        children: [
          Container(
            width: lWidth,
            child: Text(
              wLabel,
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Text(
            ":  ",
            style: gColors.bodySaisie_B_B,
          ),
          Container(
            width: 16,
            child: Checkbox(
              checkColor: Colors.white,
              value: initValue,
              onChanged: (b) => onChanged(b),
            ),
          )
        ],
      ),
    );
  }

  static Widget CheckBoxFieldReadOnly(double lWidth, double wWidth, String wLabel, bool initValue) {
    return Container(
      child: Row(
        children: [
          Container(
            width: lWidth,
            child: Text(
              wLabel,
              style: gColors.bodySaisie_N_G,
            ),
          ),
          Text(
            ":  ",
            style: gColors.bodySaisie_B_B,
          ),
          Container(
            width: 16,
            child: Checkbox(
              checkColor: Colors.white,
              value: initValue,
              onChanged: (b) => null,
            ),
          )
        ],
      ),
    );
  }

  static Widget DropdownButtonFam(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<String> wlistparamParamfam, List<String> wlistparamParamfamid) {
    if (wlistparamParamfam.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wlistparamParamfam
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                "$item",
                style: gColors.bodySaisie_B_B,
              ),
            ))
        .toList();

    print("DropdownButtonFam initValue $initValue");
    String wID = wlistparamParamfamid[wlistparamParamfam.indexOf(initValue)];
    print("DropdownButtonFam wID $wID");

    return Row(children: [
      Container(
//        width: lWidth,
        child: Text(
          wLabel,
          style: gColors.bodySaisie_N_G,
        ),
      ),
      wWidth == 0
          ? Container()
          : Container(
              width: wWidth,
              child: Text(
                " : ",
                style: gColors.bodySaisie_B_G,
              ),
            ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          items: dropdownlist,
          value: initValue,
          onChanged: (value) {
            initValue = value as String;
            onChanged(initValue);
          },
          buttonStyleData: const ButtonStyleData(
            padding: const EdgeInsets.only(left: 5, right: 5),
            height: 30,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 800,
          ),
        )),
      ),
    ]);
  }

  static Widget DropdownButtonType(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<Param_Saisie_Param> wlistparamSaisieParam) {
    print("DropdownButtonType > wListParam_Saisie_Param.length ${wlistparamSaisieParam.length} ($initValue)");

    if (initValue == 0) return Container();
    if (wlistparamSaisieParam.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wlistparamSaisieParam
        .map((item) => DropdownMenuItem<String>(
              value: item.Param_Saisie_Param_Label,
              child: Text(
                "${item.Param_Saisie_Param_Label}",
                style: gColors.bodySaisie_B_B,
              ),
            ))
        .toList();

    return Row(children: [
      Container(
//        width: lWidth,
        child: Text(
          wLabel,
          style: gColors.bodySaisie_N_G,
        ),
      ),
      wWidth == 0
          ? Container()
          : Container(
              width: wWidth,
              child: Text(
                " : ",
                style: gColors.bodySaisie_B_G,
              ),
            ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          items: dropdownlist,
          value: initValue,
          onChanged: (value) {
            initValue = value as String;
            onChanged(initValue);
          },
          buttonStyleData: const ButtonStyleData(
            padding: const EdgeInsets.only(left: 5, right: 5),
            height: 30,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 800,
          ),
        )),
      ),
    ]);
  }

  static Widget DropdownButtonTypeInter(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<String> wlistTypeinter, List<String> wlistTypeinterid) {
    print("ListeOrg wlistTypeinter ${wlistTypeinter.length} ${wlistTypeinterid.length}");

    if (wlistTypeinter.length == 0) return Container();
    List<DropdownMenuItem> dropdownlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                "$item",
                style: gColors.bodySaisie_B_B,
              ),
            ))
        .toList();

    print("ListeOrg wlistTypeinter.indexOf(initValue) ${initValue} ${wlistTypeinter.indexOf(initValue)}");

    if (wlistTypeinter.indexOf(initValue) < 0) return Container();

    String wID = wlistTypeinterid[wlistTypeinter.indexOf(initValue)];

    return Row(children: [
      Container(
        width: lWidth,
        child: Text(
          wLabel,
          style: gColors.bodySaisie_N_G,
        ),
      ),
      wWidth == 0
          ? Container()
          : Container(
              width: wWidth,
              child: Text(
                " : ",
                style: gColors.bodySaisie_N_G,
              ),
            ),
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          items: dropdownlist,
          value: initValue,
          onChanged: (value) {
            String wID = wlistTypeinterid[wlistTypeinter.indexOf(value!)];
            initValue = value as String;
            onChanged(initValue);
          },
          buttonStyleData: const ButtonStyleData(
            height: 30,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 800,
          ),
        )),
      ),
    ]);
  }

  static Widget DropdownButtonTypeInterC(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<String> wlistTypeinter, List<String> wlistTypeinterid) {
    if (wlistTypeinter.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                "$item",
                style: gColors.bodySaisie_B_B,
              ),
            ))
        .toList();

    if (wlistTypeinter.indexOf(initValue) < 0) {
      print("DropdownButtonTypeInterC initValue Not in");

      return Container();
    }

    String wID = wlistTypeinterid[wlistTypeinter.indexOf(initValue)];

    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
        width: lWidth,
        child: Text(
          wLabel,
          style: gColors.bodySaisie_N_G,
        ),
      ),
      wWidth == 0
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
              width: wWidth,
              child: Text(
                ":",
                style: gColors.bodySaisie_N_G,
              ),
            ),
      Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            items: dropdownlist,
            value: initValue,
            onChanged: (value) {
              String wID = wlistTypeinterid[wlistTypeinter.indexOf(value!)];
              initValue = value as String;
              onChanged(initValue);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 30,
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 32,
            ),
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              maxHeight: 800,
            ),
          ),
        ),
      ),
    ]);
  }

  static Widget DropdownButtonTypeInterC2(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<String> wlistTypeinter, List<String> wlistTypeinterid) {
    print(" $wLabel |$initValue| ${initValue.isEmpty}");

    if (wlistTypeinter.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
            value: item,
            child: item == initValue
                ? Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Container(
                        width: 220,
                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: gColors.primary, width: 1),
                          borderRadius: BorderRadius.circular(16),
                          shape: BoxShape.rectangle,
                          color: gColors.primary,
                        ),
                        child: Text(
                          "$item",
                          style: gColors.bodySaisie_B_W,
                        )),
                  )
                : Container(
                    width: 220,
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      "$item",
                      style: gColors.bodySaisie_N_B,
                    ),
                  )))
        .toList();

    List<DropdownMenuItem> selectedlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: initValue.trim().isEmpty
                  ? Container(width: 220)
                  : Container(
                      width: 220,
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: gColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(16),
                        shape: BoxShape.rectangle,
                        color: gColors.primary,
                      ),
                      child: Text(
                        "$item",
                        style: gColors.bodySaisie_N_W,
                      ),
                    ),
            ))
        .toList();

    if (wlistTypeinter.indexOf(initValue) < 0) {
      print("DropdownButtonTypeInterC2 initValue Not in");
      return Container();
    }

    String wID = wlistTypeinterid[wlistTypeinter.indexOf(initValue)];
    print("  wID ${wID}");

    double wPad = 15;
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, wPad, 0, wPad),
        width: lWidth,
        child: Text(
          wLabel,
          style: gColors.bodySaisie_N_G,
        ),
      ),
      wWidth == 0
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(0, wPad, 0, wPad),
              width: wWidth,
              child: Text(
                ":",
                style: gColors.bodySaisie_N_G,
              ),
            ),
      Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            items: dropdownlist,
            value: initValue,
            selectedItemBuilder: (BuildContext context) {
              print("  selectedItemBuilder ");
              return selectedlist;
            },
            onMenuStateChange: (value) {
              print("  onMenuStateChange ${value}");
            },
            onChanged: (value) {
              String wID = wlistTypeinterid[wlistTypeinter.indexOf(value!)];
              initValue = value as String;
              onChanged(initValue);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 30,
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 32,
            ),
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              maxHeight: 800,
            ),
          ),
        ),
      ),
    ]);
  }

  static Widget DropdownButtonMission(String initValue, Function(String? Value) onChanged, List<String> wlistTypeinter, List<String> wlistTypeinterid) {
    if (wlistTypeinter.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                "$item",
                style: gColors.bodySaisie_B_B,
              ),
            ))
        .toList();

    List<DropdownMenuItem> selectedlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Container(
                width: 220,
                child: Text(
                  "$item",
                  style: gColors.bodySaisie_B_B,
                ),
              ),
            ))
        .toList();

    if (wlistTypeinter.indexOf(initValue) < 0) return Container();

    String wID = wlistTypeinterid[wlistTypeinter.indexOf(initValue)];

    return Row(children: [
      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          items: dropdownlist,
          value: initValue,
          selectedItemBuilder: (BuildContext context) {
            return selectedlist;
          },
          onChanged: (value) {
            String wID = wlistTypeinterid[wlistTypeinter.indexOf(value!)];
            initValue = value as String;
            onChanged(initValue);
          },
          buttonStyleData: const ButtonStyleData(
            height: 30,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 32,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 800,
          ),
        )),
      ),
    ]);
  }

  static String AbrevTxt(String wTxt) {
    DbTools.ListParam_Param_Abrev.forEach((element) {
      wTxt = wTxt.replaceAll(element.Param_Param_ID, element.Param_Param_Text);
    });
    return wTxt;
  }

  static String AbrevTxt_Saisie_Param(String wTxt, String wparamId) {
    if (wparamId.isNotEmpty) {
      DbTools.getParam_Saisie_ParamMem(wparamId);
      DbTools.ListParam_Saisie_Param.forEach((element) {
        if (element.Param_Saisie_Param_Label.compareTo(wTxt) == 0) {
          wTxt = element.Param_Saisie_Param_Abrev;
        }
      });
    }

    DbTools.ListParam_Param_Abrev.forEach((element) {
      wTxt = wTxt.replaceAll(element.Param_Param_ID, element.Param_Param_Text);
    });
    return wTxt;
  }

  static String capitalize(String wTxt) {
    if (wTxt.isEmpty) return wTxt;
    return "${wTxt[0].toUpperCase()}${wTxt.substring(1).toLowerCase().trim()}";
  }

  static DateTime alignDateTime(DateTime dt, Duration alignment, [bool roundUp = false]) {
    assert(alignment >= Duration.zero);
    if (alignment == Duration.zero) return dt;
    final correction = Duration(
        days: 0,
        hours: alignment.inDays > 0
            ? dt.hour
            : alignment.inHours > 0
                ? dt.hour % alignment.inHours
                : 0,
        minutes: alignment.inHours > 0
            ? dt.minute
            : alignment.inMinutes > 0
                ? dt.minute % alignment.inMinutes
                : 0,
        seconds: alignment.inMinutes > 0
            ? dt.second
            : alignment.inSeconds > 0
                ? dt.second % alignment.inSeconds
                : 0,
        milliseconds: alignment.inSeconds > 0
            ? dt.millisecond
            : alignment.inMilliseconds > 0
                ? dt.millisecond % alignment.inMilliseconds
                : 0,
        microseconds: alignment.inMilliseconds > 0 ? dt.microsecond : 0);
    if (correction == Duration.zero) return dt;
    final corrected = dt.subtract(correction);
    final result = roundUp ? corrected.add(alignment) : corrected;
    return result;
  }

  static Color getColorStatus(String Status) {
    Color wColor = Colors.transparent;
    for (int p = 0; p < DbTools.ListParam_Param_Status_Interv.length; p++) {
      Param_Param wParam_Param = DbTools.ListParam_Param_Status_Interv[p];
      if (wParam_Param.Param_Param_ID == Status) {
        wColor = gColors.getColor(wParam_Param.Param_Param_Color);
        break;
      }
    }

    return wColor;
  }

  static Color getColor(String color) {
    Color wColor = Colors.green;
    switch (color) {
      case "Vert":
        wColor = Colors.green;
        break;
      case "Orange":
        wColor = Colors.orange;
        break;
      case "Rouge":
        wColor = Colors.red;
        break;
      case "Bleu":
        wColor = Colors.blue;
        break;
      case "Violet":
        wColor = Colors.deepPurple;
        break;
      case "Jaune":
        wColor = Color(0xFFFFC000);
        break;
      case "RougeF":
        wColor = Color(0xFFC00000);
        break;
      case "Noir":
        wColor = Colors.black;
        break;
    }
    return wColor;
  }

  static Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static var filtreStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: false,
    titleStyle: gColors.bodySaisie_B_G,
    descStyle: gColors.bodySaisie_N_G,
    descTextAlign: TextAlign.left,
    alertPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    overlayColor: Color(0x88000000),
    alertElevation: 10,
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    print("oldValue ${oldValue.text}");
    print("newValue ${newValue.text}");

    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
    String value = "";
    String testAlpha = truncated.replaceAll(RegExp('[^0-9.]'), '');
    if (testAlpha.length < truncated.length) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    } else
      value = newValue.text;

    if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    }
    print("truncated $truncated");

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );

    return newValue;
  }
}

class FullScreenImage extends StatelessWidget {
  final ImageProvider? imageProvider;
  const FullScreenImage({Key? key, required this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("FullScreenImage build");

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
        child: PhotoView(
          imageProvider: imageProvider,
        ),
      ),
    );
  }
}
