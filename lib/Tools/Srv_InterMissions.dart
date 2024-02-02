class InterMission {
  int InterMissionId = 0;
  int InterMission_InterventionId = 0;
  String InterMission_Nom = "";
  bool InterMission_Exec = false;
  String InterMission_Date = "";
  String InterMission_Note = "";

  static InterMissionInit() {
    return InterMission(0, 0, "", false, "", "");
  }

  InterMission(
    int InterMissionId,
    int InterMission_InterventionId,
    String InterMission_Nom,
    bool InterMission_Exec,
    String InterMission_Date,
    String InterMission_Note,
  ) {
    this.InterMissionId = InterMissionId;
    this.InterMission_InterventionId = InterMission_InterventionId;
    this.InterMission_Nom = InterMission_Nom;
    this.InterMission_Exec = InterMission_Exec;
    this.InterMission_Date = InterMission_Date;
    this.InterMission_Note = InterMission_Note;
  }

  factory InterMission.fromJson(Map<String, dynamic> json) {
    InterMission wInterMission = InterMission(
      int.parse(json['InterMissionId']),
      int.parse(json['InterMission_InterventionId']),
      json['InterMission_Nom'],
      int.parse(json['InterMission_Exec']) == 1,
      json['InterMission_Date'],
      json['InterMission_Note'],
    );
    return wInterMission;
  }

  String Desc() {
    return '$InterMissionId                '
        '$InterMission_InterventionId  '
        '$InterMission_Nom              '
        '$InterMission_Exec             '
        '$InterMission_Date             '
        '$InterMission_Note             ';
  }
}
