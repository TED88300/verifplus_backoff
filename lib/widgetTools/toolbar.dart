import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CommonAppBar {
  static Widget getPrimaryAppbar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: gColors.primary,
      title: Text(
        title,
      ),
      leading: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showToastClicked(context, "Seach");
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  static Widget getEmptyAppbar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: gColors.primary,
      title: Text(
        title,
        style: TextStyle(color: gColors.secondary),
      ),
      automaticallyImplyLeading: false,
    );
  }

  static Widget getEmptyAppbarCountDown(BuildContext context, String title, String J) {
    return AppBar(
        backgroundColor: gColors.primary,
        title: Text(
          title,
          style: TextStyle(color: gColors.secondary),
        ),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(5, 17, 0, 0),
          child: Text(
            J,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  static Widget getEmptyAppbarSmall(BuildContext context, String title) {
    return AppBar(
      backgroundColor: gColors.primary,
      title: Text(
        title,
        style: TextStyle(fontSize: 22, color: gColors.secondary),
      ),
      automaticallyImplyLeading: false,
    );
  }

  static Widget getEmptyAppbar3L(BuildContext context, String title) {
    return AppBar(
      backgroundColor: gColors.secondary,
      title: Text(
        title,
        style: TextStyle(color: gColors.secondary),
      ),
      automaticallyImplyLeading: false,
    );
  }

  static Widget getPrimarySettingAppbar(BuildContext context, String title) {
    return AppBar(
        backgroundColor: gColors.primary,
        title: Text(
          title,
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showToastClicked(context, "Search");
            },
          ), // overflow menu
          PopupMenuButton<String>(
            onSelected: (String value) {
              showToastClicked(context, value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Settings",
                child: Text("Settings"),
              ),
            ],
          )
        ]);
  }

  static Widget getPrimaryBackAppbar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: gColors.primary,
      title: AutoSizeText(
        title,
        maxLines: 1,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  static Widget getPrimaryBackSearchAppbar(BuildContext context, String title) {
    return AppBar(
        backgroundColor: gColors.primary,
        title: Text(
          title,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showToastClicked(context, "Seach");
            },
          ),
        ]);
  }

  static Widget SquareRoundIcon(BuildContext context, double wsize, double wradius, Color bckcolor, Color color, IconData icon, VoidCallback onTapVoidCallback, {String tooltip = "", bool isEnable = true}) {
    return Tooltip(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        decoration: BoxDecoration(color: Colors.orange),
        message: tooltip,
        child: isEnable
            ? InkWell(
                child: Container(
                  width: wsize,
                  height: wsize,
                  decoration: BoxDecoration(color: bckcolor, borderRadius: BorderRadius.all(Radius.circular(wradius)), border: Border.all(color: gColors.LinearGradient1)),
                  child: Icon(
                    icon,
                    color: color,
                    size: wsize * 0.8,
                  ),
                ),
                onTap: () async {
                  print("SquareRoundIcon TAP");
                  onTapVoidCallback();
                },
              )
            : Container(
                width: wsize,
                height: wsize,
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(wradius)), border: Border.all(color: gColors.LinearGradient1)),
                child: Icon(
                  icon,
                  color: color,
                  size: wsize * 0.8,
                ),
              ));
  }

  static Widget SquareRoundPng(BuildContext context, double wsize, double wradius, Color bckcolor, Color color, String png, VoidCallback onTapVoidCallback, {String tooltip = "", bool isEnable = true}) {
    return Tooltip(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        decoration: BoxDecoration(color: Colors.orange),
        message: tooltip,
        child: InkWell(
          child:
          isEnable ?
          Container(
            width: wsize,
            height: wsize,
            child: Image.asset("assets/images/${png}.png"),
          )
          :
          Container(
              width: wsize,
              height: wsize,
              child: Image.asset("assets/images/${png}.png", fit: BoxFit.cover, color: Colors.grey),
            ),

          onTap: () async {
            print("SquareRoundIcon TAP");
            onTapVoidCallback();
          },
        ));
  }

  static Widget BtnRoundtext(BuildContext context, Color bckcolor, Color color, String aText, VoidCallback onTapVoidCallback, {String tooltip = "", bool isEnable = true}) {
    return Tooltip(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        decoration: BoxDecoration(color: Colors.orange),
        message: tooltip,
        child: isEnable
            ? InkWell(
                child: Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                  decoration: BoxDecoration(color: bckcolor, borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: gColors.LinearGradient1)),
                  child: Text(
                    aText,
                    style: gColors.bodySaisie_B_W.copyWith(color: color),
                  ),
                ),
                onTap: () async {
                  print("BtnRoundtext TAP");
                  onTapVoidCallback();
                },
              )
            : Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: gColors.LinearGradient1)),
                child: Text(
                  "$aText",
                  style: gColors.bodySaisie_B_W,
                ),
              ));
  }

  static void showToastClicked(BuildContext context, String action) {
    print(action);
//    Toast.show(action+" clicked", context);
  }
}
