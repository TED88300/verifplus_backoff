


class Niveau_Desc {
  int Niveau_DescID = 0;
  int Niveau_Desc_NiveauID = 0;
  int Niveau_Desc_Param_DescID = 0;
  bool Niveau_Desc_MaintPrev = true;
  bool Niveau_Desc_Install = true;
  bool Niveau_Desc_MaintCorrect = true;
  int Niveau_Desc_Ordre = 0;

  String  Param_Saisie_Param_Label   = "";
  bool Niveau_Desc_Sel = false;

  static Niveau_DescInit() {
    return Niveau_Desc(0, 0, 0, false, false, false, 0, "", false);
  }
  Niveau_Desc(
    int   Niveau_DescID,
    int   Niveau_Desc_NiveauID,
    int   Niveau_Desc_Param_DescID,
    bool  Niveau_Desc_MaintPrev,
    bool  Niveau_Desc_Install,
    bool  Niveau_Desc_MaintCorrect,
      int   Niveau_Desc_Ordre,
    String  Param_Saisie_Param_Label,
      bool  Niveau_Desc_Sel,


      ) {
    this.Niveau_DescID  =  Niveau_DescID;
    this.Niveau_Desc_NiveauID  =  Niveau_Desc_NiveauID;
    this.Niveau_Desc_Param_DescID  =  Niveau_Desc_Param_DescID;
    this.Niveau_Desc_MaintPrev  =  Niveau_Desc_MaintPrev;
    this.Niveau_Desc_Install  =  Niveau_Desc_Install;
    this.Niveau_Desc_MaintCorrect  =  Niveau_Desc_MaintCorrect;
    this.Niveau_Desc_Ordre  =  Niveau_Desc_Ordre;
    this.Param_Saisie_Param_Label  =  Param_Saisie_Param_Label;
    this.Niveau_Desc_Sel  =  Niveau_Desc_Sel;
  }

  factory Niveau_Desc.fromJson(Map<String, dynamic> json) {
    int  iniveauDescMaintprev =      int.parse(json['Niveau_Desc_MaintPrev']);
    int  iniveauDescInstall =        int.parse(json['Niveau_Desc_Install']);
    int  iniveauDescMaintcorrect =   int.parse(json['Niveau_Desc_MaintCorrect']);
    bool bniveauDescMaintprev =      (iniveauDescMaintprev == 1);
    bool bniveauDescInstall =        (iniveauDescInstall == 1);
    bool bniveauDescMaintcorrect =   (iniveauDescMaintcorrect == 1);

    Niveau_Desc wNiveau = Niveau_Desc(
        int.parse(json['Niveau_DescID']),
        int.parse(json['Niveau_Desc_NiveauID']),
        int.parse(json['Niveau_Desc_Param_DescID']),
      bniveauDescMaintprev,
      bniveauDescInstall,
      bniveauDescMaintcorrect,
      int.parse(json['Niveau_Desc_Ordre']),
      json['Param_Saisie_Param_Label'],
      false

    );

    return wNiveau;
  }

  String Desc() {
    return '$Niveau_DescID $Niveau_Desc_NiveauID $Niveau_Desc_Param_DescID $Niveau_Desc_MaintPrev $Niveau_Desc_Install $Niveau_Desc_MaintCorrect $Niveau_Desc_Ordre $Param_Saisie_Param_Label $Niveau_Desc_Sel';
  }
}
