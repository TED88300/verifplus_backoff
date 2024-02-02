

class Art {

  int     ArtId         = 0;
  String  Art_Groupe    = "";
  String  Art_Fam       = "";
  String  Art_Sous_Fam  = "";
  String  Art_Id        = "";
  String  Art_Lib       = "";
  int     Art_Stock     = 0;

  static ArtInit() {
    return Art(0, "",  "", "","","",0);
  }
  Art(
  int     ArtId          ,
  String  Art_Groupe     ,
  String  Art_Fam       ,
  String  Art_Sous_Fam  ,
  String  Art_Id        ,
  String  Art_Lib       ,
  int     Art_Stock        ,

      ) {
    this.ArtId         = ArtId        ;
    this.Art_Groupe    = Art_Groupe  ;
    this.Art_Fam       = Art_Fam       ;
    this.Art_Sous_Fam  = Art_Sous_Fam    ;
    this.Art_Id        = Art_Id        ;
    this.Art_Lib       = Art_Lib       ;
    this.Art_Stock     = Art_Stock       ;

  }

  factory Art.fromJson(Map<String, dynamic> json) {

    print("json $json");
    Art wUser = Art(
      int.parse(json['ArtId']),
      json['Art_Groupe'],
      json['Art_Fam'],
      json['Art_Sous_Fam'],
      json['Art_Id'],
      json['Art_Lib'],
      int.parse(json['Art_Stock']),

    );

    return wUser;
  }


  
  String Desc() {
    return '$ArtId, $Art_Groupe, $Art_Fam, $Art_Sous_Fam, $Art_Id, $Art_Lib, $Art_Stock,';
  }



}
