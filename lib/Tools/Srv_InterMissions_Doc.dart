class InterMissions_Doc {
  int? InterMissionsDocID = 0;
  int? InterMissionsDocInterMissionId = 0;
  int? InterMissionsDocDocID = 0;

  InterMissions_Doc(
      {this.InterMissionsDocID,
        this.InterMissionsDocInterMissionId,
        this.InterMissionsDocDocID});

  InterMissions_Doc.fromJson(Map<String, dynamic> json) {
    InterMissionsDocID = json['InterMissionsDocID'];
    InterMissionsDocInterMissionId = json['InterMissionsDocInterMissionId'];
    InterMissionsDocDocID = json['InterMissionsDocDocID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InterMissionsDocID'] = this.InterMissionsDocID;
    data['InterMissionsDocInterMissionId'] = this.InterMissionsDocInterMissionId;
    data['InterMissionsDocDocID'] = this.InterMissionsDocDocID;
    return data;
  }
}