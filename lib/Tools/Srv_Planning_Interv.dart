class Planning_Interv {
  int? Planning_Interv_InterventionId = -1;
  String? Planning_Interv_Intervention_Type = "";
  String? Planning_Interv_Intervention_Parcs_Type = "";
  String? Planning_Interv_Intervention_Status = "";
  int? Planning_Interv_ZoneId = -1;
  String? Planning_Interv_Zone_Nom = "";
  int? Planning_Interv_SiteId = -1;
  String? Planning_Interv_Site_Nom = "";
  int? Planning_Interv_GroupeId = -1;
  String? Planning_Interv_Groupe_Nom = "";
  int? Planning_Interv_ClientId = -1;
  String? Planning_Interv_Client_Nom = "";

  static Planning_RdvInit() {
    return Planning_Interv( 0, "", "", "", 0, "", 0, "", 0, "", 0, "");
  }

  Planning_Interv(
    int Planning_Interv_InterventionId,
    String Planning_Interv_Intervention_Type,
    String Planning_Interv_Intervention_Parc,
    String Planning_Interv_Intervention_Stat,
    int Planning_Interv_ZoneId,
    String Planning_Interv_Zone_Nom,
    int Planning_Interv_SiteId,
    String Planning_Interv_Site_Nom,
    int Planning_Interv_GroupeId,
    String Planning_Interv_Groupe_Nom,
    int Planning_Interv_ClientId,
    String Planning_Interv_Client_Nom,
  ) {
    this.Planning_Interv_InterventionId = Planning_Interv_InterventionId;
    this.Planning_Interv_Intervention_Type = Planning_Interv_Intervention_Type;
    this.Planning_Interv_Intervention_Parcs_Type = Planning_Interv_Intervention_Parc;
    this.Planning_Interv_Intervention_Status = Planning_Interv_Intervention_Stat;
    this.Planning_Interv_ZoneId = Planning_Interv_ZoneId;
    this.Planning_Interv_Zone_Nom = Planning_Interv_Zone_Nom;
    this.Planning_Interv_SiteId = Planning_Interv_SiteId;
    this.Planning_Interv_Site_Nom = Planning_Interv_Site_Nom;
    this.Planning_Interv_GroupeId = Planning_Interv_GroupeId;
    this.Planning_Interv_Groupe_Nom = Planning_Interv_Groupe_Nom;
    this.Planning_Interv_ClientId = Planning_Interv_ClientId;
    this.Planning_Interv_Client_Nom = Planning_Interv_Client_Nom;
  }

  factory Planning_Interv.fromJson(Map<String, dynamic> json) {

    Planning_Interv wplanningRdv = Planning_Interv(

      int.parse(json['InterventionId']),
      json['Intervention_Type'],
      json['Intervention_Parcs_Type'],
      json['Intervention_Status'],

      int.parse(json['ZoneId']),
      json['Zone_Nom'],
      int.parse(json['SiteId']),
      json['Site_Nom'],
      int.parse(json['GroupeId']),
      json['Groupe_Nom'],
      int.parse(json['ClientId']),
      json['Client_Nom'],
    );
    return wplanningRdv;
  }
  String Desc() {
 return '$Planning_Interv_InterventionId, '
        '$Planning_Interv_Intervention_Type, '
        '$Planning_Interv_Intervention_Parcs_Type,    '
        '$Planning_Interv_Intervention_Status,'
        '$Planning_Interv_ZoneId, '
        '$Planning_Interv_Zone_Nom, '
        '$Planning_Interv_SiteId, '
        '$Planning_Interv_Site_Nom, '
        '$Planning_Interv_GroupeId, '
        '$Planning_Interv_Groupe_Nom, '
        '$Planning_Interv_ClientId, '
        '$Planning_Interv_Client_Nom,  ';}















}
