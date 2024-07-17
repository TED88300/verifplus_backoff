class InterMissions_Documents {
  String? interMissionsDocInterMissionId;
  String? docID;
  String? docNom;
  String? docDate;
  String? docLength;
  String? docCRC;
  String? docUserMat;

  InterMissions_Documents(
      {this.interMissionsDocInterMissionId,
        this.docID,
        this.docNom,
        this.docDate,
        this.docLength,
        this.docCRC,
        this.docUserMat});

  InterMissions_Documents.fromJson(Map<String, dynamic> json) {
    interMissionsDocInterMissionId = json['InterMissions_Doc_InterMissionId'];
    docID = json['DocID'];
    docNom = json['Doc_Nom'];
    docDate = json['Doc_Date'];
    docLength = json['Doc_Length'];
    docCRC = json['Doc_CRC'];
    docUserMat = json['Doc_User_Mat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InterMissions_Doc_InterMissionId'] =
        this.interMissionsDocInterMissionId;
    data['DocID'] = this.docID;
    data['Doc_Nom'] = this.docNom;
    data['Doc_Date'] = this.docDate;
    data['Doc_Length'] = this.docLength;
    data['Doc_CRC'] = this.docCRC;
    data['Doc_User_Mat'] = this.docUserMat;
    return data;
  }
}
