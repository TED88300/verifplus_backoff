class Zone {
  int ZoneId = -1;
  int Zone_SiteId = -1;
  String Zone_Code = "";
  String Zone_Depot = "";

  String Zone_Nom = "";
  String Zone_Adr1 = "";
  String Zone_Adr2 = "";
  String Zone_Adr3 = "";
  String Zone_Adr4 = "";
  String Zone_CP = "";
  String Zone_Ville = "";
  String Zone_Pays = "";
  String Zone_Acces = "";
  String Zone_Rem = "";

  String Zone_APSAD = "";
  String Zone_APSAD_Date = "";
  String Zone_Regle = "";


      String Livr = "";
  String Groupe_Nom = "";


  static ZoneInit() {
    return Zone(0, 0, "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "","");
  }

  Zone(
    int ZoneId,
    int Zone_SiteId,
    String Zone_Code,
      String Zone_Depot,
    String Zone_Nom,
    String Zone_Adr1,
    String Zone_Adr2,
    String Zone_Adr3,
      String Zone_Adr4,
    String Zone_CP,
    String Zone_Ville,
    String Zone_Pays,
    String Zone_Acces,
    String Zone_Rem,
      String Zone_APSAD,
      String Zone_APSAD_Date,
      String Zone_Regle,
    String Livr,
    String Groupe_Nom,
  ) {
    this.ZoneId = ZoneId;
    this.Zone_SiteId = Zone_SiteId;
    this.Zone_Code = Zone_Code;
    this.Zone_Depot = Zone_Depot;

    this.Zone_Nom = Zone_Nom;
    this.Zone_Adr1 = Zone_Adr1;
    this.Zone_Adr2 = Zone_Adr2;
    this.Zone_Adr3 = Zone_Adr3;
    this.Zone_Adr4 = Zone_Adr4;
    this.Zone_CP = Zone_CP;
    this.Zone_Ville = Zone_Ville;
    this.Zone_Pays = Zone_Pays;
    this.Zone_Acces = Zone_Acces;
    this.Zone_Rem = Zone_Rem;
    this.Zone_APSAD = Zone_APSAD;
    this.Zone_APSAD_Date = Zone_APSAD_Date;
    this.Zone_Regle = Zone_Regle;
    this.Livr = Livr;
    this.Groupe_Nom = Groupe_Nom;
  }

  factory Zone.fromJson(Map<String, dynamic> json) {
    print("json $json");

    if (json['Groupe_Nom'] == null) json['Groupe_Nom'] ="";



    Zone wZone = Zone(
        int.parse(json['ZoneId']),
        int.parse(json['Zone_SiteId']),
        json['Zone_Code'],
        json['Zone_Depot'],
        json['Zone_Nom'],
        json['Zone_Adr1'],
        json['Zone_Adr2'],
        json['Zone_Adr3'],
        json['Zone_Adr4'],
        json['Zone_CP'],
        json['Zone_Ville'],
        json['Zone_Pays'],
        json['Zone_Acces'],
        json['Zone_Rem'],
      json['Zone_APSAD'],
      json['Zone_APSAD_Date'],
      json['Zone_Regle'],
        json['Livr'],
        json['Groupe_Nom'],
     );

    print("Zone B");

    return wZone;
  }

  String Desc() {
    return '$ZoneId        '
        '$Zone_SiteId '
        '$Zone_Code     '
        '$Zone_Depot     '
        '$Zone_Nom     '
        '$Zone_Adr1     '
        '$Zone_Adr2     '
        '$Zone_Adr3     '
        '$Zone_Adr4     '
        '$Zone_CP       '
        '$Zone_Ville    '
        '$Zone_Pays     '
        '$Zone_Acces     '
        '$Zone_Rem      '
        '$Zone_APSAD      '
        '$Zone_APSAD_Date      '
        '$Zone_Regle      '
        '$Livr      '
        '$Groupe_Nom      ';
  }
}
