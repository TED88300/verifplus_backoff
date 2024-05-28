import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Client_Map_Dialog {
  Client_Map_Dialog();

  static Future<void> Client_Map_dialog(BuildContext context, String aNom, String aAdresse, String aAdr1, String aCp, String aVille) async {
    await showDialog(

      context: context,
      builder: (BuildContext context) => new Client_Map(
        aAdresse: aAdresse,
        aNom: aNom,
        aAdr1: aAdr1,
        aCp: aCp,
        aVille: aVille,
      ),
    );
  }
}

class Client_Map extends StatefulWidget {
  final String aAdresse;
  final String aNom;

  final String aAdr1;
  final String aCp;
  final String aVille;
  const Client_Map({Key? key, required this.aNom, required this.aAdresse, required this.aAdr1, required this.aCp, required this.aVille})
      : super(
          key: key,
        );
  @override
  State<Client_Map> createState() => _Client_MapState();
}

class _Client_MapState extends State<Client_Map> {
  late BitmapDescriptor dbSiege;

  LatLng _center = LatLng(0, 0);
  Map<MarkerId, Marker> _markers = {};
  late GoogleMapController googleMapController;

  MapTools_Geocoding wMapTools_Geocoding = MapTools_Geocoding(LatLng(0, 0), "");

  String wTitle = "";
  String wAdresse = "";
  LatLng wlatLng = LatLng(0, 0);
  ScreenCoordinate wScreenCoordinate = ScreenCoordinate(
    x: 0,
    y: 0,
  );
  bool wAffInfoWindows = false;


  LatLngBounds wLatLngBounds = LatLngBounds(
    southwest: LatLng(0, 0),
    northeast: LatLng(0, 0),
  );


  void initLib() async {
    String wformattedAddress = "";
    print("♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎ initLib ");

    String aAdr = widget.aAdresse;
    wMapTools_Geocoding = await MapTools.GetLatLngfromAddress(aAdr);
    _center = wMapTools_Geocoding.Geo_LatLng;
    dbSiege = await MapTools.BitmapDescriptorAsset('assets/images/ico_Marker.png');
    _addMarker(_center, "${widget.aNom}", wMapTools_Geocoding.Geo_formattedAddress, dbSiege);

    await googleMapController.animateCamera(CameraUpdate.newLatLng(_center));

     wLatLngBounds = await googleMapController.getVisibleRegion();



    setState(() {});
  }

  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    print("♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎ _onMapCreated ");
    googleMapController = controller;
    print("♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎ _onMapCreated initLib >");
    initLib();
    print("♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎ _onMapCreated initLib <");
  }

  @override
  Widget build(BuildContext context) {
    String aAdresse = wAdresse.replaceAll(",", "\n");

    double width = MediaQuery.of(context).size.width - 65;
    double height = MediaQuery.of(context).size.height - 176;
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      insetPadding:EdgeInsets.fromLTRB(20, 20, 20, 20),

      title: Container(
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
                "Carte",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_W,
              ),
              Spacer(),
              Container(
                width: 40,
              ),

            ],
          )),
      content: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Colors.black26,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToolsBar(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width,
                        height: height,
                        child: buildMap(context),
                      )
                    ],
                  ),
                ],
              ),
              !wAffInfoWindows
                  ? Container()
                  : Positioned(
                      left: wScreenCoordinate.x.toDouble(),
                      top: wScreenCoordinate.y.toDouble(),
                      child: InkWell(
                        child: Container(
                          width: 500,
                          height: 100,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12)), border: Border.all(color: gColors.primary)),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 140,
                                height: 70,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset('assets/images/Ico_Vp2.png', fit: BoxFit.cover),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        wTitle,
                                        style: gColors.bodyTitle1_B_Gr,
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.aAdr1,
                                        style: gColors.bodySaisie_N_G,
                                      ),
                                      Text(
                                        widget.aCp,
                                        style: gColors.bodySaisie_N_G,
                                      ),
                                      Text(
                                        widget.aVille,
                                        style: gColors.bodySaisie_N_G,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),



                        ),
                        onTap: () {
                          print("onTap marker $wTitle");
                          wAffInfoWindows = false;
                          setState(() {});
                        },
                      ),
                    ),
            ],
          )),
    );
  }

  //**************************************************
  //**************************************************
  //**************************************************

  @override
  Widget buildMap(BuildContext context) {
    print("♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎ buildMap ");

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16,
      ),
      zoomControlsEnabled: true,
//      minMaxZoomPreference: MinMaxZoomPreference(10, 18),
      markers: _markers.values.toSet(),
      onMapCreated: _onMapCreated,
      onTap: _onMapTap,
      onCameraMove: _onCameraMove,
    );
  }

  Future<Marker> _timestampedMarker(MarkerId id, LatLng position) async {
    wMapTools_Geocoding = await MapTools.GetAddressfromLatLng(position);
    return Marker(
      markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
      position: position,
      infoWindow: InfoWindow(
        snippet: "${wMapTools_Geocoding.Geo_LatLng}",
        title: "${wMapTools_Geocoding.Geo_formattedAddress}",
      ),
      //_jitterPosition(position, 0.002), // Jitter so not all markers fall in the same center...
    );
  }

  void _addMarker(LatLng position, String title, String snippet, BitmapDescriptor Bdico) {
    setState(() {
      final MarkerId id = MarkerId('${_markers.length}');
      _markers[id] = Marker(
        markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
        position: position,
        icon: Bdico,
        onTap: () async {
          print("onTap marker $title");
          wTitle = title;
          wAdresse = snippet;
          wlatLng = position;
          wScreenCoordinate = await googleMapController.getScreenCoordinate(wlatLng);
          wAffInfoWindows = true;
          setState(() {});
        },
      );
    });
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  void _onMapTap(LatLng newPosition) async {
    _markers.forEach((markerId, marker) async {
      _markers[markerId] = await _timestampedMarker(markerId, newPosition);
    });

    setState(() {});
    // Center the camera where the user clicked after a few milliseconds...
    Future.delayed(Duration(milliseconds: 150), () {
      googleMapController.animateCamera(CameraUpdate.newLatLng(newPosition));
    });
  }

  //**************************************************
  //**************************************************
  //**************************************************

  Widget ToolsBar(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Center", ToolsBarCenter),
                Container(
                  width: 10,
                ),
                Text("${widget.aNom} - ${wMapTools_Geocoding.Geo_formattedAddress}",
                  style: gColors.bodySaisie_B_G,
                ),
              ],
            ),
            Container(
              height: 5,
              color: gColors.white,
            ),
            Container(
              height: 1,
              color: Colors.black26,
            )
          ],
        ));
  }

  void ToolsBarCenter() async {
    print("ToolsBarCenter _center ${_center.toString()}");
    await googleMapController.animateCamera(CameraUpdate.newLatLng(_center));
    await  googleMapController.animateCamera(CameraUpdate.newLatLngBounds(wLatLngBounds, 0));


  }
}
