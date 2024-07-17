import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';

class PhotosView extends StatefulWidget {

  final ImageProvider? imageProvider;

  const PhotosView({Key? key, required this.imageProvider}) : super(key: key);

  @override
  _PhotosViewState createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> {

  void initLib() async {}

  @override
  void initState() {

    super.initState();
  }

  double width = 0;
  bool isZoom = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 56;
    return Scaffold(
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
                Container(
                  width: 200,
                ),
                Spacer(),
                Text(
                  "Photo",
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
      backgroundColor: gColors.white,
      body:Container(
      width: width,
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
    color: gColors.LinearGradient2,
    child:

    PhotoView(
        imageProvider: widget.imageProvider,
      backgroundDecoration: BoxDecoration(color: gColors.LinearGradient2,),
      initialScale: PhotoViewComputedScale.contained * 0.8,
      ),)
    );
  }
}
