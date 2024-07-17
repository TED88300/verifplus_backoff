import 'dart:typed_data';

class Intervention {
  int? InterventionId = 0;
  int? Intervention_ZoneId = 0;
  String? Intervention_Date = "";
  String? Intervention_Type = "";
  String? Intervention_Parcs_Type = "";
  String? Intervention_Status = "";
  String? Intervention_Histo_Status = "";
  String? Intervention_Facturation = "";
  String? Intervention_Histo_Facturation = "";
  String? Intervention_Responsable = "";
  String? Intervention_Responsable2 = "";
  String? Intervention_Responsable3 = "";
  String? Intervention_Responsable4 = "";
  String? Intervention_Responsable5 = "";
  String? Intervention_Responsable6 = "";
  String? Intervention_Partages = "";
  String? Intervention_Contributeurs = "";
  String? Intervention_Ssts = "";
  String? Intervention_Intervenants = "";
  String? Intervention_Reglementation = "";
  String? Intervention_Signataire_Client = "";
  String? Intervention_Signataire_Tech = "";
  String? Intervention_Signataire_Date = "";


  String? Client_Nom = "";
  String? Groupe_Nom = "";
  String? Site_Nom = "";
  String? Zone_Nom = "";

  int? ClientId = 0;
  int? GroupeId = 0;
  int? SiteId = 0;
  int? ZoneId = 0;

  String? Intervention_Remarque = "";
  int? Cnt = 0;
  int Intervention_Sat = 0;

  Uint8List Intervention_Signature_Client = Uint8List.fromList([]);
  Uint8List Intervention_Signature_Tech = Uint8List.fromList([]);
  String Intervention_Signataire_Date_Client	 = "";

  static InterventionInit() {
    return Intervention(-1, 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "","","","", 0, 0,Uint8List.fromList([]),Uint8List.fromList([]) ,"");
  }

  Intervention(int InterventionId,
      int Intervention_ZoneId,
      String Intervention_Date,
      String Intervention_Type,
      String Intervention_Parcs_Type,
      String Intervention_Status,
      String Intervention_Histo_Status,
      String Intervention_Facturation,
      String Intervention_Histo_Facturation,
      String Intervention_Responsable,
      String Intervention_Responsable2,
      String Intervention_Responsable3,
      String Intervention_Responsable4,
      String Intervention_Responsable5,
      String Intervention_Responsable6,
      String Intervention_Partages,
      String Intervention_Contributeurs,
      String Intervention_Ssts,
      String Intervention_Intervenants,
      String Intervention_Reglementation,
      String Intervention_Signataire_Client,
      String Intervention_Signataire_Tech,
      String Intervention_Signataire_Date,
      String Intervention_Remarque,
      int Cnt,
      int Intervention_Sat,
      Uint8List Intervention_Signature_Client,
      Uint8List Intervention_Signature_Tech,
      String Intervention_Signataire_Date_Client,
  ) {
    this.InterventionId = InterventionId;
    this.Intervention_ZoneId = Intervention_ZoneId;
    this.Intervention_Date = Intervention_Date;
    this.Intervention_Type = Intervention_Type;
    this.Intervention_Parcs_Type = Intervention_Parcs_Type;
    this.Intervention_Status = Intervention_Status;
    this.Intervention_Histo_Status = Intervention_Histo_Status;
    this.Intervention_Facturation = Intervention_Facturation;
    this.Intervention_Histo_Facturation = Intervention_Histo_Facturation;
    this.Intervention_Responsable = Intervention_Responsable;
    this.Intervention_Responsable2 = Intervention_Responsable2;
    this.Intervention_Responsable3 = Intervention_Responsable3;
    this.Intervention_Responsable4 = Intervention_Responsable4;
    this.Intervention_Responsable5 = Intervention_Responsable5;
    this.Intervention_Responsable6 = Intervention_Responsable6;
    this.Intervention_Partages = Intervention_Partages;
    this.Intervention_Contributeurs = Intervention_Contributeurs;
    this.Intervention_Ssts = Intervention_Ssts;
    this.Intervention_Intervenants = Intervention_Intervenants;
    this.Intervention_Reglementation = Intervention_Reglementation;
    this.Intervention_Signataire_Client = Intervention_Signataire_Client;
    this.Intervention_Signataire_Tech = Intervention_Signataire_Tech;
    this.Intervention_Signataire_Date = Intervention_Signataire_Date;
    this.Intervention_Remarque = Intervention_Remarque;
    this.Cnt = Cnt;
    this.Intervention_Sat = Intervention_Sat;
    this.Intervention_Signataire_Client = Intervention_Signataire_Client;
    this.Intervention_Signataire_Tech = Intervention_Signataire_Tech;
    this.Intervention_Signataire_Date_Client = Intervention_Signataire_Date_Client;
  }

  factory Intervention.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    String wCnt = "0";
    if (json['Cnt'] != null) wCnt = json['Cnt'];
    String wIntervention_Sat = "0";
    if (json['Intervention_Sat'] != null) wIntervention_Sat = json['Intervention_Sat'];

    Uint8List wUint8ListTech = Uint8List.fromList([]);
    if (json['Intervention_Signature_Tech'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Tech'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8ListTech = Uint8List.fromList(list);
      }
    }

    Uint8List wUint8List = Uint8List.fromList([]);
    if (json['Intervention_Signature_Client'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Client'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8List = Uint8List.fromList(list);
      }
    }


    Intervention wIntervention = Intervention(int.parse(json['InterventionId']), int.parse(json['Intervention_ZoneId']), json['Intervention_Date'], json['Intervention_Type'], json['Intervention_Parcs_Type'], json['Intervention_Status'], json['Intervention_Histo_Status'], json['Intervention_Facturation'], json['Intervention_Histo_Facturation'], json['Intervention_Responsable'],
        json['Intervention_Responsable2'],
        json['Intervention_Responsable3'],
        json['Intervention_Responsable4'],
      json['Intervention_Responsable5'],
      json['Intervention_Responsable6'],
        json['Intervention_Partages'],
      json['Intervention_Contributeurs'],
      json['Intervention_Ssts'],
      json['Intervention_Intervenants'],
      json['Intervention_Reglementation'],
        json['Intervention_Signataire_Client'],
      json['Intervention_Signataire_Tech'],
      json['Intervention_Signataire_Date'],
      json['Intervention_Remarque'],
    int.parse(wCnt),
    int.parse(wIntervention_Sat),
    wUint8ListTech,
    wUint8List,
    json['Intervention_Signataire_Date_Client'],

  );

    return wIntervention;
  }

  factory Intervention.fromJsonClient(Map<String, dynamic> json) {
//    print("json $json");

    String wCnt = "0";
    if (json['Cnt'] != null) wCnt = json['Cnt'];
  String wIntervention_Sat = "0";
  if (json['Intervention_Sat'] != null) wIntervention_Sat = json['Intervention_Sat'];

    Uint8List wUint8ListTech = Uint8List.fromList([]);
    if (json['Intervention_Signature_Tech'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Tech'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8ListTech = Uint8List.fromList(list);
      }
    }

    Uint8List wUint8List = Uint8List.fromList([]);
    if (json['Intervention_Signature_Client'].toString().isNotEmpty) {
      String value = json['Intervention_Signature_Client'];
      if (value.length > 2) {
        List<int> list = value.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
          return int.tryParse(e)!;
        }).toList();

        wUint8List = Uint8List.fromList(list);
      }
    }

    Intervention wIntervention = Intervention(int.parse(json['InterventionId']), int.parse(json['Intervention_ZoneId']), json['Intervention_Date'], json['Intervention_Type'], json['Intervention_Parcs_Type'], json['Intervention_Status'], json['Intervention_Histo_Status'], json['Intervention_Facturation'], json['Intervention_Histo_Facturation'], json['Intervention_Responsable'],
        json['Intervention_Responsable2'],
        json['Intervention_Responsable3'],
        json['Intervention_Responsable4'],
      json['Intervention_Responsable5'],
      json['Intervention_Responsable6'],
        json['Intervention_Partages'],
      json['Intervention_Contributeurs'],
      json['Intervention_Ssts'],
      json['Intervention_Intervenants'], json['Intervention_Reglementation'],
        json['Intervention_Signataire_Client'], json['Intervention_Signataire_Tech'], json['Intervention_Signataire_Date'], json['Intervention_Remarque']
        , int.parse(wCnt)
  , int.parse(wIntervention_Sat),wUint8ListTech,
      wUint8List,
      json['Intervention_Signataire_Date_Client'],

  );

    wIntervention.Client_Nom = json['Client_Nom'];
    wIntervention.Groupe_Nom = json['Groupe_Nom'];
    wIntervention.Site_Nom = json['Site_Nom'];
    wIntervention.Zone_Nom = json['Zone_Nom'];

    wIntervention.ClientId = int.parse(json['ClientId']);
    wIntervention.GroupeId = int.parse(json['GroupeId']);
    wIntervention.SiteId = int.parse(json['SiteId']);
    wIntervention.ZoneId = int.parse(json['ZoneID']);

    return wIntervention;
  }

  String Desc() {
    return '$InterventionId        '
        '$Client_Nom   '
        '$Groupe_Nom   '
        '$Site_Nom   '
        '$Zone_Nom   '
        '$Intervention_ZoneId   '
        '$Intervention_Date     '
        '>>> Intervention_Type >>> $Intervention_Type     '
        '>>> Intervention_Parcs_Type >>> $Intervention_Parcs_Type         '
        '$Intervention_Status             '
        '$Intervention_Histo_Status       '
        '$Intervention_Facturation        '
        '$Intervention_Histo_Facturation  '
        '$Intervention_Responsable        '
        '$Intervention_Responsable2        '
        '$Intervention_Responsable3        '
        '$Intervention_Responsable4        '
        '$Intervention_Responsable5        '
        '$Intervention_Responsable6        '
        '$Intervention_Partages        '
        '$Intervention_Contributeurs        '
        '$Intervention_Ssts        '
        '$Intervention_Intervenants       '
        '$Intervention_Reglementation     '
        '$Intervention_Signataire_Client  '
        '$Intervention_Signataire_Tech    '
        '$Intervention_Signataire_Date    '
        '$Intervention_Remarque '
        '$Cnt  '
        '$Intervention_Sat';
  }
}
