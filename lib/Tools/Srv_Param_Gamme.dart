class Param_Gamme {
  int Param_GammeId = 0;
  String Param_Gamme_Type_Organe = "";
  int Param_Gamme_DESC_Id = 0;
  String Param_Gamme_DESC_Lib = "";
  int Param_Gamme_FAB_Id = 0;
  String Param_Gamme_FAB_Lib = "";
  int Param_Gamme_PRS_Id = 0;
  String Param_Gamme_PRS_Lib = "";
  int Param_Gamme_CLF_Id = 0;
  String Param_Gamme_CLF_Lib = "";
  int Param_Gamme_MOB_Id = 0;
  String Param_Gamme_MOB_Lib = "";
  int Param_Gamme_GAM_Id = 0;
  String Param_Gamme_GAM_Lib = "";
  int Param_Gamme_PDT_Id = 0;
  String Param_Gamme_PDT_Lib = "";
  int Param_Gamme_POIDS_Id = 0;
  String Param_Gamme_POIDS_Lib = "";
  String Param_Gamme_REF = "";
  int Param_Gamme_Ordre = 0;

  static Param_GammeInit() {
    return Param_Gamme(0, "", 0, "", 0, "", 0, "", 0, "", 0, "", 0, "", 0, "", 0, "", "", 0);
  }

  Param_Gamme(
    int Param_GammeId,
    String Param_Gamme_Type_Organe,
    int Param_Gamme_DESC_Id,
    String Param_Gamme_DESC_Lib,
    int Param_Gamme_FAB_Id,
    String Param_Gamme_FAB_Lib,
    int Param_Gamme_PRS_Id,
    String Param_Gamme_PRS_Lib,
    int Param_Gamme_CLF_Id,
    String Param_Gamme_CLF_Lib,
    int Param_Gamme_MOB_Id,
    String Param_Gamme_MOB_Lib,
    int Param_Gamme_GAM_Id,
    String Param_Gamme_GAM_Lib,
    int Param_Gamme_PDT_Id,
    String Param_Gamme_PDT_Lib,
    int Param_Gamme_POIDS_Id,
    String Param_Gamme_POIDS_Lib,
    String Param_Gamme_REF,
    int Param_Gamme_Ordre,
  ) {
    /*
  Param_GammeId
  Param_Gamme_Type_Organe
  Param_Gamme_DESC_Id
  Param_Gamme_DESC_Lib
  Param_Gamme_FAB_Id
  Param_Gamme_FAB_Lib
  Param_Gamme_PRS_Id
  Param_Gamme_PRS_Lib
  Param_Gamme_CLF_Id
  Param_Gamme_CLF_Lib
  Param_Gamme_GAM_Id
  Param_Gamme_GAM_Lib
  Param_Gamme_PDT_Id
  Param_Gamme_PDT_Lib
  Param_Gamme_POIDS_Id
  Param_Gamme_POIDS_Lib
  Param_Gamme_REF
*/

    this.Param_GammeId = Param_GammeId;
    this.Param_Gamme_Type_Organe = Param_Gamme_Type_Organe;
    this.Param_Gamme_DESC_Id = Param_Gamme_DESC_Id;
    this.Param_Gamme_DESC_Lib = Param_Gamme_DESC_Lib;
    this.Param_Gamme_FAB_Id = Param_Gamme_FAB_Id;
    this.Param_Gamme_FAB_Lib = Param_Gamme_FAB_Lib;
    this.Param_Gamme_PRS_Id = Param_Gamme_PRS_Id;
    this.Param_Gamme_PRS_Lib = Param_Gamme_PRS_Lib;
    this.Param_Gamme_CLF_Id = Param_Gamme_CLF_Id;
    this.Param_Gamme_CLF_Lib = Param_Gamme_CLF_Lib;
    this.Param_Gamme_MOB_Id = Param_Gamme_MOB_Id;
    this.Param_Gamme_MOB_Lib = Param_Gamme_MOB_Lib;
    this.Param_Gamme_GAM_Id = Param_Gamme_GAM_Id;
    this.Param_Gamme_GAM_Lib = Param_Gamme_GAM_Lib;
    this.Param_Gamme_PDT_Id = Param_Gamme_PDT_Id;
    this.Param_Gamme_PDT_Lib = Param_Gamme_PDT_Lib;
    this.Param_Gamme_POIDS_Id = Param_Gamme_POIDS_Id;
    this.Param_Gamme_POIDS_Lib = Param_Gamme_POIDS_Lib;
    this.Param_Gamme_REF = Param_Gamme_REF;
    this.Param_Gamme_Ordre = Param_Gamme_Ordre;
  }

  factory Param_Gamme.fromJson(Map<String, dynamic> json) {
//    print("json['Param_Gamme_FAB_Lib'] |${json['Param_Gamme_FAB_Lib']}|");

    Param_Gamme wUser = Param_Gamme(
      int.parse(json['Param_GammeId']),
      json['Param_Gamme_Type_Organe'],
      int.parse(json['Param_Gamme_DESC_Id']),
      json['Param_Gamme_DESC_Lib'],
      int.parse(json['Param_Gamme_FAB_Id']),
      json['Param_Gamme_FAB_Lib'],
      int.parse(json['Param_Gamme_PRS_Id']),
      json['Param_Gamme_PRS_Lib'],
      int.parse(json['Param_Gamme_CLF_Id']),
      json['Param_Gamme_CLF_Lib'],
      int.parse(json['Param_Gamme_MOB_Id']),
      json['Param_Gamme_MOB_Lib'],
      int.parse(json['Param_Gamme_GAM_Id']),
      json['Param_Gamme_GAM_Lib'],
      int.parse(json['Param_Gamme_PDT_Id']),
      json['Param_Gamme_PDT_Lib'],
      int.parse(json['Param_Gamme_POIDS_Id']),
      json['Param_Gamme_POIDS_Lib'],
      json['Param_Gamme_REF'],
      int.parse(json['Param_Gamme_Ordre']),
    );

    return wUser;
  }

  String Desc() {
    return "$Param_GammeId"
        " $Param_Gamme_Type_Organe"
        " $Param_Gamme_DESC_Id"
        " $Param_Gamme_DESC_Lib"
        " $Param_Gamme_FAB_Id"
        " $Param_Gamme_FAB_Lib"
        " $Param_Gamme_PRS_Id"
        " $Param_Gamme_PRS_Lib"
        " $Param_Gamme_CLF_Id"
        " $Param_Gamme_CLF_Lib"
        " $Param_Gamme_MOB_Id"
        " $Param_Gamme_MOB_Lib"
        " $Param_Gamme_GAM_Id"
        " $Param_Gamme_GAM_Lib"
        " $Param_Gamme_PDT_Id"
        " $Param_Gamme_PDT_Lib"
        " $Param_Gamme_POIDS_Id"
        " $Param_Gamme_POIDS_Lib"
        " $Param_Gamme_REF"
        " $Param_Gamme_Ordre";
  }
}
