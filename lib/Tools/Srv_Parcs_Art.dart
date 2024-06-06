import 'package:flutter/material.dart';

class Parc_Art {
  int?    ParcsArtId = 0;
  int?    ParcsArt_ParcsId = 0;
  String? ParcsArt_Id = "";
  String? ParcsArt_Type = "";
  String? ParcsArt_lnk = "";
  String? ParcsArt_Fact = "";
  String? ParcsArt_Livr = "";
  int?    ParcsArt_Qte = 0;

  String? ParcsArt_Lib = "";
  int?    Qte = 0;
  Image?  wImage ;
  bool    wImgeTrv       = false;

  static Parc_ArtInit(int wParcsArt_ParcsId) {
    String ParcsArt_Lib = "---";
    int ParcsArt_Id = -1;
    Parc_Art wParc_Art = new  Parc_Art();
    wParc_Art.ParcsArtId = -1;
    wParc_Art.ParcsArt_ParcsId = wParcsArt_ParcsId;
    wParc_Art.ParcsArt_Type = "P";
    wParc_Art.ParcsArt_lnk = "";
    wParc_Art.ParcsArt_Fact = "Fact.";
    wParc_Art.ParcsArt_Livr = "Livré";
    wParc_Art.ParcsArt_Id = "${ParcsArt_Id}";
    wParc_Art.ParcsArt_Lib = ParcsArt_Lib;
    wParc_Art.ParcsArt_Qte = 0;
    wParc_Art.Qte = 0;
    wParc_Art.wImage = Image.asset("assets/images/Audit_det.png", height: 30, width: 30,);
    return wParc_Art;
  }


  Parc_Art( {
    this.ParcsArtId,
    this.ParcsArt_ParcsId,
    this.ParcsArt_Type,
    this.ParcsArt_lnk,
    this.ParcsArt_Fact,
    this.ParcsArt_Livr,
    this.ParcsArt_Id,
    this.ParcsArt_Lib,
    this.ParcsArt_Qte,
    this.Qte,
  });


  static String getIndex(Parc_Art wParc_Art, int index) {
    int wQteLivr = 0;
    int wQteRel = 0;

    String ParcsArt_Livr = wParc_Art.ParcsArt_Livr!.substring(0,1);
    if (ParcsArt_Livr.compareTo("R") == 0)
    {
      wQteRel = wParc_Art.ParcsArt_Qte!;
    }
    else
    {
      wQteLivr = wParc_Art.ParcsArt_Qte!;

    }


    switch (index) {
      case 0:
        return wParc_Art.ParcsArt_Id.toString();
      case 1:
        return wParc_Art.ParcsArt_Lib.toString();
      case 2:
        return wQteLivr.toStringAsFixed(2).toString();
      case 3:
        return "";
      case 4:
        return wQteRel.toStringAsFixed(2).toString();

    }
    return '';
  }

  static  Parc_Art fromMap(Map<String, dynamic> map) {
    return new Parc_Art(
      ParcsArtId: map["ParcsArtId"],
      ParcsArt_ParcsId: map["ParcsArt_ParcsId"],
      ParcsArt_Fact: map["ParcsArt_Fact"],
      ParcsArt_Livr: map["ParcsArt_Livr"],
      ParcsArt_Type: map["ParcsArt_Type"],
      ParcsArt_lnk: map["ParcsArt_lnk"],
      ParcsArt_Id: map["ParcsArt_Id"],
      ParcsArt_Lib: map["ParcsArt_Lib"],
      ParcsArt_Qte: map["ParcsArt_Qte"],
    );
  }

  factory Parc_Art.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    Parc_Art wTmp = Parc_Art(
        ParcsArtId : int.parse(json['ParcsArtId']),
        ParcsArt_ParcsId:int.parse(json['ParcsArt_ParcsId']),
        ParcsArt_Id:   json['ParcsArt_Id'],
        ParcsArt_Type:    json['ParcsArt_Type'],
        ParcsArt_lnk:   json['ParcsArt_lnk'],
        ParcsArt_Fact:   json['ParcsArt_Fact'],
        ParcsArt_Livr:     json['ParcsArt_Livr'],
        ParcsArt_Lib:    json['ParcsArt_Lib'],
        ParcsArt_Qte:    int.parse(json['Qte']));
    return wTmp;
  }



  static  Parc_Art fromMapQte(Map<String, dynamic> map) {
    return new Parc_Art(
      ParcsArtId: map["ParcsArtId"],
      ParcsArt_ParcsId: map["ParcsArt_ParcsId"],
      ParcsArt_Type: map["ParcsArt_Type"],
      ParcsArt_lnk: map["ParcsArt_lnk"],
      ParcsArt_Fact: map["ParcsArt_Fact"],
      ParcsArt_Livr: map["ParcsArt_Livr"],
      ParcsArt_Id: map["ParcsArt_Id"],
      ParcsArt_Lib: map["ParcsArt_Lib"],
      ParcsArt_Qte: map["ParcsArt_Qte"],
      Qte: map["Qte"],
    );


  }


  Map<String, dynamic> toMap() {
    return {
      'ParcsArtId':         ParcsArtId,
      'ParcsArt_ParcsId':   ParcsArt_ParcsId,
      'ParcsArt_Type':      ParcsArt_Type,
      'ParcsArt_lnk':       ParcsArt_lnk,
      'ParcsArt_Fact':      ParcsArt_Fact,
      'ParcsArt_Livr':      ParcsArt_Livr,
      'ParcsArt_Id':        ParcsArt_Id,
      'ParcsArt_Lib':       ParcsArt_Lib,
      'ParcsArt_Qte':       ParcsArt_Qte,

    };
  }

  @override
  String toString() {
    return 'Parc_Art {ParcsArtId : $ParcsArtId, ParcsArt_ParcsId: $ParcsArt_ParcsId,ParcsArt_Id : $ParcsArt_Id, ParcsArt_Type : $ParcsArt_Type, ParcsArt_lnk : $ParcsArt_lnk, ParcsArt_Fact : $ParcsArt_Fact, ParcsArt_Livr : $ParcsArt_Livr, ParcsArt_Lib : $ParcsArt_Lib, ParcsArt_Qte : $ParcsArt_Qte,}';
  }

  @override
  String Desc() {
    return 'Parc_Art {ParcsArtId : $ParcsArtId,ParcsArt_Id : $ParcsArt_Id, ParcsArt_Fact : $ParcsArt_Fact, ParcsArt_Livr: $ParcsArt_Livr, ParcsArt_ParcsId: $ParcsArt_ParcsId, ParcsArt_Type : $ParcsArt_Type, ParcsArt_lnk : ParcsArt_Id : $ParcsArt_Id, ParcsArt_Lib : $ParcsArt_Lib, ParcsArt_Qte : $ParcsArt_Qte,}';
  }



}