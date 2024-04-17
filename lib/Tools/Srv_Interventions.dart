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
  String? Intervention_Intervenants = "";
  String? Intervention_Reglementation = "";
  String? Intervention_Signataire_Client = "";
  String? Intervention_Signataire_Tech = "";
  String? Intervention_Signataire_Date = "";

  String? Client_Nom = "";
  String? Groupe_Nom = "";
  String? Site_Nom = "";
  String? Zone_Nom = "";


  String? Intervention_Remarque = "";
  int? Cnt = 0;

  static InterventionInit() {
    return Intervention(-1, 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0);
  }

  Intervention(int InterventionId, int Intervention_ZoneId, String Intervention_Date, String Intervention_Type, String Intervention_Parcs_Type, String Intervention_Status, String Intervention_Histo_Status, String Intervention_Facturation, String Intervention_Histo_Facturation,
      String Intervention_Responsable,
      String Intervention_Responsable2,
      String Intervention_Intervenants, String Intervention_Reglementation, String Intervention_Signataire_Client, String Intervention_Signataire_Tech, String Intervention_Signataire_Date, String Intervention_Remarque, int Cnt) {
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
    this.Intervention_Intervenants = Intervention_Intervenants;
    this.Intervention_Reglementation = Intervention_Reglementation;
    this.Intervention_Signataire_Client = Intervention_Signataire_Client;
    this.Intervention_Signataire_Tech = Intervention_Signataire_Tech;
    this.Intervention_Signataire_Date = Intervention_Signataire_Date;
    this.Intervention_Remarque = Intervention_Remarque;
    this.Cnt = Cnt;
  }

  factory Intervention.fromJson(Map<String, dynamic> json) {
//    print("json $json");

    String wCnt = "0";
    if (json['Cnt'] != null) wCnt = json['Cnt'];

    Intervention wIntervention = Intervention(
        int.parse(json['InterventionId']), int.parse(json['Intervention_ZoneId']), json['Intervention_Date'], json['Intervention_Type'], json['Intervention_Parcs_Type'], json['Intervention_Status'], json['Intervention_Histo_Status'], json['Intervention_Facturation'], json['Intervention_Histo_Facturation'],
        json['Intervention_Responsable'],
        json['Intervention_Responsable2'],
        json['Intervention_Intervenants'], json['Intervention_Reglementation'], json['Intervention_Signataire_Client'], json['Intervention_Signataire_Tech'], json['Intervention_Signataire_Date'], json['Intervention_Remarque'], int.parse(wCnt));

    return wIntervention;
  }



  factory Intervention.fromJsonClient(Map<String, dynamic> json) {
//    print("json $json");

    String wCnt = "0";
    if (json['Cnt'] != null) wCnt = json['Cnt'];

    Intervention wIntervention = Intervention(
        int.parse(json['InterventionId']), int.parse(json['Intervention_ZoneId']), json['Intervention_Date'], json['Intervention_Type'], json['Intervention_Parcs_Type'], json['Intervention_Status'], json['Intervention_Histo_Status'], json['Intervention_Facturation'], json['Intervention_Histo_Facturation'],
        json['Intervention_Responsable'],
        json['Intervention_Responsable2'],
        json['Intervention_Intervenants'], json['Intervention_Reglementation'], json['Intervention_Signataire_Client'], json['Intervention_Signataire_Tech'], json['Intervention_Signataire_Date'], json['Intervention_Remarque'], int.parse(wCnt));

    wIntervention.Client_Nom = json['Client_Nom'];
    wIntervention.Groupe_Nom = json['Groupe_Nom'];
    wIntervention.Site_Nom = json['Site_Nom'];
    wIntervention.Zone_Nom = json['Zone_Nom'];
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
        '$Intervention_Type     '
        '$Intervention_Parcs_Type         '
        '$Intervention_Status             '
        '$Intervention_Histo_Status       '
        '$Intervention_Facturation        '
        '$Intervention_Histo_Facturation  '
        '$Intervention_Responsable        '
        '$Intervention_Responsable2        '
        '$Intervention_Intervenants       '
        '$Intervention_Reglementation     '
        '$Intervention_Signataire_Client  '
        '$Intervention_Signataire_Tech    '
        '$Intervention_Signataire_Date    '
        '$Intervention_Remarque '
        '$Cnt';
  }
}
