import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';



class Client_Map_Sites_Dialog {
  Client_Map_Sites_Dialog();

  static Future<void> Client_Map_dialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new Client_Map(
      ),
    );
  }
}


class Client_Map extends StatefulWidget {

  const Client_Map({Key? key })
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
  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;

  String wTitle = "";
  String wAdresse = "";

  String wAdr1 = "";
  String wCP = "";
  String wVille = "";


  LatLng wlatLng = LatLng(0, 0);
  ScreenCoordinate wScreenCoordinate = ScreenCoordinate(
    x: 0,
    y: 0,
  );
  bool wAffInfoWindows = false;

  double minLat = 999;
  double maxLat = -999;
  double minLong = 999;
  double maxLong = -999;

  Uint8List pic = Uint8List.fromList([0]);
  late Image wImage;
  bool imageisload = false;


  LatLngBounds wLatLngBounds = LatLngBounds(
    southwest: LatLng(0, 0),
    northeast: LatLng(0, 0),
  );


  void initLib() async {
    LatLng wLatLng = LatLng(0, 0);
    String wformattedAddress = "";

    MapTools_Geocoding wmaptoolsGeocoding = MapTools_Geocoding(wLatLng, wformattedAddress);
    dbSiege = await MapTools.BitmapDescriptorAsset('assets/images/ico_Marker.png');

    await DbTools.getSitesClient(DbTools.gClient.ClientId);
    for (int i = 0; i < DbTools.ListSite.length; i++) {
      Site wSite = DbTools.ListSite[i];
      wmaptoolsGeocoding = await MapTools.GetLatLngfromAddress("${wSite.Site_Adr1} ${wSite.Site_Adr2} ${wSite.Site_Adr3} ${wSite.Site_Adr4} ${wSite.Site_CP} ${wSite.Site_Ville}");
      wlatLng = wmaptoolsGeocoding.Geo_LatLng;
      if (wmaptoolsGeocoding.Geo_LatLng.latitude < minLat) minLat = wmaptoolsGeocoding.Geo_LatLng.latitude;
      if (wmaptoolsGeocoding.Geo_LatLng.latitude > maxLat) maxLat = wmaptoolsGeocoding.Geo_LatLng.latitude;
      if (wmaptoolsGeocoding.Geo_LatLng.longitude < minLong) minLong = wmaptoolsGeocoding.Geo_LatLng.longitude;
      if (wmaptoolsGeocoding.Geo_LatLng.longitude > maxLong) maxLong = wmaptoolsGeocoding.Geo_LatLng.longitude;
      _addMarker(wlatLng, wSite.SiteId, wSite.Site_Nom, wmaptoolsGeocoding.Geo_formattedAddress, wSite.Site_Adr1, wSite.Site_CP, wSite.Site_Ville, dbSiege);
    }



    _center = LatLng(minLat + (maxLat - minLat) / 2, minLong + (maxLong - minLong) / 2);
    await googleMapController.animateCamera(CameraUpdate.newLatLng(_center));
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );
    await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 0));

    double wZoom = await googleMapController.getZoomLevel();
    
    await googleMapController.animateCamera(CameraUpdate.zoomTo(wZoom + 0.5));
    print("•••••••••••••••••••••••• MAP initLib ${_center.latitude} ${_center.longitude}");

    setState(() {});
  }

  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
    initLib();
  }

  @override
  Widget build(BuildContext context) {

    print("•••••••••••••••••••••••• build");

    double width = MediaQuery.of(context).size.width - 65;
    double height = MediaQuery.of(context).size.height - 150;
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
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12)), border: Border.all(color: gColors.LinearGradient1)),
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
                                  wAdr1,
                                  style: gColors.bodySaisie_N_G,
                                ),
                                Text(
                                  wCP,
                                  style: gColors.bodySaisie_N_G,
                                ),
                                Text(
                                  wVille,
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
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 19,
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

  void _addMarker(LatLng position, int aID, String title, String snippet, String aAdr1, String aCP, String aVille, BitmapDescriptor Bdico) {
    setState(() {
      final MarkerId id = MarkerId('${_markers.length}');
      _markers[id] = Marker(
        markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
        position: position,
        icon: Bdico,
        onTap: () async {
          print("onTap marker $title");
          int wID = aID;

          imageisload = false;
          String wUserImg = "Site_${wID}.jpg";
          pic = await gColors.getImage(wUserImg);
          print("pic $wUserImg"); // ${pic}");
          if (pic.length > 0) {
            wImage = Image.memory(
              pic,
              fit: BoxFit.scaleDown,
              width: 200,
              height: 200,
            );
            imageisload = true;
          }

          wTitle = title;
          wAdresse = snippet;
          wAdr1 = aAdr1;
          wCP = aCP;
          wVille = aVille;
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
                Text("${DbTools.gClient.Client_Nom}",
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
    await googleMapController.animateCamera(CameraUpdate.newLatLng(_center));
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );
    await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 0));
    wAffInfoWindows = false;
    setState(() {

    });
  }


}
