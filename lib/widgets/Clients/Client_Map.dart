import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';

import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/Tools/Srv_Sites.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';
import 'package:verifplus_backoff/widgets/Clients/Client_Map_Dialog_Sites.dart';

class Client_Map extends StatefulWidget {
  const Client_Map({Key? key}) : super(key: key);

  @override
  State<Client_Map> createState() => _Client_MapState();
}

class _Client_MapState extends State<Client_Map> {
  late BitmapDescriptor dbDepot;
  late BitmapDescriptor dbSiege;

  LatLng _center = LatLng(0, 0);
  Map<MarkerId, Marker> _markers = {};
  late GoogleMapController googleMapController;
  Location coordinates = Location(lat: 0.0, lng: 0);

  int wID = 0;
  String wTitle = "";
  String wAdresse = "";
  String wAdr1 = "";
  String wCP = "";
  String wVille = "";

  LatLng wlatLng = LatLng(43.39131322677821, 5.145960122088796);
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

  late ImageProvider wImage;

  bool imageisload = false;

  void initLib() async {
    print("♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎♥︎ initLib");
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

      print("wSite.Site_Nom ${wSite.Site_Nom} - ${wSite.Site_Adr1} > ${wlatLng.latitude} ${wlatLng.longitude}");
      _addMarker(wlatLng, wSite.SiteId, wSite.Site_Nom, wmaptoolsGeocoding.Geo_formattedAddress, wSite.Site_Adr1, wSite.Site_CP, wSite.Site_Ville, dbSiege);
    }


    _center = LatLng(minLat + (maxLat - minLat) / 2, minLong + (maxLong - minLong) / 2);
    await googleMapController.animateCamera(CameraUpdate.newLatLng(_center));
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );



    await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 0));

    print("•••••••••••••••••••••••• MAP initLib ${_center.latitude} ${_center.longitude}");

    setState(() {});
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("•••••••••••••••••••••• MAP build ${_center.latitude} ${_center.longitude}");

    double width = MediaQuery.of(context).size.width - 30;
    double height = MediaQuery.of(context).size.height - 415;

    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.white,
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
                    child:

                    InkWell(
                      child: Expanded(
                        child: Container(
//                  width: imageisload ? 700 :500,
                          height: 100,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12)), border: Border.all(color: gColors.primary)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 116,
                                height: 70,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset('assets/images/Ico_Vp2.png', fit: BoxFit.cover),
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          wTitle,
                                          style: gColors.bodyTitle1_B_Gr,
                                        ),
                                        Container(
                                          height: 5,
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
                                ],
                              ),
                              imageisload ?
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                  border: Border.all(
                                    color: gColors.primary,
                                  ),
                                  image: DecorationImage(image: wImage, fit: BoxFit.fill),
                                  color: Colors.white,

                                ),
                              )
                                  : Container(),



                            ],
                          ),
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
        ));
  }

  //**************************************************
  //**************************************************
  //**************************************************

  @override
  Widget buildMap(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18,
      ),
      zoomControlsEnabled: false,
      minMaxZoomPreference: MinMaxZoomPreference(1, 50),
      markers: _markers.values.toSet(),
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
    );
  }

  Marker _timestampedMarker(MarkerId id, LatLng position) {
    return Marker(
      markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
      position: position, //_jitterPosition(position, 0.002), // Jitter so not all markers fall in the same center...
    );
  }

  void _addMarker(LatLng position, int aID, String title, String snippet, String aAdr1, String aCP, String aVille, BitmapDescriptor Bdico) async {
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
          if (pic.length > 0) {
            wImage = MemoryImage(
              pic,
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

  void _onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;

    initLib();
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
    wAffInfoWindows = false;
    setState(() {

    });

    }

  void _onMapTap(LatLng newPosition) {
    setState(() {
      _markers.forEach((markerId, marker) {
        _markers[markerId] = _timestampedMarker(markerId, newPosition);
        // When the Marker position bug is fixed, this can be replaced by:
        // _markers[markerId] = marker.copyWith(positionParam: _jitterPosition(newPosition));
      });
    });
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
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Center", ToolsBarZoom),
                Container(
                  width: 5,
                ),
                CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Zoom", ToolsBarDialog),
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

  void ToolsBarZoom() async {
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

  void ToolsBarDialog() async {
    await Client_Map_Sites_Dialog.Client_Map_dialog(context );

  }



}
