
/*
* INSERT INTO Niveau_Hab (Niveau_Hab_NiveauID, Niveau_Hab_Param_HabID, Niveau_Hab_Ordre)
  SELECT 1, Param_HabId, Param_Hab_OrdreFROM Param_Hab
  *
  *

SELECT Niveaux_Hab.* FROM Niveaux_Hab, Users where User_NivHabID = Niveau_Hab_NiveauID;




  * */


class Niveau_Hab {
  int Niveau_HabID = 0;
  int Niveau_Hab_NiveauID = 0;
  int Niveau_Hab_Param_HabID = 0;
  bool Niveau_Hab_MaintPrev = true;
  bool Niveau_Hab_Install = true;
  bool Niveau_Hab_MaintCorrect = true;
  int Niveau_Hab_Ordre = 0;

  String  Param_Hab_PDT   = "";
  String  Param_Hab_Grp   = "";
  bool Niveau_Hab_Sel = false;

  static Niveau_HabInit() {
    return Niveau_Hab(0, 0, 0, false, false, false, 0, "", "", false);
  }

  Niveau_Hab(
    int   Niveau_HabID,
    int   Niveau_Hab_NiveauID,
    int   Niveau_Hab_Param_HabID,
    bool  Niveau_Hab_MaintPrev,
    bool  Niveau_Hab_Install,
    bool  Niveau_Hab_MaintCorrect,
      int   Niveau_Hab_Ordre,
    String  Param_Hab_PDT,
    String  Param_Hab_Grp,
      bool  Niveau_Hab_Sel,


      ) {
    this.Niveau_HabID  =  Niveau_HabID;
    this.Niveau_Hab_NiveauID  =  Niveau_Hab_NiveauID;
    this.Niveau_Hab_Param_HabID  =  Niveau_Hab_Param_HabID;
    this.Niveau_Hab_MaintPrev  =  Niveau_Hab_MaintPrev;
    this.Niveau_Hab_Install  =  Niveau_Hab_Install;
    this.Niveau_Hab_MaintCorrect  =  Niveau_Hab_MaintCorrect;
    this.Niveau_Hab_Ordre  =  Niveau_Hab_Ordre;
    this.Param_Hab_PDT  =  Param_Hab_PDT;
    this.Param_Hab_Grp  =  Param_Hab_Grp;
    this.Niveau_Hab_Sel  =  Niveau_Hab_Sel;
  }

  factory Niveau_Hab.fromJson(Map<String, dynamic> json) {
    int  iniveauHabMaintprev =      int.parse(json['Niveau_Hab_MaintPrev']);
    int  iniveauHabInstall =        int.parse(json['Niveau_Hab_Install']);
    int  iniveauHabMaintcorrect =   int.parse(json['Niveau_Hab_MaintCorrect']);
    bool bniveauHabMaintprev =      (iniveauHabMaintprev == 1);
    bool bniveauHabInstall =        (iniveauHabInstall == 1);
    bool bniveauHabMaintcorrect =   (iniveauHabMaintcorrect == 1);

    Niveau_Hab wNiveau = Niveau_Hab(
        int.parse(json['Niveau_HabID']),
        int.parse(json['Niveau_Hab_NiveauID']),
        int.parse(json['Niveau_Hab_Param_HabID']),
      bniveauHabMaintprev,
      bniveauHabInstall,
      bniveauHabMaintcorrect,
      int.parse(json['Niveau_Hab_Ordre']),
      json['Param_Hab_PDT'],
      json['Param_Hab_Grp'],
      false

    );

    return wNiveau;
  }

  String Desc() {
    return '$Niveau_HabID $Niveau_Hab_NiveauID $Niveau_Hab_Param_HabID $Niveau_Hab_MaintPrev $Niveau_Hab_Install $Niveau_Hab_MaintCorrect $Niveau_Hab_Ordre $Param_Hab_PDT $Param_Hab_Grp $Niveau_Hab_Sel';
  }
}
