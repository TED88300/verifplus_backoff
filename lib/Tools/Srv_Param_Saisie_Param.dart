class Param_Saisie_Param {
  int Param_Saisie_ParamId = 0;
  String Param_Saisie_Param_Id = "";
  int Param_Saisie_Param_Ordre = 0;
  String Param_Saisie_Param_Label = "";
  String Param_Saisie_Param_Abrev = "";
  String Param_Saisie_Param_Aide = "";
  bool Param_Saisie_Param_Default = false;
  bool Param_Saisie_Param_Init = false;
  String Param_Saisie_Param_Color = "";
  static Param_Saisie_ParamInit() {
    return Param_Saisie_Param(0, "", 0, "", "", "", false, false,"");
  }

  String Desc() {
    return '$Param_Saisie_ParamId '
        '$Param_Saisie_Param_Id '
        '$Param_Saisie_Param_Ordre '
        '$Param_Saisie_Param_Label '
        '$Param_Saisie_Param_Abrev '
        '$Param_Saisie_Param_Aide '
        '$Param_Saisie_Param_Default '
        '$Param_Saisie_Param_Init ';
    '$Param_Saisie_Param_Color ';
  }

  Param_Saisie_Param(
    int Param_Saisie_ParamId,
    String Param_Saisie_Param_Id,
    int Param_Saisie_Param_Ordre,
    String Param_Saisie_Param_Label,
      String Param_Saisie_Param_Abrev,
    String Param_Saisie_Param_Aide,
    bool Param_Saisie_Param_Default,
    bool Param_Saisie_Param_Init,
      String Param_Saisie_Param_Color,
  ) {
    this.Param_Saisie_ParamId = Param_Saisie_ParamId;
    this.Param_Saisie_Param_Id = Param_Saisie_Param_Id;
    this.Param_Saisie_Param_Ordre = Param_Saisie_Param_Ordre;
    this.Param_Saisie_Param_Label = Param_Saisie_Param_Label;
    this.Param_Saisie_Param_Abrev = Param_Saisie_Param_Abrev;
    this.Param_Saisie_Param_Aide = Param_Saisie_Param_Aide;
    this.Param_Saisie_Param_Default = Param_Saisie_Param_Default;
    this.Param_Saisie_Param_Init = Param_Saisie_Param_Init;
    this.Param_Saisie_Param_Color = Param_Saisie_Param_Color;
  }

  factory Param_Saisie_Param.fromJson(Map<String, dynamic> json) {
    Param_Saisie_Param wUser = Param_Saisie_Param(
      int.parse(json['Param_Saisie_ParamId']),
      json['Param_Saisie_Param_Id'],
      int.parse(json['Param_Saisie_Param_Ordre']),
      json['Param_Saisie_Param_Label'],
      json['Param_Saisie_Param_Abrev'],
      json['Param_Saisie_Param_Aide'],
      int.parse(json['Param_Saisie_Param_Default']) == 1,
      int.parse(json['Param_Saisie_Param_Init']) == 1,
      json['Param_Saisie_Param_Color'],
    );

    return wUser;
  }
}
