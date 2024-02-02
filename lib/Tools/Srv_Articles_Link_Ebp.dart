class Articles_Link_Ebp {
  int    Articles_LinkId            = 0;
  String Articles_Link_ParentID     = "";
  String Articles_Link_TypeChildID  = "";
  String Articles_Link_ChildID      = "";
  String Articles_Link_Qte      = "";
  String Articles_Link_MoID	        = "";
  String Articles_Link_Tps	        = "";
  String Articles_Link_DnID	        = "";
  String Articles_Link_ChildID_Lib      = "";
  String Articles_Link_MoID_Lib      = "";
  String Articles_Link_DnID_Lib      = "";

  String Articles_Link_DnQte      = "";
  String Articles_Link_NewInv      = "";
//
//

  static Articles_Link_EbpInit() {
    return Articles_Link_Ebp(0, "", "","","", "", "", "", "", "");
  }
  Articles_Link_Ebp(int    Articles_LinkId,
      String Articles_Link_ParentID,
      String Articles_Link_TypeChildID,
      String Articles_Link_ChildID,
      String Articles_Link_Qte,
      String Articles_Link_MoID,
      String Articles_Link_Tps,
      String Articles_Link_DnID,
      String Articles_Link_DnQte,
      String Articles_Link_NewInv

      ) {
  this.Articles_LinkId           =  Articles_LinkId;
  this.Articles_Link_ParentID    =  Articles_Link_ParentID;
  this.Articles_Link_TypeChildID =  Articles_Link_TypeChildID;
  this.Articles_Link_ChildID     =  Articles_Link_ChildID;
  this.Articles_Link_Qte          =  Articles_Link_Qte;
  this.Articles_Link_MoID	       =  Articles_Link_MoID;
  this.Articles_Link_Tps	       =  Articles_Link_Tps;
  this.Articles_Link_DnQte	       =  Articles_Link_DnQte;
  this.Articles_Link_NewInv	       =  Articles_Link_NewInv;
  }

  factory Articles_Link_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Articles_Link_Ebp warticlesLinkEbp = Articles_Link_Ebp(
      int.parse(json['Articles_LinkId']),
      json['Articles_Link_ParentID'],
      json['Articles_Link_TypeChildID'],
      json['Articles_Link_ChildID'],
      json['Articles_Link_Qte'],
      json['Articles_Link_MoID'],
      json['Articles_Link_Tps'],
      json['Articles_Link_DnID'],
      json['Articles_Link_DnQte'],
      json['Articles_Link_NewInv'],
    );

    return warticlesLinkEbp;
  }

  String Desc() {
    return '$Articles_LinkId, '
        '$Articles_LinkId          , '

        '$Articles_Link_ParentID   , '
        '$Articles_Link_TypeChildID, '
        '$Articles_Link_ChildID    , '
        '$Articles_Link_Qte    , '
        '$Articles_Link_MoID	      , '
        '$Articles_Link_Tps	      , '
        '$Articles_Link_DnQte	      , '
        '$Articles_Link_NewInv	      , '

    ;

 }
}
