


class Parc_Art {
  int?    ParcsArtId          = 0;
  int?    ParcsArt_ParcsId    = 0;
  String? ParcsArt_Id         = "";
  String? ParcsArt_Type       = "";
  String? ParcsArt_lnk       = "";
  String? ParcsArt_Fact       = "";
  String? ParcsArt_Livr       = "";
  String? ParcsArt_Lib        = "";
  int?    ParcsArt_Qte        = 0;

  static Parc_ArtInit(int wParcsArt_ParcsId, String wParcsArt_Type) {

    Parc_Art wParc_Art = Parc_Art(0,0,"","","","","","",0);
    wParc_Art.ParcsArtId  = -1;
    wParc_Art.ParcsArt_ParcsId  = wParcsArt_ParcsId;
    return wParc_Art;
  }


  Parc_Art(
      ParcsArtId,
      ParcsArt_ParcsId,
      ParcsArt_Id,
      ParcsArt_Type,
      ParcsArt_lnk,
      ParcsArt_Fact,
      ParcsArt_Livr,
      ParcsArt_Lib,
      ParcsArt_Qte,

      ) {
    this.ParcsArtId        = ParcsArtId;
    this.ParcsArt_ParcsId        = ParcsArt_ParcsId;
    this.ParcsArt_Id        = ParcsArt_Id;
    this.ParcsArt_Type        = ParcsArt_Type;
    this.ParcsArt_lnk        = ParcsArt_lnk;
    this.ParcsArt_Fact        = ParcsArt_Fact;
    this.ParcsArt_Livr        = ParcsArt_Livr;
    this.ParcsArt_Lib        = ParcsArt_Lib;
    this.ParcsArt_Qte        = ParcsArt_Qte;
  }


  Map<String, dynamic> toMap() {
    return {
      'ParcsArtId':           ParcsArtId,
      'ParcsArt_ParcsId':     ParcsArt_ParcsId,
      'ParcsArt_Id':          ParcsArt_Id,
      'ParcsArt_Type':        ParcsArt_Type,
      'ParcsArt_lnk':        ParcsArt_lnk,
      'ParcsArt_Fact':        ParcsArt_Fact,
      'ParcsArt_Livr':        ParcsArt_Livr,
      'ParcsArt_Lib':         ParcsArt_Lib,
      'ParcsArt_Qte':         ParcsArt_Qte,
    };
  }


  factory Parc_Art.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    Parc_Art wTmp = Parc_Art(
      int.parse(json['ParcsArtId']),
      int.parse(json['ParcsArt_ParcsId']),
      json['ParcsArt_Id'],
      json['ParcsArt_Type'],
        json['ParcsArt_lnk'],
      json['ParcsArt_Fact'],
        json['ParcsArt_Livr'],
      json['ParcsArt_Lib'],
      int.parse(json['ParcsArt_Qte']));
      return wTmp;
  }




  @override
  String toString() {
    return 'Parc_Art {ParcsArtId: $ParcsArtId, '
        'ParcsArt_ParcsId: $ParcsArt_ParcsId, '
        'ParcsArt_Id $ParcsArt_Id, '
        'ParcsArt_Type $ParcsArt_Type, '
        'ParcsArt_lnk $ParcsArt_lnk, '
        'ParcsArt_Fact $ParcsArt_Fact, '
        'ParcsArt_Livr $ParcsArt_Livr, '
        'ParcsArt_Lib $ParcsArt_Lib, '
        'ParcsArt_Qte $ParcsArt_Qte, ';
  }
}
