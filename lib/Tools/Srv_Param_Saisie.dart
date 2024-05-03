class Param_Saisie {
  int Param_SaisieId = 0;
  String Param_Saisie_Organe = "";
  String Param_Saisie_Type = "";
  String Param_Saisie_ID = "";
  String Param_Saisie_Label = "";
  String Param_Saisie_Aide = "";
  String Param_Saisie_Controle = "";
  int Param_Saisie_Ordre = 0;
  String Param_Saisie_Affichage = "";
  int Param_Saisie_Ordre_Affichage = 0;
  String Param_Saisie_Affichage_Titre = "";
  bool Param_Saisie_Affichage_L1 = false;
  int Param_Saisie_Affichage_L1_Ordre = 0;
  bool Param_Saisie_Affichage_L2 = false;
  int Param_Saisie_Affichage_L2_Ordre = 0;
  String Param_Saisie_Icon = "";
  String Param_Saisie_Triger = "";

  String Param_Saisie_Value = "";


  static Param_SaisieInit() {
    return Param_Saisie(0, "", "", "", "", "", "", 0, "", 0, "", false, 0, false, 0, "","");
  }


  String DescSimpl() {
    return 'id $Param_SaisieId '
        'ORDRE $Param_Saisie_Ordre  / $Param_Saisie_Affichage '
        'BASE $Param_Saisie_Organe '
        'CTRL $Param_Saisie_Controle '
        'ID $Param_Saisie_ID '
        'LABEL $Param_Saisie_Label '
        'ICON $Param_Saisie_Icon '
        'VALUE $Param_Saisie_Value ';
  }


  String Desc() {
    return 'id $Param_SaisieId '
        'Org $Param_Saisie_Organe '
        '$Param_Saisie_Type '
        'ID $Param_Saisie_ID '
        'LABEL $Param_Saisie_Label '
        'aide $Param_Saisie_Aide '
        'Ctrl $Param_Saisie_Controle '
        '$Param_Saisie_Ordre '
        '$Param_Saisie_Affichage '
        '$Param_Saisie_Ordre_Affichage '
        '$Param_Saisie_Affichage_Titre '
        '$Param_Saisie_Affichage_L1 '
        '$Param_Saisie_Affichage_L1_Ordre '
        '$Param_Saisie_Affichage_L2 '
        '$Param_Saisie_Affichage_L2_Ordre '
        'ICON $Param_Saisie_Icon '
        '$Param_Saisie_Triger '
        'VALUE $Param_Saisie_Value ';
  }

  Param_Saisie(
    int Param_SaisieId,
    String Param_Saisie_Organe,
    String Param_Saisie_Type,
    String Param_Saisie_ID,
    String Param_Saisie_Label,
    String Param_Saisie_Aide,
    String Param_Saisie_Controle,
    int Param_Saisie_Ordre,
    String Param_Saisie_Affichage,
    int Param_Saisie_Ordre_Affichage,
    String Param_Saisie_Affichage_Titre,
    bool Param_Saisie_Affichage_L1,
    int Param_Saisie_Affichage_L1_Ordre,
    bool Param_Saisie_Affichage_L2,
    int Param_Saisie_Affichage_L2_Ordre,
    String Param_Saisie_Icon,
      String Param_Saisie_Triger,

  ) {
    this.Param_SaisieId = Param_SaisieId;
    this.Param_Saisie_Organe = Param_Saisie_Organe;
    this.Param_Saisie_Type = Param_Saisie_Type;
    this.Param_Saisie_ID = Param_Saisie_ID;
    this.Param_Saisie_Label = Param_Saisie_Label;
    this.Param_Saisie_Aide = Param_Saisie_Aide;
    this.Param_Saisie_Controle = Param_Saisie_Controle;
    this.Param_Saisie_Ordre = Param_Saisie_Ordre;
    this.Param_Saisie_Affichage = Param_Saisie_Affichage;
    this.Param_Saisie_Ordre_Affichage = Param_Saisie_Ordre_Affichage;
    this.Param_Saisie_Affichage_Titre = Param_Saisie_Affichage_Titre;
    this.Param_Saisie_Affichage_L1 = Param_Saisie_Affichage_L1;
    this.Param_Saisie_Affichage_L1_Ordre = Param_Saisie_Affichage_L1_Ordre;
    this.Param_Saisie_Affichage_L2 = Param_Saisie_Affichage_L2;
    this.Param_Saisie_Affichage_L2_Ordre = Param_Saisie_Affichage_L2_Ordre;
    this.Param_Saisie_Icon = Param_Saisie_Icon;
    this.Param_Saisie_Triger = Param_Saisie_Triger;

  }

  factory Param_Saisie.fromJson(Map<String, dynamic> json) {
    Param_Saisie wUser = Param_Saisie(
      int.parse(json['Param_SaisieId']),
      json['Param_Saisie_Organe'],
      json['Param_Saisie_Type'],
      json['Param_Saisie_ID'],
      json['Param_Saisie_Label'],
      json['Param_Saisie_Aide'],
      json['Param_Saisie_Controle'],
      int.parse(json['Param_Saisie_Ordre']),
      json['Param_Saisie_Affichage'],
      int.parse(json['Param_Saisie_Ordre_Affichage']),
      json['Param_Saisie_Affichage_Titre'],
      int.parse(json['Param_Saisie_Affichage_L1']) == 1,
      int.parse(json['Param_Saisie_Affichage_L1_Ordre']),
      int.parse(json['Param_Saisie_Affichage_L2']) == 1,
      int.parse(json['Param_Saisie_Affichage_L2_Ordre']),
      json['Param_Saisie_Icon'],
        json['Param_Saisie_Triger'],


    );

    return wUser;
  }
}
