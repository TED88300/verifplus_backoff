class Groupe {
  int GroupeId = -1;
  int Groupe_ClientId = -1;
  String Groupe_Code = "";
  String Groupe_Depot = "";
  String Groupe_Nom = "";
  String Groupe_Adr1 = "";
  String Groupe_Adr2 = "";
  String Groupe_Adr3 = "";
  String Groupe_Adr4 = "";
  String Groupe_CP = "";
  String Groupe_Ville = "";
  String Groupe_Pays = "";
  String Groupe_Acces = "";
  String Groupe_Rem = "";
  int NbSite = 0;
  String SiteId = "";

  static GroupeInit() {
    return Groupe(0, 0, "", "", "", "", "", "", "", "", "","", "", "");
  }

  Groupe(
    int GroupeId,
    int Groupe_ClientId,
    String Groupe_Code,
    String Groupe_Depot,
    String Groupe_Nom,
    String Groupe_Adr1,
    String Groupe_Adr2,
    String Groupe_Adr3,
    String Groupe_Adr4,
    String Groupe_CP,
    String Groupe_Ville,
    String Groupe_Pays,
    String Groupe_Acces,
    String Groupe_Rem,
  ) {
    this.GroupeId = GroupeId;
    this.Groupe_ClientId = Groupe_ClientId;
    this.Groupe_Code = Groupe_Code;
    this.Groupe_Depot = Groupe_Depot;
    this.Groupe_Nom = Groupe_Nom;
    this.Groupe_Adr1 = Groupe_Adr1;
    this.Groupe_Adr2 = Groupe_Adr2;
    this.Groupe_Adr3 = Groupe_Adr3;
    this.Groupe_Adr4 = Groupe_Adr4;
    this.Groupe_CP = Groupe_CP;
    this.Groupe_Ville = Groupe_Ville;
    this.Groupe_Pays = Groupe_Pays;
    this.Groupe_Acces = Groupe_Acces;
    this.Groupe_Rem = Groupe_Rem;
  }

  factory Groupe.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Groupe wGroupe = Groupe(int.parse(json['GroupeId']), int.parse(json['Groupe_ClientId']),
        json['Groupe_Code'],
        json['Groupe_Depot'],
        json['Groupe_Nom'],
        json['Groupe_Adr1'],
        json['Groupe_Adr2'],
        json['Groupe_Adr3'],
        json['Groupe_Adr4'],
        json['Groupe_CP'],
        json['Groupe_Ville'],
        json['Groupe_Pays'],
        json['Groupe_Acces'],
        json['Groupe_Rem']);

    wGroupe.SiteId = "";
    wGroupe.NbSite = 0;

    try{
      wGroupe.SiteId = json['SiteId'];
      if (json['SiteId'] != "0")
        wGroupe.NbSite = int.parse(json['NbSite']);

    }
    catch (e) {

    }



    return wGroupe;
  }

  String Desc() {
    return '$GroupeId        '
        '$Groupe_ClientId '
        '$Groupe_Code     '
        '$Groupe_Depot     '
        '$Groupe_Nom     '
        '$Groupe_Adr1     '
        '$Groupe_Adr2     '
        '$Groupe_Adr3     '
        '$Groupe_Adr4     '
        '$Groupe_CP       '
        '$Groupe_Ville    '
        '$Groupe_Pays     '
        '$Groupe_Acces     '
        '$Groupe_Rem      ';
  }
}
