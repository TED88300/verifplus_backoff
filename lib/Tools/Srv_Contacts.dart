class Contact {
  int ContactId = -1;
  int Contact_ClientId = -1;
  int Contact_AdresseId = -1;
  String Contact_Code = "";
  String Contact_Type = "";
  String Contact_Civilite = "";
  String Contact_Prenom = "";
  String Contact_Nom = "";
  String Contact_Fonction = "";
  String Contact_Service = "";
  String Contact_Tel1 = "";
  String Contact_Tel2 = "";
  String Contact_eMail = "";
  String Contact_Rem = "";
  String Contact_Type_Lib = "";

  static ContactInit() {
    return Contact(0, 0, 0,"", "", "", "", "", "", "", "", "", "", "");
  }

  Contact(
    int ContactId,
    int Contact_ClientId,
      int Contact_AdresseId,
    String Contact_Code,
    String Contact_Type,
    String Contact_Civilite,
    String Contact_Prenom,
    String Contact_Nom,
    String Contact_Fonction,
    String Contact_Service,
    String Contact_Tel1,
    String Contact_Tel2,
    String Contact_eMail,
    String Contact_Rem,
  ) {
    this.ContactId = ContactId;
    this.Contact_ClientId = Contact_ClientId;
    this.Contact_AdresseId = Contact_AdresseId;
    this.Contact_Code = Contact_Code;
    this.Contact_Type = Contact_Type;
    this.Contact_Civilite = Contact_Civilite;
    this.Contact_Prenom = Contact_Prenom;
    this.Contact_Nom = Contact_Nom;
    this.Contact_Fonction = Contact_Fonction;
    this.Contact_Service = Contact_Service;
    this.Contact_Tel1 = Contact_Tel1;
    this.Contact_Tel2 = Contact_Tel2;
    this.Contact_eMail = Contact_eMail;
    this.Contact_Rem = Contact_Rem;
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Contact wUser = Contact(
      int.parse(json['ContactId']),
      int.parse(json['Contact_ClientId']),
      int.parse(json['Contact_AdresseId']),
      json['Contact_Code'],
      json['Contact_Type'],
      json['Contact_Civilite'],
      json['Contact_Prenom'],
      json['Contact_Nom'],
      json['Contact_Fonction'],
      json['Contact_Service'],
      json['Contact_Tel1'],
      json['Contact_Tel2'],
      json['Contact_eMail'],
      json['Contact_Rem'],
    );
    return wUser;
  }

  String Desc() {
    return '$ContactId        '
        '$Contact_ClientId '
        '$Contact_AdresseId '
        '$Contact_Code         '
        '$Contact_Type         '
        '$Contact_Civilite     '
        '$Contact_Prenom       '
        '$Contact_Nom          '
        '$Contact_Fonction     '
        '$Contact_Service      '
        '$Contact_Tel1         '
        '$Contact_Tel2         '
        '$Contact_eMail         '
        '$Contact_Rem         ';
  }
}


