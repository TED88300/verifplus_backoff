class Articles_Link_Verif_Ebp {
  int    Articles_Link_VerifId            = 0;
  String Articles_Link_Verif_ParentID     = "";
  String Articles_Link_Verif_TypeChildID  = "";
  String Articles_Link_Verif_ChildID      = "";
  String Articles_Link_Verif_TypeVerif    = "";
  double Articles_Link_Verif_Qte          = 0;

  String Articles_Link_Verif_Indisponible      = "";




  String Articles_Link_Verif_ChildID_Lib      = "";

  static Articles_Link_Verif_EbpInit() {
    return Articles_Link_Verif_Ebp(0, "", "", "", "", 0, "");
  }

  Articles_Link_Verif_Ebp(int    Articles_Link_VerifId, String Articles_Link_Verif_ParentID, String Articles_Link_Verif_TypeChildID, String Articles_Link_Verif_ChildID,String Articles_Link_Verif_TypeVerif, double Articles_Link_Verif_Qte,String Articles_Link_Verif_Indisponible) {
  this.Articles_Link_VerifId           =  Articles_Link_VerifId;
  this.Articles_Link_Verif_ParentID    =  Articles_Link_Verif_ParentID;
  this.Articles_Link_Verif_TypeChildID =  Articles_Link_Verif_TypeChildID;
  this.Articles_Link_Verif_ChildID     =  Articles_Link_Verif_ChildID;
  this.Articles_Link_Verif_TypeVerif	 =  Articles_Link_Verif_TypeVerif;
  this.Articles_Link_Verif_Qte	       =  Articles_Link_Verif_Qte;
  this.Articles_Link_Verif_Indisponible	       =  Articles_Link_Verif_Indisponible;


  }

  factory Articles_Link_Verif_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Articles_Link_Verif_Ebp warticlesLinkVerifEbp = Articles_Link_Verif_Ebp(
      int.parse(json['Articles_Link_VerifId']),
      json['Articles_Link_Verif_ParentID'],
      json['Articles_Link_Verif_TypeChildID'],
      json['Articles_Link_Verif_ChildID'],
      json['Articles_Link_Verif_TypeVerif'],
      double.parse(json['Articles_Link_Verif_Qte']),
      json['Articles_Link_Verif_Indisponible'],

    );

    return warticlesLinkVerifEbp;
  }

  String Desc() {
    return '$Articles_Link_VerifId, '
        '$Articles_Link_VerifId          , '

        '$Articles_Link_Verif_ParentID   , '
        '$Articles_Link_Verif_TypeChildID, '
        '$Articles_Link_Verif_ChildID    , '
        '$Articles_Link_Verif_TypeVerif	      , '
        '$Articles_Link_Verif_Qte	      , '
        '$Articles_Link_Verif_Indisponible	      , '

    ;

 }
}
