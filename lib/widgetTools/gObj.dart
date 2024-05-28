import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';


class Certif {
  Certif(this.ON, this.Type, this.Delivrance, this.Reserve, this.Url);
  final String ON;
  final String Type;
  final String Delivrance;
  final String Reserve;
  final String Url;
}

class gObj {
  gObj();

  static double LargeurScreen = 0;

  static double LargeurLabel = 150;

  static Uint8List pic = Uint8List.fromList([0]);
  static Uint8List picUser = Uint8List.fromList([0]);
  static late Image wImage;

  static String gTitre = "";
  static String gTitre2 = "";
  static String gTitre3 = "";
  static String gTitre4 = "";

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String printDurationHHMM(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }


  static Future<Uint8List> networkImageToByte(String path) async {
    try {
      var response = await http.get(Uri.parse(path.toString()));
      if (response.statusCode == 200) {
//        print("networkImageToByte 200");
        return response.bodyBytes;
      } else {
//        print("networkImageToByte Error");
        return new Uint8List(0);
      }
    } catch (e) {
      return new Uint8List(0);
    }
  }



  static Widget SquareRoundIcon(BuildContext context, double wsize, double wradius, Color bckcolor, Color color, IconData icon, VoidCallback onTapVoidCallback) {
    return InkWell(
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
    );
  }


  static Future<Image> GetImage(String aArticle_codeArticle , double IcoWidth) async {
    String wImgPath = "${DbTools.SrvImg}ArticlesImg_Ebp_${aArticle_codeArticle}.jpg";

//    print("wImgPath ${wImgPath}");


    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.length > 0) {

      print("gObj.pic.length ${gObj.pic.length}");


      gObj.wImage = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: IcoWidth,
        height: IcoWidth,
      );
      return gObj.wImage!;
    }

    return Image.asset(
      "assets/images/Audit_det.png",
      height: IcoWidth,
      width: IcoWidth,
    );
  }

  static Widget buildImage( String aArticle_codeArticle,double IcoWidth ) {
    return new FutureBuilder(
      future: GetImage(aArticle_codeArticle,  IcoWidth ),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
        }
      },
    );
  }



}