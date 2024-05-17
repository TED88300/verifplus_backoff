
class Param_Param {

  int Param_ParamId = 0;
  String Param_Param_Type = "";
  String Param_Param_ID = "";
  String Param_Param_Text = "";
  int Param_Param_Int = 0;
  double Param_Param_Double = 0;
  int Param_Param_Ordre = 0;
  String Param_Param_Color = "Noir";


  static Param_ParamInit() {
    return Param_Param(
        0, "",  "", "", 0,0,0, "");
  }


  Param_Param(
  int Param_ParamId,
  String Param_Param_Type ,
  String Param_Param_ID,
  String Param_Param_Text,
  int Param_Param_Int,
  double Param_Param_Double,
      int Param_Param_Ordre,
      String Param_Param_Color,
      ) {
    this.Param_ParamId = Param_ParamId;
    this.Param_Param_Type = Param_Param_Type;
    this.Param_Param_ID = Param_Param_ID;
    this.Param_Param_Text = Param_Param_Text;
    this.Param_Param_Int = Param_Param_Int;
    this.Param_Param_Double = Param_Param_Double;
    this.Param_Param_Ordre = Param_Param_Ordre;
    this.Param_Param_Color = Param_Param_Color;
  }

  factory Param_Param.fromJson(Map<String, dynamic> json) {



    Param_Param wUser = Param_Param(
      int.parse(json['Param_ParamId']),
      json['Param_Param_Type'],
      json['Param_Param_ID'],
      json['Param_Param_Text'],
      int.parse(json['Param_Param_Int']),
      double.parse(json['Param_Param_Double']),
      int.parse(json['Param_Param_Ordre']),
      json['Param_Param_Color'],
    );

    return wUser;
  }

  String Desc() {
    return '$Param_ParamId $Param_Param_Type $Param_Param_ID $Param_Param_Text $Param_Param_Int $Param_Param_Double $Param_Param_Ordre $Param_Param_Color';
  }



}
