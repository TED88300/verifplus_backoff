

class Param_Hab {



  int     Param_HabId     = 0;
  String  Param_Hab_PDT   = "";
  String  Param_Hab_Grp   = "";
  int     Param_Hab_Ordre = 0;

  static Param_HabInit() {
    return Param_Hab(0, "",  "", 0);
  }


  Param_Hab(
  int     Param_HabId     ,
  String  Param_Hab_PDT  ,
  String  Param_Hab_Grp    ,
      int     Param_Hab_Ordre     ,

      ) {
    this.Param_HabId    = Param_HabId     ;
    this.Param_Hab_PDT = Param_Hab_PDT  ;
    this.Param_Hab_Grp   = Param_Hab_Grp    ;
    this.Param_Hab_Ordre   = Param_Hab_Ordre    ;

  }

  factory Param_Hab.fromJson(Map<String, dynamic> json) {

    print("json $json");
    Param_Hab wUser = Param_Hab(
      int.parse(json['Param_HabID']),
      json['Param_Hab_PDT'],
      json['Param_Hab_Grp'],
      int.parse(json['Param_Hab_Ordre']),

    );

    return wUser;
  }

  String Desc() {
    return '$Param_HabId $Param_Hab_PDT $Param_Hab_Grp $Param_Hab_Ordre';
  }



}
