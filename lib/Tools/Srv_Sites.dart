class Site {
  int SiteId = -1;
  int Site_GroupeId = -1;
  String Site_Code = "";
  String Site_Depot = "";
  String Site_Nom = "";
  String Site_Adr1 = "";
  String Site_Adr2 = "";
  String Site_Adr3 = "";
  String Site_Adr4 = "";
  String Site_CP = "";
  String Site_Ville = "";
  String Site_Pays = "";
  String Site_Acces = "";
  String? Site_RT = "";
  String? Site_APSAD = "";
  String Site_Rem = "";
  int Site_ResourceId = -1;

  static SiteInit() {
    return Site(0, 0, "", "", "", "", "", "", "", "", "", "", "", "", "","", 0);
  }

  Site(
    int SiteId,
    int Site_GroupeId,
    String Site_Code,
      String Site_Depot,
    String Site_Nom,
    String Site_Adr1,
    String Site_Adr2,
    String Site_Adr3,
      String Site_Adr4,
    String Site_CP,
    String Site_Ville,
    String Site_Pays,
    String Site_Acces,
      String Site_RT,
      String Site_APSAD,
    String Site_Rem,
    int Site_ResourceId,

  ) {
    this.SiteId = SiteId;
    this.Site_GroupeId = Site_GroupeId;
    this.Site_Code = Site_Code;
    this.Site_Depot = Site_Depot;
    this.Site_Nom = Site_Nom;
    this.Site_Adr1 = Site_Adr1;
    this.Site_Adr2 = Site_Adr2;
    this.Site_Adr3 = Site_Adr3;
    this.Site_Adr4 = Site_Adr4;
    this.Site_CP = Site_CP;
    this.Site_Ville = Site_Ville;
    this.Site_Pays = Site_Pays;
    this.Site_Acces = Site_Acces;
    this.Site_RT = Site_RT;
    this.Site_APSAD = Site_APSAD;
    this.Site_Rem = Site_Rem;
    this.Site_ResourceId = Site_ResourceId;
  }

  factory Site.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Site wUser = Site(int.parse(json['SiteId']),
        int.parse(json['Site_GroupeId']),
        json['Site_Code'],
        json['Site_Depot'],
        json['Site_Nom'],
        json['Site_Adr1'],
        json['Site_Adr2'],
        json['Site_Adr3'],
        json['Site_Adr4'],
        json['Site_CP'],
        json['Site_Ville'],
        json['Site_Pays'],
        json['Site_Acces'],
        json['Site_RT'],
        json['Site_APSAD'],
        json['Site_Rem'],
        int.parse(json['Site_ResourceId']));
    return wUser;
  }

  String Desc() {
    return '$SiteId        '
        '$Site_GroupeId '
        '$Site_Code     '
        '$Site_Depot     '
        '$Site_Nom     '
        '$Site_Adr1     '
        '$Site_Adr2     '
        '$Site_Adr3     '
        '$Site_Adr4     '
        '$Site_CP       '
        '$Site_Ville    '
        '$Site_Pays     '
        '$Site_Acces     '
        '$Site_RT     '
        '$Site_APSAD     '
        '$Site_ResourceId     '
        '$Site_Rem      ';
  }
}
