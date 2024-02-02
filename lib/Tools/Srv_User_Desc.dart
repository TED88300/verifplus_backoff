
class User_Desc {
  int User_DescID = 0;
  int User_Desc_UserID = 0;
  int User_Desc_Param_DescID = 0;
  bool User_Desc_MaintPrev = true;
  bool User_Desc_Install = true;
  bool User_Desc_MaintCorrect = true;
  int User_Desc_Ordre = 0;

  String  Param_Desc_Lib   = "";
  bool User_Desc_Sel = false;

  static User_DescInit() {
    return User_Desc(0, 0, 0, false, false, false, 0, "",  false);
  }

  User_Desc(
    int   User_DescID,
    int   User_Desc_UserID,
    int   User_Desc_Param_DescID,
    bool  User_Desc_MaintPrev,
    bool  User_Desc_Install,
    bool  User_Desc_MaintCorrect,
      int   User_Desc_Ordre,
    String  Param_Desc_Lib,
      bool  User_Desc_Sel,


      ) {
    this.User_DescID  =  User_DescID;
    this.User_Desc_UserID  =  User_Desc_UserID;
    this.User_Desc_Param_DescID  =  User_Desc_Param_DescID;
    this.User_Desc_MaintPrev  =  User_Desc_MaintPrev;
    this.User_Desc_Install  =  User_Desc_Install;
    this.User_Desc_MaintCorrect  =  User_Desc_MaintCorrect;
    this.User_Desc_Ordre  =  User_Desc_Ordre;
    this.Param_Desc_Lib  =  Param_Desc_Lib;

    this.User_Desc_Sel  =  User_Desc_Sel;
  }

  factory User_Desc.fromJson(Map<String, dynamic> json) {
    int  iuserDescMaintprev =      int.parse(json['User_Desc_MaintPrev']);
    int  iuserDescInstall =        int.parse(json['User_Desc_Install']);
    int  iuserDescMaintcorrect =   int.parse(json['User_Desc_MaintCorrect']);
    bool buserDescMaintprev =      (iuserDescMaintprev == 1);
    bool buserDescInstall =        (iuserDescInstall == 1);
    bool buserDescMaintcorrect =   (iuserDescMaintcorrect == 1);

    print("json['User_Desc_Ordre'] ${json['User_Desc_Ordre']}");

    User_Desc wUser = User_Desc(
        int.parse(json['User_DescID']),
        int.parse(json['User_Desc_UserID']),
        int.parse(json['User_Desc_Param_DescID']),
      buserDescMaintprev,
      buserDescInstall,
      buserDescMaintcorrect,
      int.parse(json['User_Desc_Ordre']),
        json['Param_Saisie_Param_Label'],
      false

    );

    return wUser;
  }

  String Desc() {
    return '$User_DescID $User_Desc_UserID $User_Desc_Param_DescID $User_Desc_MaintPrev $User_Desc_Install $User_Desc_MaintCorrect $User_Desc_Ordre $Param_Desc_Lib $User_Desc_Sel';
  }
}
