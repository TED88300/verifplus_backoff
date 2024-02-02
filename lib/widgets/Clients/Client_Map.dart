

import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:verifplus_backoff/Tools/MapTools.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';



class Client_Map extends StatefulWidget {
  const Client_Map({Key? key}) : super(key: key);

  @override
  State<Client_Map> createState() => _Client_MapState();
}

class _Client_MapState extends State<Client_Map> {
  late BitmapDescriptor dbDepot;
  late BitmapDescriptor dbSiege;

  LatLng _center = LatLng(48.3565074, 5.693670099999999);
  Map<MarkerId, Marker> _markers = {};
  late GoogleMapController googleMapController;
  Location coordinates = Location(lat: 0.0, lng: 0);

  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;

  String wTitle = "";
  String wAdresse = "";
  LatLng wlatLng = LatLng(48.3565074, 5.693670099999999);
  ScreenCoordinate wScreenCoordinate = ScreenCoordinate(x:0, y:0,);
  bool wAffInfoWindows = false;

  void initLib() async {
    LatLng wLatLng = LatLng(0, 0);
    String wformattedAddress = "";

    MapTools_Geocoding wmaptoolsGeocoding = MapTools_Geocoding(wLatLng, wformattedAddress);
    wmaptoolsGeocoding = await MapTools.GetLatLngfromAddress("10 rue du Colonel Renard 88300 Neufchateau");
    _center = wmaptoolsGeocoding.Geo_LatLng;
    dbSiege = await MapTools.BitmapDescriptorAsset('assets/images/Ico.png');

    _addMarker(_center, "Siège", wmaptoolsGeocoding.Geo_formattedAddress, dbSiege);
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 2;
    double height = MediaQuery.of(context).size.height - 428;

    return Container(
        margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
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
            !wAffInfoWindows ? Container() : Positioned(
              left: wScreenCoordinate.x.toDouble() ,
              top: wScreenCoordinate.y.toDouble(),
              child: InkWell(
                child: Container(
                  width: 500,
                  height: 100,
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 10),
                        child: ClipOval(child: Image.asset('assets/images/Ico.png', fit: BoxFit.cover)),
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
                                style: gColors.bodySaisie_B_B,
                              ),
                              Container(height: 10,),
                              Text(
                                wAdresse,
                                style: gColors.bodySaisie_B_G,
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
                  setState(() {

                  });
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
      minMaxZoomPreference: MinMaxZoomPreference(10, 18),
      markers: _markers.values.toSet(),
      onMapCreated: _onMapCreated,
//      onTap: _onMapTap,
      onCameraMove: _onCameraMove,
    );
  }

  Marker _timestampedMarker(MarkerId id, LatLng position) {
    return Marker(
      markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
      position: position, //_jitterPosition(position, 0.002), // Jitter so not all markers fall in the same center...
    );
  }

  void _addMarker(LatLng position, String title, String snippet, BitmapDescriptor Bdico) {
    setState(() {
      final MarkerId id = MarkerId('${_markers.length}');
      _markers[id] = Marker(
        markerId: MarkerId('${id.value}_${DateTime.now().millisecondsSinceEpoch}'),
        position: position,
        icon: Bdico,

/*
        infoWindow: InfoWindow(
          title: title,
          snippet: snippet,
        ),
*/

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

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
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
                CommonAppBar.SquareRoundIcon(context, 30, 8, Colors.white, Colors.blue, Icons.map_outlined, ToolsBarSave),
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

  void ToolsBarSave() async {}
}
